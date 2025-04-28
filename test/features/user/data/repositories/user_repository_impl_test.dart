import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod/riverpod.dart';

import 'package:clean_architecture_example/features/user/data/repositories/user_repository_impl.dart';
import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/features/user/domain/repositories/user_repository.dart';

import '../datasources/mock_user_local_data_source.dart';
import '../datasources/mock_user_remote_data_source.dart';

class MockConnectivity extends Mock implements Connectivity {}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    localDataSource: MockUserLocalDataSource(),
    remoteDataSource: MockUserRemoteDataSource(),
    connectivity: Connectivity(),
  );
});

void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockConnectivity mockConnectivity;
  late ProviderContainer container;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockConnectivity = MockConnectivity();
    repository = UserRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      connectivity: mockConnectivity,
    );
    
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  final tUsers = [
    UserEntity(id: '1', name: 'Test User 1', email: 'test1@example.com', createdAt: DateTime.now()),
    UserEntity(id: '2', name: 'Test User 2', email: 'test2@example.com', createdAt: DateTime.now()),
  ];

  group('getUsers', () {
    test('should return remote data when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.getUsers())
          .thenAnswer((_) async => tUsers);
      when(() => mockLocalDataSource.createUser(any()))
          .thenAnswer((_) async => tUsers[0]);

      // Act
      final result = await container.read(userRepositoryProvider).getUsers();

      // Assert
      verify(() => mockRemoteDataSource.getUsers()).called(1);
      verify(() => mockLocalDataSource.createUser(any())).called(tUsers.length);
      expect(result, equals(tUsers));
    });

    test('should return local data when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(() => mockLocalDataSource.getUsers())
          .thenAnswer((_) async => tUsers);

      // Act
      final result = await container.read(userRepositoryProvider).getUsers();

      // Assert
      verify(() => mockLocalDataSource.getUsers()).called(1);
      verifyNever(() => mockRemoteDataSource.getUsers());
      expect(result, equals(tUsers));
    });
  });

  group('getUser', () {
    const tId = '1';
    final tUser = UserEntity(id: tId, name: 'Test User', email: 'test@example.com', createdAt: DateTime.now());

    test('should return remote data when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.getUser(tId))
          .thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.createUser(tUser))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await container.read(userRepositoryProvider).getUser(tId);

      // Assert
      verify(() => mockRemoteDataSource.getUser(tId)).called(1);
      verify(() => mockLocalDataSource.createUser(tUser)).called(1);
      expect(result, equals(tUser));
    });

    test('should return local data when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(() => mockLocalDataSource.getUser(tId))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await container.read(userRepositoryProvider).getUser(tId);

      // Assert
      verify(() => mockLocalDataSource.getUser(tId)).called(1);
      verifyNever(() => mockRemoteDataSource.getUser(tId));
      expect(result, equals(tUser));
    });
  });

  group('createUser', () {
    final tUser = UserEntity(id: '1', name: 'Test User', email: 'test@example.com', createdAt: DateTime.now());

    test('should create user remotely when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.createUser(tUser))
          .thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.createUser(tUser))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await container.read(userRepositoryProvider).createUser(tUser);

      // Assert
      verify(() => mockRemoteDataSource.createUser(tUser)).called(1);
      verify(() => mockLocalDataSource.createUser(tUser)).called(1);
      expect(result, equals(tUser));
    });

    test('should create user locally when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(() => mockLocalDataSource.createUser(tUser))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await container.read(userRepositoryProvider).createUser(tUser);

      // Assert
      verify(() => mockLocalDataSource.createUser(tUser)).called(1);
      verifyNever(() => mockRemoteDataSource.createUser(tUser));
      expect(result, equals(tUser));
    });
  });

  group('updateUser', () {
    final tUser = UserEntity(id: '1', name: 'Test User', email: 'test@example.com', createdAt: DateTime.now());

    test('should update user remotely when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.updateUser(tUser.id, tUser))
          .thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.updateUser(tUser.id, tUser))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await container.read(userRepositoryProvider).updateUser(tUser.id, tUser);

      // Assert
      verify(() => mockRemoteDataSource.updateUser(tUser.id, tUser)).called(1);
      verify(() => mockLocalDataSource.updateUser(tUser.id, tUser)).called(1);
      expect(result, equals(tUser));
    });

    test('should update user locally when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(() => mockLocalDataSource.updateUser(tUser.id, tUser))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await container.read(userRepositoryProvider).updateUser(tUser.id, tUser);

      // Assert
      verify(() => mockLocalDataSource.updateUser(tUser.id, tUser)).called(1);
      verifyNever(() => mockRemoteDataSource.updateUser(tUser.id, tUser));
      expect(result, equals(tUser));
    });
  });

  group('deleteUser', () {
    const tId = '1';

    test('should delete user remotely when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.deleteUser(tId))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.deleteUser(tId))
          .thenAnswer((_) async {});

      // Act
      await container.read(userRepositoryProvider).deleteUser(tId);

      // Assert
      verify(() => mockRemoteDataSource.deleteUser(tId)).called(1);
      verify(() => mockLocalDataSource.deleteUser(tId)).called(1);
    });

    test('should delete user locally when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(() => mockLocalDataSource.deleteUser(tId))
          .thenAnswer((_) async {});

      // Act
      await container.read(userRepositoryProvider).deleteUser(tId);

      // Assert
      verify(() => mockLocalDataSource.deleteUser(tId)).called(1);
      verifyNever(() => mockRemoteDataSource.deleteUser(tId));
    });
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    final tUser = UserEntity(id: '1', name: 'Test User', email: tEmail, createdAt: DateTime.now());

    test('should login and save current user when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.login(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.saveCurrentUser(tUser))
          .thenAnswer((_) async {});

      // Act
      final result = await container.read(userRepositoryProvider).login(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      verify(() => mockRemoteDataSource.login(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verify(() => mockLocalDataSource.saveCurrentUser(tUser)).called(1);
      expect(result, equals(tUser));
    });

    test('should throw exception when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      // Act & Assert
      expect(
        () => container.read(userRepositoryProvider).login(
          email: tEmail,
          password: tPassword,
        ),
        throwsException,
      );
    });
  });

  group('register', () {
    const tName = 'Test User';
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    final tUser = UserEntity(id: '1', name: tName, email: tEmail, createdAt: DateTime.now());

    test('should register and save current user when online', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(() => mockRemoteDataSource.register(
            name: tName,
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.saveCurrentUser(tUser))
          .thenAnswer((_) async {});

      // Act
      final result = await container.read(userRepositoryProvider).register(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      // Assert
      verify(() => mockRemoteDataSource.register(
            name: tName,
            email: tEmail,
            password: tPassword,
          )).called(1);
      verify(() => mockLocalDataSource.saveCurrentUser(tUser)).called(1);
      expect(result, equals(tUser));
    });

    test('should throw exception when offline', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      // Act & Assert
      expect(
        () => container.read(userRepositoryProvider).register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
        throwsException,
      );
    });
  });
} 