class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> headers;
  final bool enableLogging;
  final bool useCache;
  final bool handleErrors;
  final bool returnErrorResponse;
  final bool validateResponse;

  const ApiConfig({
    required this.baseUrl,
    required this.timeout,
    required this.headers,
    this.enableLogging = false,
    this.useCache = false,
    this.handleErrors = true,
    this.returnErrorResponse = false,
    this.validateResponse = true,
  });
} 