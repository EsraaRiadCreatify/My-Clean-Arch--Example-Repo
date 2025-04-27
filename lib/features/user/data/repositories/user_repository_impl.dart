import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> getUser(String id) async {
    try {
      return await _remoteDataSource.getUser(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      return await _remoteDataSource.getUsers();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    try {
      return await _remoteDataSource.createUser(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> updateUser(String id, UserEntity user) async {
    try {
      return await _remoteDataSource.updateUser(id, user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _remoteDataSource.deleteUser(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
} 