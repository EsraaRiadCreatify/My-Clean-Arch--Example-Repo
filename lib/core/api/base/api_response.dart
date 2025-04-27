class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool success;

  ApiResponse({
    this.data,
    this.message,
    this.statusCode,
    this.success = false,
  });
} 