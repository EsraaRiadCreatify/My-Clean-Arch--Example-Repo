import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/api_interceptor.dart';
import '../base/api_exception.dart';
import '../base/api_response.dart';
import '../utils/api_validator.dart';
import '../utils/api_cache.dart';
import 'dart:io';

class ApiClient {
  final Dio _dio;
  final ApiConfig _config;
  final ApiCache? _cache;
  final CancelToken _cancelToken = CancelToken();
  
  ApiClient({
    required ApiConfig config,
    ApiCache? cache,
    ApiInterceptor? interceptor,
  }) : _config = config,
       _cache = cache,
       _dio = Dio(BaseOptions(
         baseUrl: config.baseUrl,
         connectTimeout: config.timeout,
         headers: config.headers,
       )) {
    _initDio(interceptor);
  }

  void _initDio(ApiInterceptor? interceptor) {
    // Add custom interceptor if provided
    if (interceptor != null) {
      _dio.interceptors.add(interceptor);
    }

    // Add default interceptors
    _dio.interceptors.addAll([
      _authInterceptor(),
      _loggingInterceptor(),
      _errorInterceptor(),
    ]);
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if exists
        final token = StorageService.getUser()?.token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }

  InterceptorsWrapper _loggingInterceptor() {
    return LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _handleTokenExpiration();
        }
        return handler.next(error);
      },
    );
  }

  Future<void> _handleTokenExpiration() async {
    StorageService.removeUser();
    // Navigate to login or handle token expiration
  }

  Map<String, String> _getDefaultHeaders() {
    return {
      'Accept': 'image/webp,image/*,*/*;q=0.8',
      'device': 'myApp',
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'lang': StorageService.getLang(),
    };
  }

  Future<ApiResponse<T>> request<T>({
    required String endpoint,
    required RequestMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool? useCache,
    Duration? cacheDuration,
    bool? handleErrors,
    bool? returnErrorResponse,
    bool? validateResponse,
    bool showLoading = false,
    bool isFormData = false,
  }) async {
    final shouldUseCache = useCache ?? _config.useCache;
    final shouldHandleErrors = handleErrors ?? _config.handleErrors;
    final shouldReturnError = returnErrorResponse ?? _config.returnErrorResponse;
    final shouldValidate = validateResponse ?? _config.validateResponse;

    try {
      if (showLoading) Loader.start();

      // Check cache first if enabled
      if (shouldUseCache && _cache != null) {
        final cachedData = await _cache!.getCachedResponse<T>(
          key: _getCacheKey(endpoint, queryParameters),
        );
        
        if (cachedData != null) {
          if (showLoading) Loader.stop();
          return ApiResponse<T>(
            data: cachedData,
            success: true,
          );
        }
      }

      // Make the request
      final response = await _dio.request(
        endpoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        queryParameters: {
          ...queryParameters ?? {},
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'lang': StorageService.getLang(),
        },
        options: Options(
          method: method.name,
          headers: {
            ..._getDefaultHeaders(),
            ...options?.headers ?? {},
          },
          contentType: options?.contentType,
        ),
        cancelToken: _cancelToken,
      );

      if (showLoading) Loader.stop();

      final apiResponse = ApiResponse<T>(
        data: response.data,
        statusCode: response.statusCode,
        success: true,
      );

      // Validate response if enabled
      if (shouldValidate) {
        ApiValidator.validateResponse(apiResponse);
      }

      // Cache response if enabled
      if (shouldUseCache && _cache != null) {
        await _cache!.cacheResponse(
          key: _getCacheKey(endpoint, queryParameters),
          data: response.data,
          cacheDuration: cacheDuration,
        );
      }

      return apiResponse;
    } catch (e) {
      if (showLoading) Loader.stop();

      if (!shouldHandleErrors) {
        rethrow;
      }

      if (shouldReturnError) {
        if (e is ApiException) {
          return ApiResponse<T>(
            message: e.message,
            statusCode: e.statusCode,
            success: false,
          );
        }

        return ApiResponse<T>(
          message: e.toString(),
          success: false,
        );
      }

      throw ApiException.fromError(e);
    }
  }

  // Convenience methods for common HTTP methods
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool? useCache,
    Duration? cacheDuration,
    bool? handleErrors,
    bool? returnErrorResponse,
    bool? validateResponse,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: RequestMethod.get,
      queryParameters: queryParameters,
      options: options,
      useCache: useCache,
      cacheDuration: cacheDuration,
      handleErrors: handleErrors,
      returnErrorResponse: returnErrorResponse,
      validateResponse: validateResponse,
    );
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: RequestMethod.post,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: RequestMethod.put,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return request<T>(
      endpoint: endpoint,
      queryParameters: queryParameters,
      method: RequestMethod.delete,
      data: data,
      options: options,
    );
  }

  void cancelRequests() {
    _cancelToken.cancel();
  }

  String _getCacheKey(String endpoint, Map<String, dynamic>? queryParameters) {
    final queryString = queryParameters?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return queryString != null ? '$endpoint?$queryString' : endpoint;
  }
}

enum RequestMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
} 