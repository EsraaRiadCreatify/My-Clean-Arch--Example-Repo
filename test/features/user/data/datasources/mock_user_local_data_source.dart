import 'package:mocktail/mocktail.dart';
import 'package:clean_architecture_example/features/user/data/datasources/user_local_data_source.dart';
import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {
  @override
  Future<List<UserEntity>> getUsers() async {
    return Future.value([]);
  }

  @override
  Future<UserEntity?> getUser(String id) async {
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
  Future<void> deleteAllUsers() async {
    return Future.value();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return Future.value(UserEntity(id: '1', name: 'Test User', email: 'test@example.com', createdAt: DateTime.now()));
  }

  @override
  Future<void> saveCurrentUser(UserEntity user) async {
    return Future.value();
  }

  @override
  Future<void> deleteCurrentUser() async {
    return Future.value();
  }
} 