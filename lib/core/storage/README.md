# Storage Services Documentation (توثيق خدمات التخزين)

This document provides detailed information about the three storage services implemented in the application: Hive, Get Storage, and Shared Preferences.

## Overview (نظرة عامة)

The application implements three different storage solutions to handle different types of data persistence needs:

1. **Hive Storage** - For complex data structures and type-safe storage
2. **Get Storage** - For simple key-value storage with better performance
3. **Shared Preferences** - For platform-specific preferences and settings

## Hive Storage Service (خدمة تخزين Hive)

Hive is a lightweight and blazing fast key-value database written in pure Dart. It's perfect for storing complex data structures with type safety.

### Features (المميزات)
- Type-safe storage
- Fast performance
- No native dependencies
- Cross-platform
- Encryption support
- Lazy loading

### Implementation Details (تفاصيل التنفيذ)

```dart
class HiveStorageService {
  // Initialize Hive with encryption
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Open boxes with encryption
    await Hive.openBox('userBox', encryptionCipher: HiveAesCipher(encryptionKey));
  }

  // Store data with type safety
  Future<void> put<T>(String key, T value) async {
    final box = await Hive.openBox<T>('userBox');
    await box.put(key, value);
  }

  // Retrieve data with type safety
  Future<T?> get<T>(String key) async {
    final box = await Hive.openBox<T>('userBox');
    return box.get(key);
  }
}
```

### Usage Examples (أمثلة الاستخدام)

```dart
// Store a user object
final user = User(name: 'John', age: 30);
await hiveStorage.put('currentUser', user);

// Retrieve the user object
final storedUser = await hiveStorage.get<User>('currentUser');
```

### Best Practices (أفضل الممارسات)
1. Always use type parameters when storing/retrieving data
2. Implement proper error handling
3. Use encryption for sensitive data
4. Close boxes when not in use
5. Implement proper data migration strategies

## Get Storage Service (خدمة تخزين Get)

Get Storage is a fast, extra light, and synchronous key-value storage solution.

### Features (المميزات)
- Synchronous operations
- No native dependencies
- Simple API
- Fast performance
- Small footprint

### Implementation Details (تفاصيل التنفيذ)

```dart
class GetStorageService {
  final GetStorage _storage = GetStorage();

  // Store any type of data
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Read data with type safety
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }
}
```

### Usage Examples (أمثلة الاستخدام)

```dart
// Store a string
await getStorage.write('theme', 'dark');

// Store a map
await getStorage.write('userSettings', {
  'notifications': true,
  'language': 'en'
});

// Read data
final theme = getStorage.read<String>('theme');
final settings = getStorage.read<Map>('userSettings');
```

### Best Practices (أفضل الممارسات)
1. Use for small, simple data
2. Implement proper error handling
3. Use type parameters when reading data
4. Avoid storing large objects
5. Clear storage when appropriate

## Shared Preferences Service (خدمة التفضيلات المشتركة)

Shared Preferences is a persistent storage for primitive data types, implemented using platform-specific storage solutions.

### Features (المميزات)
- Platform-specific implementation
- Simple API
- Good for preferences
- Thread-safe
- Automatic persistence

### Implementation Details (تفاصيل التنفيذ)

```dart
class SharedPrefsStorageService {
  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Store boolean value
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Store string value
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }
}
```

### Usage Examples (أمثلة الاستخدام)

```dart
// Store user preferences
await sharedPrefs.setBool('darkMode', true);
await sharedPrefs.setString('language', 'en');

// Read preferences
final isDarkMode = sharedPrefs.getBool('darkMode');
final language = sharedPrefs.getString('language');
```

### Best Practices (أفضل الممارسات)
1. Use for simple preferences
2. Implement proper error handling
3. Clear preferences when appropriate
4. Use appropriate data types
5. Handle platform-specific limitations

## Choosing the Right Storage (اختيار نوع التخزين المناسب)

| Feature | Hive | Get Storage | Shared Preferences |
|---------|------|-------------|-------------------|
| Type Safety | ✅ | ✅ | ❌ |
| Complex Data | ✅ | ✅ | ❌ |
| Performance | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| Encryption | ✅ | ❌ | ❌ |
| Cross-Platform | ✅ | ✅ | ✅ |
| Native Dependencies | ❌ | ❌ | ✅ |
| Synchronous | ❌ | ✅ | ❌ |

### When to Use Each (متى تستخدم كل نوع)

1. **Use Hive when:**
   - You need type safety
   - Storing complex objects
   - Need encryption
   - Performance is critical

2. **Use Get Storage when:**
   - You need synchronous operations
   - Storing simple key-value pairs
   - Performance is critical
   - No native dependencies needed

3. **Use Shared Preferences when:**
   - Storing simple preferences
   - Need platform-specific features
   - Don't need complex data structures
   - Native implementation is acceptable

## Error Handling (معالجة الأخطاء)

All storage services implement proper error handling:

```dart
try {
  await storageService.write('key', value);
} catch (e) {
  // Handle storage errors
  print('Storage error: $e');
}
```

## Data Migration (هجرة البيانات)

When changing data structures:

1. **Hive:**
   - Use Hive's migration system
   - Implement versioning
   - Handle type changes

2. **Get Storage:**
   - Clear old data
   - Implement version checks
   - Migrate data manually

3. **Shared Preferences:**
   - Clear old preferences
   - Implement version checks
   - Migrate preferences manually

## Testing (الاختبار)

All storage services should be tested:

```dart
void main() {
  group('Storage Tests', () {
    late StorageService storage;

    setUp(() async {
      storage = StorageService();
      await storage.init();
    });

    test('Write and read data', () async {
      await storage.write('test', 'value');
      expect(storage.read('test'), 'value');
    });
  });
}
```

## Security Considerations (اعتبارات الأمن)

1. **Hive:**
   - Use encryption for sensitive data
   - Implement proper key management
   - Clear sensitive data when needed

2. **Get Storage:**
   - Don't store sensitive data
   - Implement proper data clearing
   - Use secure keys

3. **Shared Preferences:**
   - Don't store sensitive data
   - Clear data on logout
   - Use secure keys

## Performance Optimization (تحسين الأداء)

1. **Hive:**
   - Use lazy loading
   - Implement proper box management
   - Clear unused data

2. **Get Storage:**
   - Batch operations
   - Clear unused data
   - Use appropriate data types

3. **Shared Preferences:**
   - Batch operations
   - Clear unused preferences
   - Use appropriate data types 