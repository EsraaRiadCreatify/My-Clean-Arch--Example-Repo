import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/api_interceptor.dart';
import '../base/api_response.dart';

class ApiClient {
  final Dio _dio;
  final ApiConfig _config;

  ApiClient({
    required ApiConfig config,
    ApiInterceptor? interceptor,
  })  : _config = config,
        _dio = Dio(BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: config.timeout,
          headers: config.headers,
        )) {
    _dio.interceptors.add(interceptor ?? ApiInterceptor());

    if (config.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>(
        data: response.data,
        statusCode: response.statusCode,
        success: true,
      );
    } catch (e) {
      if (_config.handleErrors) {
        if (_config.returnErrorResponse) {
          return ApiResponse<T>(
            message: e.toString(),
            statusCode: (e as DioException).response?.statusCode,
            success: false,
          );
        }
        throw e;
      }
      rethrow;
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>(
        data: response.data,
        statusCode: response.statusCode,
        success: true,
      );
    } catch (e) {
      if (_config.handleErrors) {
        if (_config.returnErrorResponse) {
          return ApiResponse<T>(
            message: e.toString(),
            statusCode: (e as DioException).response?.statusCode,
            success: false,
          );
        }
        throw e;
      }
      rethrow;
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>(
        data: response.data,
        statusCode: response.statusCode,
        success: true,
      );
    } catch (e) {
      if (_config.handleErrors) {
        if (_config.returnErrorResponse) {
          return ApiResponse<T>(
            message: e.toString(),
            statusCode: (e as DioException).response?.statusCode,
            success: false,
          );
        }
        throw e;
      }
      rethrow;
    }
  }

  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>(
        data: response.data,
        statusCode: response.statusCode,
        success: true,
      );
    } catch (e) {
      if (_config.handleErrors) {
        if (_config.returnErrorResponse) {
          return ApiResponse<T>(
            message: e.toString(),
            statusCode: (e as DioException).response?.statusCode,
            success: false,
          );
        }
        throw e;
      }
      rethrow;
    }
  }
}
