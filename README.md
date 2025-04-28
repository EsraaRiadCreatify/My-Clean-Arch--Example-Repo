# Clean Architecture Example

This project demonstrates a clean architecture implementation in Flutter using Riverpod for state management. It follows the principles of clean architecture to create a maintainable, testable, and scalable application.

## Table of Contents
- [Project Overview](#project-overview)
- [Architecture Layers](#architecture-layers)
- [Project Structure](#project-structure)
- [Core Services](#core-services)
- [Features](#features)
- [State Management](#state-management)
- [Testing Strategy](#testing-strategy)
- [Getting Started](#getting-started)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

This project implements a user management system using Clean Architecture principles. It demonstrates:

- **Clean Architecture**: Separation of concerns with clear boundaries between layers
- **State Management**: Using Riverpod for predictable state management
- **Offline-First**: Local storage with SQLite and remote API synchronization
- **Testing**: Comprehensive test coverage at all levels
- **Dependency Injection**: Flexible and testable service management

## Architecture Layers

### 1. Presentation Layer
- **Pages**: UI screens and layouts
- **Widgets**: Reusable UI components
- **Providers**: State management using Riverpod
- **Responsibility**: Handles user interaction and displays data

### 2. Domain Layer
- **Entities**: Business objects and rules
- **Use Cases**: Application-specific business rules
- **Repository Interfaces**: Contracts for data operations
- **Responsibility**: Contains business logic and rules

### 3. Data Layer
- **Repositories**: Implementation of repository interfaces
- **Data Sources**: Local and remote data handling
- **Models**: Data transfer objects and mappers
- **Responsibility**: Manages data operations and storage

## Project Structure

```
lib/
├── core/                    # Core functionality and utilities
│   ├── api/                 # API related code
│   │   ├── api_client.dart  # HTTP client implementation
│   │   └── exceptions/      # Custom API exceptions
│   ├── di/                  # Dependency injection
│   │   └── injection.dart   # Service locator setup
│   ├── network/             # Network related code
│   │   └── network_info.dart # Network connectivity check
│   ├── storage/             # Local storage
│   │   └── storage_service.dart # Storage service interface
│   └── utils/               # Utility functions
│       └── constants.dart   # App constants
├── features/                # Feature modules
│   └── user/                # User feature
│       ├── data/            # Data layer
│       │   ├── datasources/ # Data sources
│       │   │   ├── user_local_data_source.dart
│       │   │   └── user_remote_data_source.dart
│       │   ├── models/      # Data models
│       │   └── repositories/ # Repository implementations
│       ├── domain/          # Domain layer
│       │   ├── entities/    # Business entities
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/    # Use cases
│       └── presentation/    # Presentation layer
│           ├── pages/       # UI pages
│           ├── providers/   # State providers
│           └── widgets/     # Reusable widgets
└── main.dart                # Application entry point
```

## Core Services

### 1. API Client
```dart
class ApiClient {
  final Dio _dio;
  
  Future<Response> get(String path) async {
    return _dio.get(path);
  }
  
  Future<Response> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }
}
```
- Handles all HTTP requests
- Manages authentication
- Handles error responses
- Configurable timeouts and interceptors

### 2. Storage Service
```dart
abstract class StorageService {
  Future<void> save(String key, String value);
  Future<String?> get(String key);
  Future<void> delete(String key);
}
```
- Manages local data persistence
- SQLite database operations
- Secure storage for sensitive data
- Cache management

### 3. Network Info
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onConnectivityChanged;
}
```
- Monitors internet connectivity
- Provides real-time connection status
- Handles offline/online transitions
- Supports different connection types

### 4. Dependency Injection
```dart
void init() {
  // Core services
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  // Feature services
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    localDataSource: sl(),
    remoteDataSource: sl(),
    networkInfo: sl(),
  ));
}
```
- Manages service lifecycle
- Provides dependency resolution
- Supports testing with mock implementations
- Configurable service registration

## Features

### User Management
- User registration and login
- Profile management
- Password reset
- User list and details

### Data Synchronization
- Offline data storage
- Automatic sync when online
- Conflict resolution
- Data consistency checks

### Error Handling
- Network error recovery
- Data validation
- User-friendly error messages
- Logging and monitoring

## State Management

### Provider Setup
```dart
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<List<UserEntity>>>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});
```

### State Updates
```dart
class UserNotifier extends StateNotifier<AsyncValue<List<UserEntity>>> {
  final UserRepository _repository;
  
  UserNotifier(this._repository) : super(const AsyncValue.loading());
  
  Future<void> getUsers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getUsers());
  }
}
```

### State Usage
```dart
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userProvider);
    
    return usersAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => UserListItem(user: users[index]),
      ),
    );
  }
}
```

## Testing Strategy

### 1. Unit Tests
```dart
test('repository handles offline mode', () async {
  when(() => mockConnectivity.checkConnectivity())
      .thenAnswer((_) async => ConnectivityResult.none);
  
  final result = await repository.getUsers();
  
  expect(result, isA<List<UserEntity>>());
  verify(() => mockLocalDataSource.getUsers()).called(1);
});
```

### 2. Widget Tests
```dart
testWidgets('UserListPage displays loading state', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: UserListPage()),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### 3. Integration Tests
```dart
test('Complete user flow', () async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byType(TextField).first, 'Test User');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  
  expect(find.text('Test User'), findsOneWidget);
});
```

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code
- Git

### Installation
1. Clone the repository:
```bash
git clone https://github.com/yourusername/clean-architecture-example.git
cd clean-architecture-example
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

4. Run tests:
```bash
flutter test
```

### Configuration
1. Update API configuration in `lib/core/utils/constants.dart`
2. Configure database settings in `lib/core/storage/storage_service.dart`
3. Set up environment variables in `.env` file

## Best Practices

### 1. Clean Architecture Principles
- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Rule**: Dependencies point inward
- **Interface Segregation**: Small, focused interfaces
- **Single Responsibility**: Each class has one reason to change

### 2. Code Organization
- **Feature-First**: Organize by feature, not by type
- **Clear Boundaries**: Strict separation between layers
- **Consistent Naming**: Follow naming conventions
- **Documentation**: Document public APIs and complex logic

### 3. Testing
- **TDD**: Write tests before implementation
- **Mock Dependencies**: Isolate components for testing
- **Coverage**: Maintain high test coverage
- **CI/CD**: Automate testing in pipeline

### 4. State Management
- **Immutable State**: State changes through new objects
- **Unidirectional Flow**: Data flows in one direction
- **Predictable Updates**: Clear state transition rules
- **Error Handling**: Graceful error states

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Flutter style guide
- Use meaningful names
- Write documentation
- Keep methods small and focused

### Pull Request Process
1. Update documentation
2. Add tests for new features
3. Ensure all tests pass
4. Update version numbers
5. Create detailed PR description

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@example.com or join our Slack channel.
