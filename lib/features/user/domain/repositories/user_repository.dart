import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String id);
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> createUser(UserEntity user);
  Future<UserEntity> updateUser(String id, UserEntity user);
  Future<void> deleteUser(String id);
  
  // Authentication methods
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  Future<UserEntity> login({
    required String email,
    required String password,
  });
  
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });
} 