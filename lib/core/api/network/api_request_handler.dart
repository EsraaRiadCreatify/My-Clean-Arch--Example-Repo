import 'dart:io';
import 'package:dio/dio.dart';
import '../base/api_response.dart';
import '../utils/api_validator.dart';
import '../utils/api_cache.dart';
import '../../shared_widgets/loading/loading_controller.dart';

class ApiRequestHandler {
  final Dio _dio;
  final ApiCache? _cache;
  final LoadingController _loadingController = LoadingController();

  ApiRequestHandler(this._dio, this._cache);

  Future<Response<T>> request<T>({
    required String endpoint,
    required String method,
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
      final shouldUseCache = useCache ?? false;
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
          method: method,
          headers: options?.headers,
          contentType: options?.contentType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Validate response if enabled
      final shouldValidate = validateResponse ?? false;
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
    } finally {
      if (showLoading) {
        _loadingController.stopLoading(isGlobal: isGlobalLoader);
      }
    }
  }

  String _getLoadingMessage(String method) {
    switch (method.toLowerCase()) {
      case 'get':
        return "جاري جلب البيانات...";
      case 'post':
        return "جاري إرسال البيانات...";
      case 'put':
      case 'patch':
        return "جاري تحديث البيانات...";
      case 'delete':
        return "جاري حذف البيانات...";
      default:
        return "جاري معالجة الطلب...";
    }
  }

  String _getCacheKey(String endpoint, Map<String, dynamic>? queryParameters) {
    final queryString = queryParameters?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return queryString != null ? '$endpoint?$queryString' : endpoint;
  }
} 