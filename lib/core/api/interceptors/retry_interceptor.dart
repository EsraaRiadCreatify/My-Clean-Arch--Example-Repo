import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  RetryInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
      
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        
        final options = err.requestOptions;
        options.extra['retryCount'] = retryCount + 1;
        
        try {
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.connectionError;
  }
} 