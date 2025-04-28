# Network Layer Documentation
# (توثيق طبقة الشبكة)

## Overview
## (نظرة عامة)

The network layer is responsible for handling all API communications in the application. It's built on top of the Dio package and provides a clean, organized way to make HTTP requests with features like caching, error handling, and loading management.

(طبقة الشبكة مسؤولة عن معالجة جميع اتصالات API في التطبيق. تم بناؤها على أساس حزمة Dio وتوفر طريقة منظمة ونظيفة لإجراء طلبات HTTP مع ميزات مثل التخزين المؤقت، ومعالجة الأخطاء، وإدارة التحميل.)

## Files Structure
## (هيكل الملفات)

### 1. api_client.dart
The main client class that provides a simple interface for making HTTP requests.

(الفئة الرئيسية التي توفر واجهة بسيطة لإجراء طلبات HTTP.)

#### Constructor Parameters
#### (معاملات المُنشئ)

- `config` (ApiConfig): Configuration for the API client including base URL, timeout, and headers
  (إعدادات عميل API بما في ذلك عنوان URL الأساسي، المهلة، والرؤوس)
- `cache` (ApiCache?): Optional cache implementation for storing responses
  (تنفيذ اختياري للتخزين المؤقت لتخزين الاستجابات)
- `interceptor` (ApiInterceptor?): Optional interceptor for request/response modification
  (معترض اختياري لتعديل الطلب/الاستجابة)
- `onUnauthorized` (Function?): Callback function for unauthorized access handling
  (دالة رد اتصال لمعالجة الوصول غير المصرح به)

#### Methods
#### (الطرق)

- `get<T>`: Make a GET request
  (إجراء طلب GET)
  ```dart
  Future<T> get<T>(
    String endpoint,
    {
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      bool handleError = true,
      bool showLoading = true,
      bool isGlobalLoader = true,
      bool returnFullResponse = false,
    }
  )
  ```

- `post<T>`: Make a POST request
  (إجراء طلب POST)
  ```dart
  Future<T> post<T>(
    String endpoint,
    {
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool handleError = true,
      bool showLoading = true,
      bool isGlobalLoader = true,
      bool returnFullResponse = false,
    }
  )
  ```

- `put<T>`: Make a PUT request
  (إجراء طلب PUT)
- `delete<T>`: Make a DELETE request
  (إجراء طلب DELETE)
- `patch<T>`: Make a PATCH request
  (إجراء طلب PATCH)
- `cancelRequests()`: Cancel all ongoing requests
  (إلغاء جميع الطلبات الجارية)

### 2. api_request_handler.dart
Handles the actual HTTP request execution, caching, and response validation.

(يتعامل مع تنفيذ طلب HTTP الفعلي، والتخزين المؤقت، والتحقق من صحة الاستجابة.)

#### Methods
#### (الطرق)

- `request<T>`: Execute the HTTP request
  (تنفيذ طلب HTTP)
  ```dart
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
  })
  ```

### 3. api_error_handler.dart
Manages error handling and user data clearing on unauthorized access.

(يدير معالجة الأخطاء ومسح بيانات المستخدم عند الوصول غير المصرح به.)

#### Methods
#### (الطرق)

- `handleError`: Handle different types of errors
  (معالجة أنواع مختلفة من الأخطاء)
- `_handleResponseError`: Handle HTTP response errors
  (معالجة أخطاء استجابة HTTP)
- `_handleUnauthorized`: Handle unauthorized access
  (معالجة الوصول غير المصرح به)
- `_clearUserData`: Clear user data from all storage types
  (مسح بيانات المستخدم من جميع أنواع التخزين)
- `_parseError`: Parse error messages from responses
  (تحليل رسائل الخطأ من الاستجابات)

### 4. api_headers_handler.dart
Manages default headers and query parameters for all requests.

(يدير الرؤوس الافتراضية ومعاملات الاستعلام لجميع الطلبات.)

#### Methods
#### (الطرق)

- `getDefaultHeaders`: Get default HTTP headers
  (الحصول على رؤوس HTTP الافتراضية)
