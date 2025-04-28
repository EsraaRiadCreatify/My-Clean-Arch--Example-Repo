# API Utilities Documentation
# (توثيق أدوات API)

## Overview
## (نظرة عامة)

The utils folder contains various utility classes and functions that support the API layer functionality. These utilities help with caching, response validation, and other common API operations.

(يحتوي مجلد utils على فئات ووظائف مساعدة مختلفة تدعم وظائف طبقة API. تساعد هذه الأدوات في التخزين المؤقت، والتحقق من صحة الاستجابة، وعمليات API الشائعة الأخرى.)

## Files Structure
## (هيكل الملفات)

### 1. api_cache.dart
Handles response caching functionality.

(يتعامل مع وظيفة تخزين الاستجابة مؤقتاً.)

#### Methods
#### (الطرق)

- `getCachedResponse<T>`: Retrieve cached response for a given key
  (استرجاع الاستجابة المخزنة مؤقتاً لمفتاح معين)
  ```dart
  Future<T?> getCachedResponse<T>({
    required String key,
    Duration? cacheDuration,
  })
  ```

- `cacheResponse`: Cache a response with optional duration
  (تخزين استجابة مؤقتاً مع مدة اختيارية)
  ```dart
  Future<void> cacheResponse<T>({
    required String key,
    required T data,
    Duration? cacheDuration,
  })
  ```

- `clearCache`: Clear all cached responses
  (مسح جميع الاستجابات المخزنة مؤقتاً)
  ```dart
  Future<void> clearCache()
  ```

- `removeCachedResponse`: Remove a specific cached response
  (إزالة استجابة مخزنة مؤقتاً محددة)
  ```dart
  Future<void> removeCachedResponse(String key)
  ```

### 2. api_validator.dart
Provides response validation functionality.

(يوفر وظيفة التحقق من صحة الاستجابة.)

#### Methods
#### (الطرق)

- `validateResponse`: Validate API response structure and data
  (التحقق من هيكل استجابة API والبيانات)
  ```dart
  static void validateResponse<T>(ApiResponse<T> response)
  ```

- `validateStatusCode`: Validate HTTP status code
  (التحقق من رمز حالة HTTP)
  ```dart
  static void validateStatusCode(int statusCode)
  ```

- `validateData`: Validate response data
  (التحقق من بيانات الاستجابة)
  ```dart
  static void validateData<T>(T? data)
  ```

### 3. api_formatter.dart
Handles data formatting for API requests and responses.

(يتعامل مع تنسيق البيانات لطلبات واستجابات API.)

#### Methods
#### (الطرق)

- `formatRequestData`: Format data before sending to API
  (تنسيق البيانات قبل إرسالها إلى API)
  ```dart
  static Map<String, dynamic> formatRequestData(dynamic data)
  ```

- `formatResponseData`: Format data received from API
  (تنسيق البيانات المستلمة من API)
  ```dart
  static T formatResponseData<T>(dynamic data)
  ```

- `formatQueryParameters`: Format query parameters
  (تنسيق معاملات الاستعلام)
  ```dart
  static Map<String, dynamic> formatQueryParameters(Map<String, dynamic>? parameters)
  ```

### 4. api_logger.dart
Provides logging functionality for API operations.

(يوفر وظيفة التسجيل لعمليات API.)

#### Methods
#### (الطرق)

- `logRequest`: Log API request details
  (تسجيل تفاصيل طلب API)
  ```dart
  static void logRequest(RequestOptions options)
  ```

- `logResponse`: Log API response details
  (تسجيل تفاصيل استجابة API)
  ```dart
  static void logResponse(Response response)
  ```

- `logError`: Log API error details
  (تسجيل تفاصيل خطأ API)
  ```dart
  static void logError(DioException error)
  ```

## Common Parameters
## (المعاملات المشتركة)

### Cache Parameters
### (معاملات التخزين المؤقت)

- `key` (String): Unique identifier for cached data
  (معرف فريد للبيانات المخزنة مؤقتاً)
- `cacheDuration` (Duration?): How long to keep data in cache
  (المدة التي سيتم فيها الاحتفاظ بالبيانات في التخزين المؤقت)
- `data` (T): Data to be cached
  (البيانات المراد تخزينها مؤقتاً)

### Validation Parameters
### (معاملات التحقق)

- `response` (ApiResponse<T>): API response to validate
  (استجابة API للتحقق منها)
- `statusCode` (int): HTTP status code to validate
  (رمز حالة HTTP للتحقق منه)
- `data` (T?): Data to validate
  (البيانات للتحقق منها)

## Best Practices
## (أفضل الممارسات)

1. Use appropriate cache duration based on data type
   (استخدام مدة التخزين المؤقت المناسبة بناءً على نوع البيانات)
2. Always validate API responses before processing
   (التحقق دائماً من استجابات API قبل المعالجة)
3. Implement proper error logging
   (تنفيذ تسجيل الأخطاء المناسب)
4. Format data consistently across the application
   (تنسيق البيانات بشكل متناسق عبر التطبيق)
5. Use descriptive cache keys
   (استخدام مفاتيح تخزين مؤقت وصفية)

## Example Usage
## (مثال على الاستخدام)

```dart
// Caching example
// (مثال على التخزين المؤقت)
final cache = ApiCache();
await cache.cacheResponse(
  key: 'users_list',
  data: users,
  cacheDuration: Duration(hours: 1),
);

// Validation example
// (مثال على التحقق)
ApiValidator.validateResponse(apiResponse);
ApiValidator.validateStatusCode(response.statusCode);
ApiValidator.validateData(response.data);

// Formatting example
// (مثال على التنسيق)
final formattedData = ApiFormatter.formatRequestData({
  'name': 'John',
  'age': 30,
});

// Logging example
// (مثال على التسجيل)
ApiLogger.logRequest(requestOptions);
ApiLogger.logResponse(response);
ApiLogger.logError(error);
```

## Error Handling
## (معالجة الأخطاء)

The utilities handle various types of errors:

(تتعامل الأدوات مع أنواع مختلفة من الأخطاء:)

1. Cache Errors (أخطاء التخزين المؤقت)
   - Cache write failures (فشل كتابة التخزين المؤقت)
   - Cache read failures (فشل قراءة التخزين المؤقت)
   - Invalid cache duration (مدة التخزين المؤقت غير صالحة)

2. Validation Errors (أخطاء التحقق)
   - Invalid response structure (هيكل استجابة غير صالح)
   - Invalid status code (رمز حالة غير صالح)
   - Invalid data format (تنسيق بيانات غير صالح)

3. Formatting Errors (أخطاء التنسيق)
   - Invalid data type (نوع بيانات غير صالح)
   - Missing required fields (الحقول المطلوبة مفقودة)
   - Data conversion failures (فشل تحويل البيانات) 