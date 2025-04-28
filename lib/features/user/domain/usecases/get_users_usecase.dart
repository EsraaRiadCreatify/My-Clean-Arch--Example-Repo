import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/features/user/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.getUsers();
  }
} 