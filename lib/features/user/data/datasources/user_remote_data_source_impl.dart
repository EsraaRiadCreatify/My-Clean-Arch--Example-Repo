import 'package:clean_architecture_example/core/api/network/api_client.dart';
import 'package:clean_architecture_example/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserEntity>> getUsers() async {
    final response = await _apiClient.get('/users');
    return (response.data as List)
        .map((user) => UserEntity.fromJson(user))
        .toList();
  }

  @override
  Future<UserEntity> getUser(String id) async {
    final response = await _apiClient.get('/users/$id');
    if (response.data == null) {
      throw Exception('User not found');
    }
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final response = await _apiClient.post('/users', data: user.toJson());
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<UserEntity> updateUser(String id, UserEntity user) async {
    final response = await _apiClient.put('/users/$id', data: user.toJson());
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _apiClient.delete('/users/$id');
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post('/users/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return UserEntity.fromJson(response.data);
  }
} 