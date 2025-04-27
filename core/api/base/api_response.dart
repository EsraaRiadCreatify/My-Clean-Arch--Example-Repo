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

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: json['data'],
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'statusCode': statusCode,
      'success': success,
    };
  }
} 