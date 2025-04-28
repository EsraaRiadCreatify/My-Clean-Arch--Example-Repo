# Error Interceptor (معالج الأخطاء)

The Error Interceptor is a powerful component that handles API errors and manages authentication state across different storage types. It provides a unified way to handle various types of errors and automatically clears authentication data when needed.

## Features (المميزات)

- Handles different types of errors (401, 404, 500, network errors)
- Supports multiple storage types (SharedPreferences, Hive, Memory)
- Automatic authentication data clearing
- Customizable error messages
- Easy integration with Dio

## Installation (التثبيت)

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^latest_version
  shared_preferences: ^latest_version
  hive: ^latest_version
  get_it: ^latest_version
```

## Usage Examples (أمثلة الاستخدام)

### 1. Basic Setup with SharedPreferences (الإعداد الأساسي مع SharedPreferences)

```dart
final prefs = await SharedPreferences.getInstance();
final dio = Dio();

dio.interceptors.add(
  ErrorInterceptor(
    prefs: prefs,
  ),
);
```

### 2. Setup with Hive Storage (الإعداد مع Hive)

```dart
final prefs = await SharedPreferences.getInstance();
final box = await Hive.openBox('authBox');
final dio = Dio();

dio.interceptors.add(
  ErrorInterceptor(
    prefs: prefs,
    hiveBox: box,
  ),
);
```

### 3. Setup with Memory Storage (الإعداد مع التخزين في الذاكرة)

```dart
final prefs = await SharedPreferences.getInstance();
final memoryStorage = <String, dynamic>{};
final dio = Dio();

dio.interceptors.add(
  ErrorInterceptor(
    prefs: prefs,
    memoryStorage: memoryStorage,
  ),
);
```

### 4. Setup with All Storage Types (الإعداد مع جميع أنواع التخزين)

```dart
final prefs = await SharedPreferences.getInstance();
final box = await Hive.openBox('authBox');
final memoryStorage = <String, dynamic>{};
final dio = Dio();

dio.interceptors.add(
  ErrorInterceptor(
    prefs: prefs,
    hiveBox: box,
    memoryStorage: memoryStorage,
  ),
);
```

### 5. Using with GetIt (الاستخدام مع GetIt)

```dart
// Register dependencies
GetIt.I.registerSingleton<SharedPreferences>(prefs);
GetIt.I.registerSingleton<Box>(box);
GetIt.I.registerSingleton<Map<String, dynamic>>(memoryStorage);

// Setup Dio with GetIt
final dio = Dio();
dio.interceptors.add(
  ErrorInterceptor(
    prefs: GetIt.I<SharedPreferences>(),
    hiveBox: GetIt.I<Box>(),
    memoryStorage: GetIt.I<Map<String, dynamic>>(),
  ),
);
```

## Error Handling Examples (أمثلة معالجة الأخطاء)

### 1. Handling 401 Unauthorized (معالجة خطأ 401)

```dart
try {
  final response = await dio.get('/protected-endpoint');
} catch (e) {
  if (e is UnauthorizedException) {
    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

### 2. Handling Network Errors (معالجة أخطاء الشبكة)

```dart
try {
  final response = await dio.get('/endpoint');
} catch (e) {
  if (e is NetworkException) {
    // Show no internet connection message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No internet connection')),
    );
  }
}
```

### 3. Handling Server Errors (معالجة أخطاء الخادم)

```dart
try {
  final response = await dio.get('/endpoint');
} catch (e) {
  if (e is ServerException) {
    // Show server error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Server error occurred')),
    );
  }
}
```

## Best Practices (أفضل الممارسات)

1. Always use the error interceptor with at least SharedPreferences
2. Clear sensitive data from all storage types when handling 401 errors
3. Provide meaningful error messages to users
4. Handle errors appropriately in your UI layer
5. Use GetIt for dependency injection when possible

## Error Types (أنواع الأخطاء)

- `UnauthorizedException`: When the user is not authenticated (401)
- `NetworkException`: When there are network connectivity issues
- `ServerException`: When the server returns a 500 error
- `NotFoundException`: When the requested resource is not found (404)
- `ApiException`: For all other API-related errors

## Contributing (المساهمة)

Feel free to contribute to this project by:
1. Reporting issues
2. Suggesting improvements
3. Submitting pull requests

## License (الترخيص)

This project is licensed under the MIT License. 