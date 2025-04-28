import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import 'user_list_page.dart';

class MockUserNotifier extends UserNotifier {
  @override
  Future<List<UserEntity>> build() async => [];

  void setUsers(List<UserEntity> users) {
    state = AsyncValue.data(users);
  }

  void setError(Object error) {
    state = AsyncValue.error(error, StackTrace.current);
  }
}

void main() {
  late ProviderContainer container;
  late MockUserNotifier mockUserNotifier;

  setUp(() {
    mockUserNotifier = MockUserNotifier();
    container = ProviderContainer(
      overrides: [
        userProvider.overrideWith(() => mockUserNotifier),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('UserListPage shows loading indicator', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: UserListPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('UserListPage shows error message', (tester) async {
    mockUserNotifier.setError('Test error');

    await tester.pumpWidget(
     const  ProviderScope(
        child:  MaterialApp(
          home: UserListPage(),
        ),
      ),
    );

    expect(find.text('Error: Test error'), findsOneWidget);
  });

  testWidgets('UserListPage shows empty state', (tester) async {
    mockUserNotifier.setUsers([]);

    await tester.pumpWidget(
   const   ProviderScope(
        child:  MaterialApp(
          home: UserListPage(),
        ),
      ),
    );

    expect(find.text('No users found'), findsOneWidget);
  });

  testWidgets('UserListPage shows user list', (tester) async {
    final users = [
      UserEntity(
          id: '1',
          name: 'Test User 1',
          email: 'test1@example.com',
          createdAt: DateTime(2023, 1, 1)),
      UserEntity(
          id: '2',
          name: 'Test User 2',
          email: 'test2@example.com',
          createdAt: DateTime(2023, 1, 1)),
    ];

    mockUserNotifier.setUsers(users);

    await tester.pumpWidget(
     const ProviderScope(
        child:  MaterialApp(
          home: UserListPage(),
        ),
      ),
    );

    expect(find.text('Test User 1'), findsOneWidget);
    expect(find.text('Test User 2'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNWidgets(2));
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
  });
}