- `getDefaultQueryParameters`: Get default query parameters
  (الحصول على معاملات الاستعلام الافتراضية)

## Common Parameters
## (المعاملات المشتركة)

### Request Parameters
### (معاملات الطلب)

- `endpoint` (String): The API endpoint to call
  (نقطة نهاية API للاتصال)
- `data` (dynamic): Request body data
  (بيانات نص الطلب)
- `queryParameters` (Map<String, dynamic>?): URL query parameters
  (معاملات استعلام URL)
- `options` (Options?): Additional request options
  (خيارات طلب إضافية)
- `cancelToken` (CancelToken?): Token for request cancellation
  (رمز لإلغاء الطلب)

### Loading Parameters
### (معاملات التحميل)

- `showLoading` (bool): Whether to show loading indicator
  (ما إذا كان سيتم عرض مؤشر التحميل)
- `isGlobalLoader` (bool): Whether to show global or local loading indicator
  (ما إذا كان سيتم عرض مؤشر التحميل العام أو المحلي)

### Response Parameters
### (معاملات الاستجابة)

- `returnFullResponse` (bool): Whether to return full response or just data
  (ما إذا كان سيتم إرجاع الاستجابة الكاملة أو البيانات فقط)
- `handleError` (bool): Whether to handle errors automatically
  (ما إذا كان سيتم معالجة الأخطاء تلقائياً)

### Cache Parameters
### (معاملات التخزين المؤقت)

- `useCache` (bool?): Whether to use caching
  (ما إذا كان سيتم استخدام التخزين المؤقت)
- `cacheDuration` (Duration?): How long to cache the response
  (المدة التي سيتم فيها تخزين الاستجابة مؤقتاً)

## Error Handling
## (معالجة الأخطاء)

The network layer handles various types of errors:

(تتعامل طبقة الشبكة مع أنواع مختلفة من الأخطاء:)

1. Network Errors (أخطاء الشبكة)
   - Connection timeout (انتهاء مهلة الاتصال)
   - No internet connection (لا يوجد اتصال بالإنترنت)
   - Server unreachable (لا يمكن الوصول إلى الخادم)

2. HTTP Errors (أخطاء HTTP)
   - 400: Bad Request (طلب غير صالح)
   - 401: Unauthorized (غير مصرح به)
   - 403: Forbidden (ممنوع)
   - 404: Not Found (غير موجود)
   - 500: Server Error (خطأ في الخادم)

3. Application Errors (أخطاء التطبيق)
   - Response validation errors (أخطاء التحقق من صحة الاستجابة)
   - Data parsing errors (أخطاء تحليل البيانات)

## Best Practices
## (أفضل الممارسات)

1. Always handle errors appropriately
   (معالجة الأخطاء بشكل مناسب دائماً)
2. Use caching for frequently accessed data
   (استخدام التخزين المؤقت للبيانات التي يتم الوصول إليها بشكل متكرر)
3. Show appropriate loading indicators
   (عرض مؤشرات التحميل المناسبة)
4. Cancel requests when they're no longer needed
   (إلغاء الطلبات عندما لم تعد هناك حاجة إليها)
5. Use proper error messages for better user experience
   (استخدام رسائل خطأ مناسبة لتحسين تجربة المستخدم)

## Example Usage
## (مثال على الاستخدام)

```dart
// Simple GET request
// (طلب GET بسيط)
final users = await apiClient.get<List<User>>('/users');

// POST request with data and loading
// (طلب POST مع البيانات والتحميل)
final result = await apiClient.post<Map<String, dynamic>>(
  '/users',
  data: {'name': 'John'},
  showLoading: true,
  isGlobalLoader: false,
);

// PUT request with error handling
// (طلب PUT مع معالجة الأخطاء)
try {
  await apiClient.put('/users/1', data: {'name': 'Updated'});
} catch (e) {
  // Handle error
  // (معالجة الخطأ)
}

// DELETE request with cache
// (طلب DELETE مع التخزين المؤقت)
await apiClient.delete(
  '/users/1',
  useCache: true,
  cacheDuration: Duration(hours: 1),
);
``` 