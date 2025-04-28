class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  
  // Authentication
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  
  // User
  static const String getUser = '$baseUrl/user';
  static const String updateUser = '$baseUrl/user';
  static const String changePassword = '$baseUrl/user/change-password';
  
  // يمكن إضافة المزيد من نقاط النهاية حسب احتياجات المشروع
  
  // Helper method to build URL with query parameters
  static String buildUrl(String endpoint, {Map<String, dynamic>? queryParameters}) {
    if (queryParameters == null || queryParameters.isEmpty) {
      return endpoint;
    }
    
    final uri = Uri.parse(endpoint);
    return uri.replace(queryParameters: queryParameters).toString();
  }
} 