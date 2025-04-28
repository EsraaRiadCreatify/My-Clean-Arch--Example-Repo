# Testing Implementation Guide

This document explains the testing implementation in our Clean Architecture project.

## Test Structure

```
test/
├── features/
│   ├── user/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── blocs/
│   │       └── pages/
│   └── product/
│       └── ... (similar structure)
├── core/
│   ├── api/
│   ├── database/
│   └── utils/
└── integration/
    └── app_test.dart
```

## 1. Unit Tests Implementation

### Repository Tests
```dart
// test/features/user/data/repositories/user_repository_impl_test.dart
void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockConnectivity = MockConnectivity();
    
    repository = UserRepositoryImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
      mockConnectivity,
    );
  });

  group('getUsers', () {
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
  });
}
```

### Use Case Tests
```dart
// test/features/user/domain/usecases/get_users_usecase_test.dart
void main() {
  late GetUsersUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUsersUseCase(mockRepository);
  });

  test('should get users from repository', () async {
    // arrange
    final tUsers = [User(id: 1, name: 'Test User')];
    when(() => mockRepository.getUsers())
        .thenAnswer((_) async => tUsers);

    // act
    final result = await useCase.execute();

    // assert
    verify(() => mockRepository.getUsers()).called(1);
    expect(result, equals(tUsers));
  });
}
```

## 2. Widget Tests Implementation

### Page Tests
```dart
// test/features/user/presentation/pages/user_list_page_test.dart
void main() {
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  testWidgets('should show loading indicator when state is loading', (tester) async {
    // arrange
    when(() => mockUserBloc.state)
        .thenReturn(UserLoading());
    when(() => mockUserBloc.stream)
        .thenAnswer((_) => Stream.value(UserLoading()));

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockUserBloc,
          child: UserListPage(),
        ),
      ),
    );

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### Widget Tests
```dart
// test/features/user/presentation/widgets/user_card_test.dart
void main() {
  testWidgets('should display user information correctly', (tester) async {
    // arrange
    final user = User(
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
    );

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: UserCard(user: user),
      ),
    );

    // assert
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });
}
```

## 3. Integration Tests Implementation

### Feature Flow Tests
```dart
// test/integration/user_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete user management flow', (tester) async {
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

## Test Coverage

We maintain high test coverage by:
1. Writing tests for all new features
2. Testing both success and failure cases
3. Using code coverage tools
4. Following TDD approach

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/user/data/repositories/user_repository_impl_test.dart

# Run tests with coverage
flutter test --coverage
```

## Best Practices

1. **Test Organization**
   - Group related tests
   - Use descriptive names
   - Follow AAA pattern

2. **Mocking**
   - Mock external dependencies
   - Use mocktail for mocking
   - Verify mock interactions

3. **Test Data**
   - Use test fixtures
   - Create reusable test data
   - Keep test data separate

4. **Maintenance**
   - Keep tests up to date
   - Refactor tests with code
   - Document test requirements 