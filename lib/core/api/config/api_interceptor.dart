
import 'package:clean_architecture_example/core/api/base/api_exception.dart';
import 'package:clean_architecture_example/core/api/utils/api_logger.dart';
import 'package:dio/dio.dart';


class ApiInterceptor extends Interceptor {
  final Function()? onTokenExpired;
  final Function()? onUnauthorized;
  final int maxRetries;
  final Duration retryDelay;

  ApiInterceptor({
    this.onTokenExpired,
    this.onUnauthorized,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ApiLogger.logRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ApiLogger.logResponse(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    ApiLogger.logError(err);
    
    if (err.response?.statusCode == 401) {
      if (onTokenExpired != null) {
        await onTokenExpired!();
        // إعادة المحاولة مع التوكن الجديد
        try {
          final response = await _retry(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else if (onUnauthorized != null) {
        onUnauthorized!();
      }
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      try {
        final response = await _retry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      retryCount++;
      ApiLogger.logRetry(retryCount, requestOptions);
      
      try {
        final dio = Dio();
        final response = await dio.fetch(requestOptions);
        return response;
      } catch (e) {
        if (retryCount == maxRetries) {
          rethrow;
        }
        await Future.delayed(retryDelay);
      }
    }
    throw ApiException(message: 'Failed after $maxRetries retries');
  }
} 