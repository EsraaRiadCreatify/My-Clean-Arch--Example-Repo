import 'package:clean_architecture_example/core/database/database_helper.dart';
import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';

abstract class UserLocalDataSource {
  /// Get all users from local storage
  Future<List<UserEntity>> getUsers();

  /// Get a specific user by ID from local storage
  Future<UserEntity?> getUser(String id);

  /// Create a new user in local storage
  Future<UserEntity> createUser(UserEntity user);

  /// Update an existing user in local storage
  Future<UserEntity> updateUser(String id, UserEntity user);

  /// Delete a user from local storage
  Future<void> deleteUser(String id);

  /// Delete all users from local storage
  Future<void> deleteAllUsers();

  /// Get the current logged-in user from local storage
  Future<UserEntity?> getCurrentUser();

  /// Save the current user to local storage
  Future<void> saveCurrentUser(UserEntity user);

  /// Delete the current user from local storage
  Future<void> deleteCurrentUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final DatabaseHelper _dbHelper;

  UserLocalDataSourceImpl(this._dbHelper);

  @override
  Future<List<UserEntity>> getUsers() async {
    final db = await _dbHelper.database;
    final users = await db.query('users');
    return users.map((user) => UserEntity.fromJson(user)).toList();
  }

  @override
  Future<UserEntity?> getUser(String id) async {
    final db = await _dbHelper.database;
    final users = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (users.isEmpty) return null;
    return UserEntity.fromJson(users.first);
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final db = await _dbHelper.database;
    await db.insert('users', user.toJson());
    return user;
  }

  @override
  Future<UserEntity> updateUser(String id, UserEntity user) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
    return user;
  }

  @override
  Future<void> deleteUser(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllUsers() async {
    final db = await _dbHelper.database;
    await db.delete('users');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final db = await _dbHelper.database;
    final users = await db.query(
      'users',
      where: 'isCurrentUser = ?',
      whereArgs: [true],
    );
    if (users.isEmpty) return null;
    return UserEntity.fromJson(users.first);
  }

  @override
  Future<void> saveCurrentUser(UserEntity user) async {
    final db = await _dbHelper.database;
    // First, set all users as not current
    await db.update(
      'users',
      {'isCurrentUser': false},
      where: 'isCurrentUser = ?',
      whereArgs: [true],
    );
    // Then set the new current user
    await db.update(
      'users',
      {'isCurrentUser': true},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteCurrentUser() async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {'isCurrentUser': false},
      where: 'isCurrentUser = ?',
      whereArgs: [true],
    );
  }
} 