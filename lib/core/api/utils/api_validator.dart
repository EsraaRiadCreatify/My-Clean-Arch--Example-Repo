import '../../../../core/api/base/api_exception.dart';
import '../../../../core/api/base/api_response.dart';

class ApiValidator {
  static void validateResponse<T>(ApiResponse<T> response) {
    if (!response.success) {
      throw ApiException(
        message: response.message ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }

    if (response.data == null) {
      throw ApiException(
        message: 'Response data is null',
        statusCode: response.statusCode,
      );
    }
  }

  static void validateStatusCode(int? statusCode) {
    if (statusCode == null) return;

    if (statusCode >= 500) {
      throw ServerException();
    }

    if (statusCode == 401) {
      throw UnauthorizedException();
    }

    if (statusCode == 404) {
      throw NotFoundException();
    }

    if (statusCode >= 400) {
      throw ApiException(
        message: 'Request failed with status code: $statusCode',
        statusCode: statusCode,
      );
    }
  }

  static void validateNetworkConnection(bool isConnected) {
    if (!isConnected) {
      throw NetworkException();
    }
  }
} 