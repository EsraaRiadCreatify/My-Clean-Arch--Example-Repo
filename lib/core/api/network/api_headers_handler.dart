import 'dart:io';

class ApiHeadersHandler {
  static Map<String, String> getDefaultHeaders() {
    return {
      'Accept': 'image/webp,image/*,*/*;q=0.8',
      'device': 'myApp',
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'lang': 'ar',
    };
  }

  static Map<String, dynamic> getDefaultQueryParameters() {
    return {
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'lang': 'ar',
    };
  }
} 