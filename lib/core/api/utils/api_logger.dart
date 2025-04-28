import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLogger {
  static void logRequest(RequestOptions options) {
    debugPrint('🌐 API Request:');
    debugPrint('Method: ${options.method}');
    debugPrint('URL: ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Data: ${options.data}');
    debugPrint('Query Parameters: ${options.queryParameters}');
  }

  static void logResponse(Response response) {
    debugPrint('✅ API Response:');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Headers: ${response.headers}');
    debugPrint('Data: ${response.data}');
  }

  static void logError(DioException error) {
    debugPrint('❌ API Error:');
    debugPrint('Type: ${error.type}');
    debugPrint('Message: ${error.message}');
    debugPrint('Response: ${error.response?.data}');
    debugPrint('Status Code: ${error.response?.statusCode}');
  }

  static void logRetry(int retryCount, RequestOptions options) {
    debugPrint('🔄 Retry Attempt: $retryCount');
    debugPrint('URL: ${options.uri}');
  }
}
