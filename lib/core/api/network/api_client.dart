import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/api_interceptor.dart';
import '../utils/api_cache.dart';
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
}

enum RequestMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
} 