import 'dart:convert';
import 'package:dio/dio.dart';
import '../base/api_exception.dart';
import '../../shared_widgets/loading/loading_controller.dart';
import '../config/api_config.dart';
import '../config/api_interceptor.dart';
import '../base/api_response.dart';
import '../utils/api_validator.dart';
import '../utils/api_cache.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class ApiClient {
  final Dio _dio;
  final ApiConfig _config;
  final ApiCache? _cache;
  final CancelToken _cancelToken = CancelToken();
  final _loadingController = LoadingController();
  
  Dio get dio => _dio;
  
  // Callback for unauthorized handling
  void Function()? onUnauthorized;
  
  ApiClient({
    required ApiConfig config,
    ApiCache? cache,
    ApiInterceptor? interceptor,
    this.onUnauthorized,
  }) : _config = config,
       _cache = cache,
       _dio = Dio(BaseOptions(
         baseUrl: config.baseUrl,
         connectTimeout: config.timeout,
         headers: config.headers,
       )) {
    _setupDio(interceptor);
  }

  void _setupDio(ApiInterceptor? interceptor) {
    _dio.options.baseUrl = _config.baseUrl;
    _dio.options.connectTimeout = _config.timeout;
    _dio.options.receiveTimeout = _config.timeout;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (interceptor != null) {
      _dio.interceptors.add(interceptor);
    }
  }

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool handleError = true,
    bool showLoading = true,
    bool isGlobalLoader = true,
    bool returnFullResponse = false,
  }) async {
    final response = await _request<T>(
      endpoint: endpoint,
      method: RequestMethod.get,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      handleError: handleError,
      showLoading: showLoading,
      isGlobalLoader: isGlobalLoader,
    );
    
    return returnFullResponse ? response as T : response.data as T;
  }

  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool handleError = true,
    bool showLoading = true,
    bool isGlobalLoader = true,
    bool returnFullResponse = false,
  }) async {
    final response = await _request<T>(
      endpoint: endpoint,
      method: RequestMethod.post,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      handleError: handleError,
      showLoading: showLoading,
      isGlobalLoader: isGlobalLoader,
    );
    
    return returnFullResponse ? response as T : response.data as T;
  }

  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool handleError = true,
    bool showLoading = true,
    bool isGlobalLoader = true,
    bool returnFullResponse = false,
  }) async {
    final response = await _request<T>(
      endpoint: endpoint,
      method: RequestMethod.put,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      handleError: handleError,
      showLoading: showLoading,
      isGlobalLoader: isGlobalLoader,
    );
    
    return returnFullResponse ? response as T : response.data as T;
  }

  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool handleError = true,
    bool showLoading = true,
    bool isGlobalLoader = true,
    bool returnFullResponse = false,
  }) async {
    final response = await _request<T>(
      endpoint: endpoint,
      method: RequestMethod.delete,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      handleError: handleError,
      showLoading: showLoading,
      isGlobalLoader: isGlobalLoader,
    );
    
    return returnFullResponse ? response as T : response.data as T;
  }

  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool handleError = true,
    bool showLoading = true,
    bool isGlobalLoader = true,
    bool returnFullResponse = false,
  }) async {
    final response = await _request<T>(
      endpoint: endpoint,
      method: RequestMethod.patch,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      handleError: handleError,
      showLoading: showLoading,
      isGlobalLoader: isGlobalLoader,
    );
    
    return returnFullResponse ? response as T : response.data as T;
  }

  Future<Response<T>> _request<T>({
    required String endpoint,
    required RequestMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool handleError = true,
    bool showLoading = true,
    bool isGlobalLoader = true,
    bool? useCache,
    Duration? cacheDuration,
    bool? validateResponse,
    bool isFormData = false,
  }) async {
    try {
      if (showLoading) {
        _loadingController.startLoading(
          isGlobal: isGlobalLoader,
          message: _getLoadingMessage(method),
        );
      }

      // Check cache first if enabled
      final shouldUseCache = useCache ?? _config.useCache;
      if (shouldUseCache && _cache != null) {
        final cachedData = await _cache!.getCachedResponse<T>(
          key: _getCacheKey(endpoint, queryParameters),
        );
        
        if (cachedData != null) {
          if (showLoading) {
            _loadingController.stopLoading(isGlobal: isGlobalLoader);
          }
          return Response(
            data: cachedData,
            statusCode: 200,
            requestOptions: RequestOptions(path: endpoint),
          );
        }
      }

      // Make the request
      final response = await _dio.request<T>(
        endpoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        queryParameters: {
          ...queryParameters ?? {},
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'lang': 'ar',
        },
        options: Options(
          method: method.name,
          headers: {
            ..._getDefaultHeaders(),
            ...options?.headers ?? {},
          },
          contentType: options?.contentType,
        ),
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Validate response if enabled
      final shouldValidate = validateResponse ?? _config.validateResponse;
      if (shouldValidate) {
        final apiResponse = ApiResponse<T>(
          data: response.data,
          statusCode: response.statusCode,
          success: true,
        );
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

      return response;
    } catch (e) {
      if (handleError) {
        _handleError(e);
      }
      rethrow;
    } finally {
      if (showLoading) {
        _loadingController.stopLoading(isGlobal: isGlobalLoader);
      }
    }
  }

  String _getLoadingMessage(RequestMethod method) {
    switch (method) {
      case RequestMethod.get:
        return "جاري جلب البيانات...";
      case RequestMethod.post:
        return "جاري إرسال البيانات...";
      case RequestMethod.put:
      case RequestMethod.patch:
        return "جاري تحديث البيانات...";
      case RequestMethod.delete:
        return "جاري حذف البيانات...";
      default:
        return "جاري معالجة الطلب...";
    }
  }

  void _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException();
        case DioExceptionType.badResponse:
          _handleResponseError(error.response);
          break;
        case DioExceptionType.cancel:
          throw ApiException(message: 'تم إلغاء الطلب');
        case DioExceptionType.connectionError:
          throw NetworkException();
        case DioExceptionType.unknown:
          throw ApiException(message: 'حدث خطأ غير متوقع');
        case DioExceptionType.badCertificate:
          throw ApiException(message: 'شهادة غير صالحة');
      }
    }
    throw ApiException(message: error.toString());
  }

  void _handleResponseError(Response? response) {
    if (response == null) {
      throw ServerException();
    }

    switch (response.statusCode) {
      case 400:
        throw ApiException(message: _parseError(response));
      case 401:
        _handleUnauthorized();
        throw UnauthorizedException();
      case 403:
        throw ApiException(message: 'غير مسموح لك بالوصول');
      case 404:
        throw NotFoundException();
      case 500:
        throw ServerException();
      default:
        throw ServerException();
    }
  }

  void _handleUnauthorized() {
    // Clear user data from all storage types
    _clearUserData();
    
    // Call the unauthorized callback if provided
    onUnauthorized?.call();
  }

  void _clearUserData() {
    // Clear from SharedPreferences
    GetIt.I<SharedPreferences>().clear();
    
    // Clear from Hive
    GetIt.I<Box>().clear();
    
    // Clear from Memory Storage
    GetIt.I<Map<String, dynamic>>().clear();
  }

  String _parseError(Response response) {
    try {
      final data = response.data;
      if (data is String) {
        final json = jsonDecode(data);
        return json['message'] ?? json['error'] ?? 'حدث خطأ';
      } else if (data is Map) {
        return data['message'] ?? data['error'] ?? 'حدث خطأ';
      }
      return 'حدث خطأ';
    } catch (e) {
      return 'حدث خطأ';
    }
  }

  Map<String, String> _getDefaultHeaders() {
    return {
      'Accept': 'image/webp,image/*,*/*;q=0.8',
      'device': 'myApp',
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'lang': 'ar',
    };
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