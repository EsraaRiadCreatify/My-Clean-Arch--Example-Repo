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
import 'api_request_handler.dart';
import 'api_error_handler.dart';
import 'api_headers_handler.dart';

class ApiClient {
  final Dio _dio;
  final ApiConfig _config;
  final ApiCache? _cache;
  final ApiRequestHandler _requestHandler;
  final ApiErrorHandler _errorHandler;
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
       )),
       _requestHandler = ApiRequestHandler(
         Dio(BaseOptions(
           baseUrl: config.baseUrl,
           connectTimeout: config.timeout,
           headers: config.headers,
         )),
         cache,
       ),
       _errorHandler = ApiErrorHandler(onUnauthorized: onUnauthorized) {
    _setupDio(interceptor);
  }

  void _setupDio(ApiInterceptor? interceptor) {
    _dio.options.baseUrl = _config.baseUrl;
    _dio.options.connectTimeout = _config.timeout;
    _dio.options.receiveTimeout = _config.timeout;
    _dio.options.headers = ApiHeadersHandler.getDefaultHeaders();

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
    try {
      final response = await _requestHandler.request<T>(
        endpoint: endpoint,
        method: 'GET',
        queryParameters: {
          ...ApiHeadersHandler.getDefaultQueryParameters(),
          ...queryParameters ?? {},
        },
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        handleError: handleError,
        showLoading: showLoading,
        isGlobalLoader: isGlobalLoader,
      );
      
      return returnFullResponse ? response as T : response.data as T;
    } catch (e) {
      if (handleError) {
        _errorHandler.handleError(e);
      }
      rethrow;
    }
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
    try {
      final response = await _requestHandler.request<T>(
        endpoint: endpoint,
        method: 'POST',
        data: data,
        queryParameters: {
          ...ApiHeadersHandler.getDefaultQueryParameters(),
          ...queryParameters ?? {},
        },
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        handleError: handleError,
        showLoading: showLoading,
        isGlobalLoader: isGlobalLoader,
      );
      
      return returnFullResponse ? response as T : response.data as T;
    } catch (e) {
      if (handleError) {
        _errorHandler.handleError(e);
      }
      rethrow;
    }
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
    try {
      final response = await _requestHandler.request<T>(
        endpoint: endpoint,
        method: 'PUT',
        data: data,
        queryParameters: {
          ...ApiHeadersHandler.getDefaultQueryParameters(),
          ...queryParameters ?? {},
        },
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        handleError: handleError,
        showLoading: showLoading,
        isGlobalLoader: isGlobalLoader,
      );
      
      return returnFullResponse ? response as T : response.data as T;
    } catch (e) {
      if (handleError) {
        _errorHandler.handleError(e);
      }
      rethrow;
    }
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
    try {
      final response = await _requestHandler.request<T>(
        endpoint: endpoint,
        method: 'DELETE',
        data: data,
        queryParameters: {
          ...ApiHeadersHandler.getDefaultQueryParameters(),
          ...queryParameters ?? {},
        },
        options: options,
        cancelToken: cancelToken,
        handleError: handleError,
        showLoading: showLoading,
        isGlobalLoader: isGlobalLoader,
      );
      
      return returnFullResponse ? response as T : response.data as T;
    } catch (e) {
      if (handleError) {
        _errorHandler.handleError(e);
      }
      rethrow;
    }
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
    try {
      final response = await _requestHandler.request<T>(
        endpoint: endpoint,
        method: 'PATCH',
        data: data,
        queryParameters: {
          ...ApiHeadersHandler.getDefaultQueryParameters(),
          ...queryParameters ?? {},
        },
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        handleError: handleError,
        showLoading: showLoading,
        isGlobalLoader: isGlobalLoader,
      );
      
      return returnFullResponse ? response as T : response.data as T;
    } catch (e) {
      if (handleError) {
        _errorHandler.handleError(e);
      }
      rethrow;
    }
  }

  void cancelRequests() {
    _cancelToken.cancel();
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