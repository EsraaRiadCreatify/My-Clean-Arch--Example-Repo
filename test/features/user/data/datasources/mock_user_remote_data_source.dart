import 'package:mocktail/mocktail.dart';
import 'package:clean_architecture_example/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {
  @override
  Future<List<UserEntity>> getUsers() async {
    return Future.value([]);
  }

  @override
  Future<UserEntity> getUser(String id) async {
    return Future.value(UserEntity(id: id, name: 'Test User', email: 'test@example.com', createdAt: DateTime.now()));
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    return Future.value(user);
  }

  @override
  Future<UserEntity> updateUser(String id, UserEntity user) async {
    return Future.value(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    return Future.value();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return Future.value();
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return Future.value(UserEntity(id: '1', name: 'Test User', email: email, createdAt: DateTime.now()));
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return Future.value(UserEntity(id: '1', name: name, email: email, createdAt: DateTime.now()));
  }
} 