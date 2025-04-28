# Base API Documentation
# (توثيق قاعدة API)

## Overview
## (نظرة عامة)

The `base` folder contains core classes that define the fundamental structure for handling API responses and exceptions. These classes are used throughout the API layer to ensure consistent handling of data and errors.

(يحتوي مجلد `base` على الفئات الأساسية التي تحدد الهيكل الأساسي للتعامل مع استجابات API والاستثناءات. تُستخدم هذه الفئات في جميع أنحاء طبقة API لضمان التعامل المتسق مع البيانات والأخطاء.)

## Files Structure
## (هيكل الملفات)

### 1. api_response.dart
Defines the structure for API responses.

(يحدد هيكل استجابات API.)

#### Class: ApiResponse<T>
#### (الفئة: ApiResponse<T>)

```dart
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
```

#### Parameters
#### (المعاملات)

1. `data` (T?)
   - The response data
   - (بيانات الاستجابة)
   - Example: `User` object, `List<Post>`, etc.
   - Required: No

2. `message` (String?)
   - A message describing the response
   - (رسالة تصف الاستجابة)
   - Example: "Successfully retrieved data"
   - Required: No

3. `statusCode` (int?)
   - The HTTP status code of the response
   - (رمز حالة HTTP للاستجابة)
   - Example: 200, 404, 500
   - Required: No

4. `success` (bool)
   - Indicates whether the request was successful
   - (يشير إلى ما إذا كان الطلب ناجحاً)
   - Default: false
   - Required: No

#### Methods
#### (الطرق)

1. `fromJson`
   ```dart
   factory ApiResponse.fromJson(Map<String, dynamic> json)
   ```
   - Creates an `ApiResponse` instance from a JSON map
   - (ينشئ مثيل `ApiResponse` من خريطة JSON)
   - Parameters:
     - `json` (Map<String, dynamic>): The JSON data
   - Returns: `ApiResponse<T>`

2. `toJson`
   ```dart
   Map<String, dynamic> toJson()
   ```
   - Converts the `ApiResponse` instance to a JSON map
   - (يحول مثيل `ApiResponse` إلى خريطة JSON)
   - Returns: `Map<String, dynamic>`

### 2. api_exception.dart
Defines custom exceptions for API error handling.

(يحدد استثناءات مخصصة للتعامل مع أخطاء API.)

#### Class: ApiException
#### (الفئة: ApiException)

```dart
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
```

#### Parameters
#### (المعاملات)

1. `message` (String)
   - A message describing the error
   - (رسالة تصف الخطأ)
   - Example: "Network error occurred"
   - Required: Yes

2. `statusCode` (int?)
   - The HTTP status code associated with the error
   - (رمز حالة HTTP المرتبط بالخطأ)
   - Example: 404, 500
   - Required: No

3. `error` (dynamic)
   - The original error object
   - (كائن الخطأ الأصلي)
   - Example: `DioException`, `SocketException`
   - Required: No

#### Methods
#### (الطرق)

1. `fromError`
   ```dart
   factory ApiException.fromError(dynamic error)
   ```
   - Creates an `ApiException` instance from an error object
   - (ينشئ مثيل `ApiException` من كائن خطأ)
   - Parameters:
     - `error` (dynamic): The error object
   - Returns: `ApiException`

2. `toString`
   ```dart
   @override
   String toString() => 'ApiException: $message';
   ```
   - Returns a string representation of the exception
   - (يعيد تمثيلاً نصياً للاستثناء)
   - Returns: `String`

#### Derived Classes
#### (الفئات المشتقة)

1. `NetworkException`
   ```dart
   class NetworkException extends ApiException {
     NetworkException() : super(message: 'لا يوجد اتصال بالإنترنت');
   }
   ```
   - Represents network connectivity errors
   - (يمثل أخطاء اتصال الشبكة)

2. `TimeoutException`
   ```dart
   class TimeoutException extends ApiException {
     TimeoutException() : super(message: 'انتهت مهلة الاتصال');
   }
   ```
   - Represents request timeout errors
   - (يمثل أخطاء انتهاء مهلة الطلب)

3. `ServerException`
   ```dart
   class ServerException extends ApiException {
     ServerException() : super(message: 'حدث خطأ في الخادم');
   }
   ```
   - Represents server-side errors
   - (يمثل أخطاء جانب الخادم)

4. `UnauthorizedException`
   ```dart
   class UnauthorizedException extends ApiException {
     UnauthorizedException() : super(message: 'غير مصرح لك بالوصول');
   }
   ```
   - Represents unauthorized access errors
   - (يمثل أخطاء الوصول غير المصرح به)

5. `NotFoundException`
   ```dart
   class NotFoundException extends ApiException {
     NotFoundException() : super(message: 'لم يتم العثور على المورد المطلوب');
   }
   ```
   - Represents resource not found errors
   - (يمثل أخطاء عدم العثور على المورد)

## Best Practices
## (أفضل الممارسات)

1. Response Handling
   - Always check the `success` field before processing data
   - (التحقق دائماً من حقل `success` قبل معالجة البيانات)
   - Use appropriate error messages for better user experience
   - (استخدام رسائل خطأ مناسبة لتحسين تجربة المستخدم)

2. Exception Handling
   - Catch specific exceptions for better error handling
   - (التقاط استثناءات محددة لمعالجة أفضل للأخطاء)
   - Log exceptions for debugging purposes
   - (تسجيل الاستثناءات لأغراض التصحيح)

## Example Usage
## (مثال على الاستخدام)

```dart
// Handling API Response
// (معالجة استجابة API)
final response = ApiResponse<User>.fromJson(jsonData);
if (response.success) {
  final user = response.data;
  // Process user data
  // (معالجة بيانات المستخدم)
} else {
  // Handle error
  // (معالجة الخطأ)
}

// Handling API Exception
// (معالجة استثناء API)
try {
  // API call
  // (استدعاء API)
} catch (e) {
  final exception = ApiException.fromError(e);
  if (exception is NetworkException) {
    // Handle network error
    // (معالجة خطأ الشبكة)
  } else if (exception is UnauthorizedException) {
    // Handle unauthorized access
    // (معالجة الوصول غير المصرح به)
  } else {
    // Handle other errors
    // (معالجة الأخطاء الأخرى)
  }
}
``` 