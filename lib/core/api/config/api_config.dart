class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> headers;
  final bool enableLogging;
  final bool enableRetry;
  final int maxRetries;
  final Duration retryDelay;
  
  // خيارات التعامل مع الأخطاء
  final bool handleErrors; // هل يتم معالجة الأخطاء تلقائياً
  final bool returnErrorResponse; // هل يتم إرجاع استجابة خطأ بدلاً من رمي استثناء
  final bool validateResponse; // هل يتم التحقق من صحة الاستجابة
  final bool useCache; // هل يتم استخدام التخزين المؤقت
  
  ApiConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.headers = const {},
    this.enableLogging = true,
    this.enableRetry = true,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.handleErrors = true,
    this.returnErrorResponse = false,
    this.validateResponse = true,
    this.useCache = false,
  });

  ApiConfig copyWith({
    String? baseUrl,
    Duration? timeout,
    Map<String, String>? headers,
    bool? enableLogging,
    bool? enableRetry,
    int? maxRetries,
    Duration? retryDelay,
    bool? handleErrors,
    bool? returnErrorResponse,
    bool? validateResponse,
    bool? useCache,
  }) {
    return ApiConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      timeout: timeout ?? this.timeout,
      headers: headers ?? this.headers,
      enableLogging: enableLogging ?? this.enableLogging,
      enableRetry: enableRetry ?? this.enableRetry,
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
      handleErrors: handleErrors ?? this.handleErrors,
      returnErrorResponse: returnErrorResponse ?? this.returnErrorResponse,
      validateResponse: validateResponse ?? this.validateResponse,
      useCache: useCache ?? this.useCache,
    );
  }
} 