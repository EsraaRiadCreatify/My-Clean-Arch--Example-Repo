import '../../domain/entities/user_entity.dart';
import '../../../../core/api/network/api_client.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<UserEntity> getUser(String id) async {
    final response = await _apiClient.get<UserEntity>(
      endpoint: '/users/$id',
    );
    return response.data!;
  }

  Future<List<UserEntity>> getUsers() async {
    final response = await _apiClient.get<List<UserEntity>>(
      endpoint: '/users',
    );
    return response.data!;
  }

  Future<UserEntity> createUser(UserEntity user) async {
    final response = await _apiClient.post<UserEntity>(
      endpoint: '/users',
      data: user.toJson(),
    );
    return response.data!;
  }

  Future<UserEntity> updateUser(String id, UserEntity user) async {
    final response = await _apiClient.put<UserEntity>(
      endpoint: '/users/$id',
      data: user.toJson(),
    );
    return response.data!;
  }

  Future<void> deleteUser(String id) async {
    await _apiClient.delete<void>(
      endpoint: '/users/$id',
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post<void>(
      endpoint: '/users/change-password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<UserEntity>(
      endpoint: '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data!;
  }

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<UserEntity>(
      endpoint: '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    return response.data!;
  }
} 