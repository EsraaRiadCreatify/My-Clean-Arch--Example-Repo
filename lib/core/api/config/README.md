# API Configuration Documentation
# (توثيق إعدادات API)

## Overview
## (نظرة عامة)

The config folder contains all configuration-related classes and files that define how the API layer operates. These configurations include API endpoints, timeouts, headers, and other settings that control the behavior of API requests and responses.

(يحتوي مجلد config على جميع الفئات والملفات المتعلقة بالإعدادات التي تحدد كيفية عمل طبقة API. تتضمن هذه الإعدادات نقاط نهاية API، المهلات، الرؤوس، والإعدادات الأخرى التي تتحكم في سلوك طلبات واستجابات API.)

## Files Structure
## (هيكل الملفات)

### 1. api_config.dart
Defines the main API configuration class.

(يحدد فئة إعدادات API الرئيسية.)

#### Class: ApiConfig
#### (الفئة: ApiConfig)

```dart
class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> headers;
  final bool enableLogging;
  final bool enableCache;
  final Duration defaultCacheDuration;
  final bool validateResponse;
  final bool retryOnFailure;
  final int maxRetries;
  final List<Interceptor> interceptors;
  final bool enableCompression;
  final bool followRedirects;
  final int maxRedirects;
  final bool persistentConnection;
  final bool receiveDataWhenStatusError;
  final bool sendTimeout;
  final bool receiveTimeout;
  final bool validateStatus;
  final bool enableProxy;
  final String? proxy;
  final bool enableBadCertificateCallback;
  final bool enableCertificatePinning;
  final List<String>? pinnedCertificates;
}
```

#### Parameters
#### (المعاملات)

1. `baseUrl` (String)
   - The base URL for all API requests
   - (عنوان URL الأساسي لجميع طلبات API)
   - Example: "https://api.example.com/v1"
   - Required: Yes

2. `timeout` (Duration)
   - The timeout duration for API requests
   - (مدة المهلة لطلبات API)
   - Default: Duration(seconds: 30)
   - Required: No

3. `headers` (Map<String, String>)
   - Default headers to be sent with every request
   - (الرؤوس الافتراضية التي سيتم إرسالها مع كل طلب)
   - Example: {"Content-Type": "application/json"}
   - Required: No

4. `enableLogging` (bool)
   - Whether to enable request/response logging
   - (ما إذا كان سيتم تمكين تسجيل الطلب/الاستجابة)
   - Default: true
   - Required: No

5. `enableCache` (bool)
   - Whether to enable response caching
   - (ما إذا كان سيتم تمكين تخزين الاستجابة مؤقتاً)
   - Default: true
   - Required: No

6. `defaultCacheDuration` (Duration)
   - Default duration for cached responses
   - (المدة الافتراضية للاستجابات المخزنة مؤقتاً)
   - Default: Duration(hours: 1)
   - Required: No

7. `validateResponse` (bool)
   - Whether to validate API responses
   - (ما إذا كان سيتم التحقق من صحة استجابات API)
   - Default: true
   - Required: No

8. `retryOnFailure` (bool)
   - Whether to retry failed requests
   - (ما إذا كان سيتم إعادة محاولة الطلبات الفاشلة)
   - Default: true
   - Required: No

9. `maxRetries` (int)
   - Maximum number of retry attempts
   - (الحد الأقصى لعدد محاولات إعادة المحاولة)
   - Default: 3
   - Required: No

10. `interceptors` (List<Interceptor>)
    - List of interceptors to be applied to requests
    - (قائمة المعترضات التي سيتم تطبيقها على الطلبات)
    - Default: []
    - Required: No

11. `enableCompression` (bool)
    - Whether to enable request compression
    - (ما إذا كان سيتم تمكين ضغط الطلب)
    - Default: true
    - Required: No

12. `followRedirects` (bool)
    - Whether to follow HTTP redirects
    - (ما إذا كان سيتم متابعة إعادة التوجيه HTTP)
    - Default: true
    - Required: No

13. `maxRedirects` (int)
    - Maximum number of redirects to follow
    - (الحد الأقصى لعدد عمليات إعادة التوجيه للمتابعة)
    - Default: 5
    - Required: No

14. `persistentConnection` (bool)
    - Whether to maintain persistent connections
    - (ما إذا كان سيتم الحفاظ على الاتصالات المستمرة)
    - Default: true
    - Required: No

15. `receiveDataWhenStatusError` (bool)
    - Whether to receive data when status code indicates error
    - (ما إذا كان سيتم استلام البيانات عندما يشير رمز الحالة إلى خطأ)
    - Default: true
    - Required: No

16. `sendTimeout` (bool)
    - Whether to enable send timeout
    - (ما إذا كان سيتم تمكين مهلة الإرسال)
    - Default: true
    - Required: No

17. `receiveTimeout` (bool)
    - Whether to enable receive timeout
    - (ما إذا كان سيتم تمكين مهلة الاستلام)
    - Default: true
    - Required: No

18. `validateStatus` (bool)
    - Whether to validate HTTP status codes
    - (ما إذا كان سيتم التحقق من صحة رموز حالة HTTP)
    - Default: true
    - Required: No

19. `enableProxy` (bool)
    - Whether to enable proxy support
    - (ما إذا كان سيتم تمكين دعم الوكيل)
    - Default: false
    - Required: No

20. `proxy` (String?)
    - Proxy server address
    - (عنوان خادم الوكيل)
    - Example: "http://proxy.example.com:8080"
    - Required: No

