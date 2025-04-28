import 'package:dio/dio.dart';
import '../base/api_exception.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorInterceptor extends Interceptor {
  final SharedPreferences _prefs;
  final Box? _hiveBox;
  final Map<String, dynamic>? _memoryStorage;

  ErrorInterceptor({
    required SharedPreferences prefs,
    Box? hiveBox,
    Map<String, dynamic>? memoryStorage,
  }) : _prefs = prefs,
       _hiveBox = hiveBox,
       _memoryStorage = memoryStorage;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      _clearAuthData();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: UnauthorizedException(),
        ),
      );
      return;
    }

    // Handle network errors
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(),
        ),
      );
      return;
    }

    // Handle server errors
    if (err.response?.statusCode == 500) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerException(),
        ),
      );
      return;
    }

    // Handle not found errors
    if (err.response?.statusCode == 404) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NotFoundException(),
        ),
      );
      return;
    }

    // Handle other errors
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ApiException(message: _parseErrorMessage(err)),
      ),
    );
  }

  void _clearAuthData() {
    // Clear auth data from SharedPreferences
    _prefs.remove('token');
    _prefs.remove('refresh_token');
    _prefs.remove('user_data');

    // Clear auth data from Hive if available
    _hiveBox?.delete('token');
    _hiveBox?.delete('refresh_token');
    _hiveBox?.delete('user_data');

    // Clear auth data from memory storage if available
    _memoryStorage?.remove('token');
    _memoryStorage?.remove('refresh_token');
    _memoryStorage?.remove('user_data');
  }

  String _parseErrorMessage(DioException err) {
    try {
      if (err.response?.data is Map) {
        final data = err.response?.data as Map;
        return data['message'] ?? data['error'] ?? 'An error occurred';
      }
      return err.message ?? 'An error occurred';
    } catch (e) {
      return 'An error occurred';
    }
  }
} 