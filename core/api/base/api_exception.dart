import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiException.fromError(dynamic error) {
    if (error is DioException) {
      return ApiException(
        message: error.message ?? 'حدث خطأ في الاتصال',
        statusCode: error.response?.statusCode,
        error: error,
      );
    }
    return ApiException(
      message: error.toString(),
      error: error,
    );
  }

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  NetworkException() : super(message: 'لا يوجد اتصال بالإنترنت');
}

class TimeoutException extends ApiException {
  TimeoutException() : super(message: 'انتهت مهلة الاتصال');
}

class ServerException extends ApiException {
  ServerException() : super(message: 'حدث خطأ في الخادم');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super(message: 'غير مصرح لك بالوصول');
}

class NotFoundException extends ApiException {
  NotFoundException() : super(message: 'لم يتم العثور على المورد المطلوب');
} 