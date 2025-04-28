import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends AsyncNotifier<List<UserEntity>> {
  @override
  Future<List<UserEntity>> build() async {
    return [];
  }

  Future<void> addUser(UserEntity user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final users = [...?state.value];
      users.add(user);
      return users;
    });
  }

  Future<void> updateUser(UserEntity user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final users = [...?state.value];
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
      }
      return users;
    });
  }

  Future<void> deleteUser(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final users = [...?state.value];
      users.removeWhere((user) => user.id == id);
      return users;
    });
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, List<UserEntity>>(() {
  return UserNotifier();
}); 