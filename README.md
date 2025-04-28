# Clean Architecture Flutter Project

This project demonstrates a clean architecture implementation in Flutter, following best practices and SOLID principles.

## Project Structure

```
lib/
├── core/
│   ├── api/
│   ├── database/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── user/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── product/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Architecture Layers

### 1. Presentation Layer
- Contains UI components (Screens, Widgets)
- Uses BLoC for state management
- Implements MVVM pattern

### 2. Domain Layer
- Contains business logic
- Defines entities and use cases
- Repository interfaces

### 3. Data Layer
- Implements repository interfaces
- Handles data sources (local and remote)
- Data models and DTOs

## Key Features

1. **Clean Architecture**
   - Separation of concerns
   - Dependency injection
   - SOLID principles

2. **State Management**
   - BLoC pattern
   - Riverpod for dependency injection
   - Reactive programming

3. **Data Management**
   - Local SQLite database
   - Remote API integration
   - Offline-first approach

4. **Testing**
   - Unit tests
   - Widget tests
   - Integration tests

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- `flutter_bloc`: State management
- `riverpod`: Dependency injection
- `sqflite`: Local database
- `dio`: HTTP client
- `freezed`: Code generation
- `mocktail`: Testing

## Development Guidelines

1. **Code Style**
   - Follow Flutter style guide
   - Use meaningful names
   - Write documentation

2. **Architecture**
   - Keep layers independent
   - Use interfaces for dependencies
   - Follow SOLID principles

3. **Testing**
   - Write tests for all features
   - Maintain high test coverage
   - Follow TDD approach

## Documentation

For more detailed information about testing, see [test/README.md](test/README.md)

# Clean Architecture Testing Guide

This guide explains the different types of testing in our Flutter Clean Architecture project and how to implement them effectively.

## Types of Testing

### 1. Unit Tests (اختبارات الوحدة)

Unit tests focus on testing individual components in isolation. In our Clean Architecture, we test:
- Use Cases
- Repositories
- Data Sources
- Models

#### Example from our project:
```dart
// test/features/user/data/repositories/user_repository_impl_test.dart
test('should return remote data when online', () async {
  // arrange
  when(() => mockConnectivity.checkConnectivity())
      .thenAnswer((_) async => ConnectivityResult.wifi);
  when(() => mockRemoteDataSource.getUsers())
      .thenAnswer((_) async => tUsers);
  when(() => mockLocalDataSource.insertUser(any()))
      .thenAnswer((_) async => 1);

  // act
  final result = await repository.getUsers();

  // assert
  verify(() => mockRemoteDataSource.getUsers()).called(1);
  verify(() => mockLocalDataSource.insertUser(tUser)).called(1);
  expect(result, equals(tUsers));
});
```

#### Why Unit Tests?
- Fast execution
- Isolated testing
- Easy to maintain
- Helps in TDD (Test-Driven Development)

### 2. Widget Tests (اختبارات الواجهة)

Widget tests verify the UI components work as expected. We test:
- Screens
- Widgets
- State Management
- User Interactions

#### Example Structure:
```dart
// test/features/user/presentation/pages/user_list_page_test.dart
void main() {
  testWidgets('UserListPage displays loading indicator', (WidgetTester tester) async {
    // arrange
    await tester.pumpWidget(
      MaterialApp(
        home: UserListPage(),
      ),
    );

    // act
    await tester.pump();

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

#### Why Widget Tests?
- Verify UI components
- Test user interactions
- Ensure proper state management
- Validate widget tree structure

### 3. Integration Tests (اختبارات التكامل)

Integration tests verify that different parts of the application work together. We test:
- Complete features
- Navigation flows
- API integration
- Database operations

#### Example Structure:
```dart
// test_driver/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete user flow', (WidgetTester tester) async {
    // arrange
    await tester.pumpWidget(MyApp());

    // act - navigate to user list
    await tester.tap(find.byIcon(Icons.people));
    await tester.pumpAndSettle();

    // act - add new user
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // act - fill form
    await tester.enterText(find.byType(TextField).first, 'Test User');
    await tester.enterText(find.byType(TextField).last, 'test@example.com');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // assert
    expect(find.text('Test User'), findsOneWidget);
  });
}
```

#### Why Integration Tests?
- Test complete user flows
- Verify system integration
- End-to-end testing
- Real-world scenario simulation

## Testing Best Practices

### 1. Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange-Act-Assert)

### 2. Mocking
- Use `mocktail` for mocking
- Mock external dependencies
- Verify mock interactions

### 3. Test Coverage
- Aim for high coverage
- Focus on critical paths
- Test edge cases

### 4. Test Data
- Use test fixtures
- Create reusable test data
- Keep test data separate

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/user/data/repositories/user_repository_impl_test.dart

# Run tests with coverage
flutter test --coverage
```

## Test-Driven Development (TDD)

1. Write failing test
2. Implement minimum code to pass
3. Refactor while keeping tests green
4. Repeat

## Common Testing Patterns

### 1. Repository Pattern Testing
```dart
test('repository handles offline mode', () async {
  // arrange
  when(() => mockConnectivity.checkConnectivity())
      .thenAnswer((_) async => ConnectivityResult.none);
  
  // act
  final result = await repository.getData();
  
  // assert
  expect(result, isA<LocalData>());
});
```

### 2. Use Case Testing
```dart
test('use case processes data correctly', () async {
  // arrange
  final mockRepository = MockRepository();
  final useCase = MyUseCase(mockRepository);
  
  // act
  final result = await useCase.execute();
  
  // assert
  expect(result, isSuccessful);
});
```

### 3. Widget Testing
```dart
testWidgets('widget updates state correctly', (tester) async {
  // arrange
  await tester.pumpWidget(MyWidget());
  
  // act
  await tester.tap(find.byIcon(Icons.refresh));
  await tester.pump();
  
  // assert
  expect(find.byType(LoadingIndicator), findsOneWidget);
});
```

## Testing Tools

1. `mocktail`: For mocking dependencies
2. `flutter_test`: For widget testing
3. `integration_test`: For integration testing
4. `build_runner`: For generating mocks

## Common Pitfalls

1. Not mocking external dependencies
2. Testing implementation details
3. Over-mocking
4. Not cleaning up test data
5. Ignoring edge cases

## Conclusion

Testing is crucial for maintaining a robust and reliable application. By implementing all three types of tests (Unit, Widget, and Integration), we ensure that our application works correctly at all levels.

Remember:
- Write tests first (TDD)
- Keep tests simple and focused
- Maintain high test coverage
- Test both success and failure cases
- Keep tests up to date with code changes