21. `enableBadCertificateCallback` (bool)
    - Whether to enable bad certificate callback
    - (ما إذا كان سيتم تمكين رد الاتصال بشهادة غير صالحة)
    - Default: false
    - Required: No

22. `enableCertificatePinning` (bool)
    - Whether to enable certificate pinning
    - (ما إذا كان سيتم تمكين تثبيت الشهادة)
    - Default: false
    - Required: No

23. `pinnedCertificates` (List<String>?)
    - List of pinned certificate hashes
    - (قائمة تجزئات الشهادات المثبتة)
    - Example: ["sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="]
    - Required: No

### 2. api_endpoints.dart
Defines API endpoint constants and helper methods.

(يحدد ثوابت نقاط نهاية API وطرق المساعدة.)

#### Constants
#### (الثوابت)

1. Base URLs
   ```dart
   static const String baseUrl = 'https://api.example.com';
   static const String stagingUrl = 'https://staging-api.example.com';
   static const String developmentUrl = 'https://dev-api.example.com';
   ```

2. API Versions
   ```dart
   static const String v1 = '/v1';
   static const String v2 = '/v2';
   ```

3. Endpoint Paths
   ```dart
   static const String users = '/users';
   static const String products = '/products';
   static const String orders = '/orders';
   ```

#### Methods
#### (الطرق)

1. `buildUrl`
   ```dart
   static String buildUrl(String endpoint, {String? version})
   ```
   - Builds a complete URL from base URL, version, and endpoint
   - (يبني عنوان URL كاملاً من عنوان URL الأساسي والإصدار ونقطة النهاية)
   - Parameters:
     - `endpoint` (String): The endpoint path
     - `version` (String?): Optional API version
   - Returns: Complete URL string

2. `buildQueryString`
   ```dart
   static String buildQueryString(Map<String, dynamic> parameters)
   ```
   - Builds a query string from parameters
   - (يبني سلسلة استعلام من المعاملات)
   - Parameters:
     - `parameters` (Map<String, dynamic>): Query parameters
   - Returns: Formatted query string

### 3. api_constants.dart
Defines API-related constants.

(يحدد الثوابت المتعلقة بـ API.)

#### Constants
#### (الثوابت)

1. Headers
   ```dart
   static const Map<String, String> defaultHeaders = {
     'Content-Type': 'application/json',
     'Accept': 'application/json',
   };
   ```

2. Timeouts
   ```dart
   static const Duration defaultTimeout = Duration(seconds: 30);
   static const Duration longTimeout = Duration(seconds: 60);
   static const Duration shortTimeout = Duration(seconds: 10);
   ```

3. Cache
   ```dart
   static const Duration defaultCacheDuration = Duration(hours: 1);
   static const Duration longCacheDuration = Duration(days: 1);
   static const Duration shortCacheDuration = Duration(minutes: 30);
   ```

4. Status Codes
   ```dart
   static const int success = 200;
   static const int created = 201;
   static const int badRequest = 400;
   static const int unauthorized = 401;
   static const int forbidden = 403;
   static const int notFound = 404;
   static const int serverError = 500;
   ```

## Best Practices
## (أفضل الممارسات)

1. Configuration Management
   - Use environment-specific configurations
   - (استخدام إعدادات خاصة بالبيئة)
   - Keep sensitive data in secure storage
   - (الاحتفاظ بالبيانات الحساسة في تخزين آمن)
   - Use constants for frequently used values
   - (استخدام الثوابت للقيم المستخدمة بشكل متكرر)

2. Error Handling
   - Define clear error messages
   - (تحديد رسائل خطأ واضحة)
   - Implement proper error logging
   - (تنفيذ تسجيل الأخطاء المناسب)
   - Handle network errors gracefully
   - (معالجة أخطاء الشبكة بشكل أنيق)

3. Performance
   - Set appropriate timeouts
   - (تعيين المهلات المناسبة)
   - Enable compression for large payloads
   - (تمكين الضغط للحزم الكبيرة)
   - Use caching strategically
   - (استخدام التخزين المؤقت بشكل استراتيجي)

## Example Usage
## (مثال على الاستخدام)

```dart
// Basic configuration
// (الإعداد الأساسي)
final config = ApiConfig(
  baseUrl: ApiEndpoints.baseUrl,
  timeout: ApiConstants.defaultTimeout,
  headers: ApiConstants.defaultHeaders,
  enableLogging: true,
  enableCache: true,
);

// Environment-specific configuration
// (إعداد خاص بالبيئة)
final config = ApiConfig(
  baseUrl: kDebugMode 
    ? ApiEndpoints.developmentUrl 
    : ApiEndpoints.baseUrl,
  timeout: ApiConstants.defaultTimeout,
  headers: {
    ...ApiConstants.defaultHeaders,
    'Authorization': 'Bearer $token',
  },
  enableLogging: kDebugMode,
  enableCache: true,
  validateResponse: true,
  retryOnFailure: true,
  maxRetries: 3,
);

// Building URLs
// (بناء عناوين URL)
final userUrl = ApiEndpoints.buildUrl(
  ApiEndpoints.users,
  version: ApiEndpoints.v1,
);

final productUrl = ApiEndpoints.buildUrl(
  ApiEndpoints.products,
  version: ApiEndpoints.v2,
);

// Building query strings
// (بناء سلاسل الاستعلام)
final queryString = ApiEndpoints.buildQueryString({
  'page': 1,
  'limit': 10,
  'sort': 'name',
});
``` 