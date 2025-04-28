import 'dart:convert';

import 'package:dio/dio.dart';
import '../base/api_exception.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class ApiErrorHandler {
  final void Function()? onUnauthorized;

  ApiErrorHandler({this.onUnauthorized});

  void handleError(dynamic error) {
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
} 