# Dependency Injection System (نظام حقن التبعيات)

The Dependency Injection (DI) system provides a centralized way to manage dependencies across your application. It supports multiple storage types and provides a clean way to initialize and access services throughout your app.

## Features (المميزات)

- Centralized dependency management
- Support for multiple storage types (SharedPreferences, Hive, Memory)
- Easy service registration and retrieval
- Organized initialization process
- Support for lazy loading
- Clean separation of concerns

## Installation (التثبيت)

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  get_it: ^latest_version
  shared_preferences: ^latest_version
  hive: ^latest_version
  path_provider: ^latest_version
```

## Usage Examples (أمثلة الاستخدام)

### 1. Basic Setup (الإعداد الأساسي)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependencies
  runApp(MyApp());
}
```

### 2. Accessing Dependencies (الوصول إلى التبعيات)

```dart
// Access SharedPreferences
final prefs = sl<SharedPreferences>();

// Access Hive Box
final box = sl<Box>();

// Access Memory Storage
final memoryStorage = sl<Map<String, dynamic>>();

// Access API Client
final apiClient = sl<ApiClient>();
```

### 3. Registering New Dependencies (تسجيل تبعيات جديدة)

```dart
// Register a singleton
sl.registerSingleton<MyService>(MyService());

// Register a lazy singleton
sl.registerLazySingleton<MyService>(() => MyService());

// Register a factory
sl.registerFactory<MyService>(() => MyService());
```

### 4. Using with Storage Types (الاستخدام مع أنواع التخزين)

```dart
// Using SharedPreferences
final prefs = sl<SharedPreferences>();
await prefs.setString('key', 'value');

// Using Hive
final box = sl<Box>();
await box.put('key', 'value');

// Using Memory Storage
final memoryStorage = sl<Map<String, dynamic>>();
memoryStorage['key'] = 'value';
```

## Storage Types (أنواع التخزين)

### 1. SharedPreferences (التفضيلات المشتركة)
- Best for simple key-value pairs
- Persists data between app launches
- Good for small amounts of data
- Synchronous access

### 2. Hive (هايف)
- Fast and efficient
- Supports complex data types
- Good for larger datasets
- Asynchronous access
- Type-safe

### 3. Memory Storage (التخزين في الذاكرة)
- Fastest access
- Temporary storage
- Cleared when app closes
- Good for caching

## Best Practices (أفضل الممارسات)

1. Initialize dependencies before running the app
2. Use lazy loading for heavy services
3. Register dependencies in the appropriate initialization phase
4. Use the correct storage type for your needs
5. Clean up resources when they're no longer needed

## Initialization Phases (مراحل التهيئة)

1. External Dependencies
   - SharedPreferences
   - Hive
   - Memory Storage

2. Core Dependencies
   - API Client
   - API Config
   - API Cache
   - API Validator
   - Interceptors

3. Feature Dependencies
   - Repositories
   - Services
   - Blocs/Cubits
   - Controllers

## Error Handling (معالجة الأخطاء)

```dart
try {
  final service = sl<MyService>();
} catch (e) {
  if (e is StateError) {
    // Service not registered
    print('Service not found');
  }
}
```

## Testing (الاختبار)

```dart
void setUp() {
  sl.reset(); // Reset service locator
  init(); // Initialize dependencies
}

void tearDown() {
  sl.reset(); // Clean up
}
```

## Contributing (المساهمة)

Feel free to contribute to this project by:
1. Reporting issues
2. Suggesting improvements
3. Submitting pull requests

## License (الترخيص)

This project is licensed under the MIT License. 