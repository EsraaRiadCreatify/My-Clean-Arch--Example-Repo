import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
    required Connectivity connectivity,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivity = connectivity;

  Future<bool> _isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<UserEntity> getUser(String id) async {
    try {
      if (await _isConnected()) {
        final user = await _remoteDataSource.getUser(id);
        await _localDataSource.createUser(user);
        return user;
      }
      final localUser = await _localDataSource.getUser(id);
      if (localUser == null) {
        throw Exception('User not found in local storage');
      }
      return localUser;
    } catch (e) {
      final localUser = await _localDataSource.getUser(id);
      if (localUser == null) {
        throw Exception('User not found');
      }
      return localUser;
    }
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      if (await _isConnected()) {
        final users = await _remoteDataSource.getUsers();
        for (var user in users) {
          await _localDataSource.createUser(user);
        }
        return users;
      }
      return await _localDataSource.getUsers();
    } catch (e) {
      return await _localDataSource.getUsers();
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    try {
      if (await _isConnected()) {
        final createdUser = await _remoteDataSource.createUser(user);
        await _localDataSource.createUser(createdUser);
        return createdUser;
      } else {
        return await _localDataSource.createUser(user);
      }
    } catch (e) {
      return await _localDataSource.createUser(user);
    }
  }

  @override
  Future<UserEntity> updateUser(String id, UserEntity user) async {
    try {
      if (await _isConnected()) {
        final updatedUser = await _remoteDataSource.updateUser(id, user);
        await _localDataSource.updateUser(id, updatedUser);
        return updatedUser;
      } else {
        return await _localDataSource.updateUser(id, user);
      }
    } catch (e) {
      return await _localDataSource.updateUser(id, user);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      if (await _isConnected()) {
        await _remoteDataSource.deleteUser(id);
      }
      await _localDataSource.deleteUser(id);
    } catch (e) {
      await _localDataSource.deleteUser(id);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await _isConnected()) {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (await _isConnected()) {
      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _localDataSource.saveCurrentUser(user);
      return user;
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (await _isConnected()) {
      final user = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await _localDataSource.saveCurrentUser(user);
      return user;
    } else {
      throw Exception('No internet connection');
    }
  }
} 