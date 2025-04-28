import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_architecture_example/features/user/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/features/user/domain/repositories/user_repository.dart';
import 'package:clean_architecture_example/features/user/domain/usecases/get_users_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUseCase useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetUsersUseCase(mockUserRepository);
  });

  final tUsers = [
    UserEntity(id: '1', name: 'Test User 1', email: 'test1@example.com', createdAt: DateTime(2023, 1, 1)),
    UserEntity(id: '2', name: 'Test User 2', email: 'test2@example.com', createdAt: DateTime(2023, 1, 1)),
  ];

  test('should get users from the repository', () async {
    // arrange
    when(() => mockUserRepository.getUsers())
        .thenAnswer((_) async => tUsers);

    // act
    final result = await useCase();

    // assert
    verify(() => mockUserRepository.getUsers()).called(1);
    expect(result, equals(tUsers));
  });

  test('should return empty list when repository returns empty list', () async {
    // arrange
    when(() => mockUserRepository.getUsers())
        .thenAnswer((_) async => <UserEntity>[]);

    // act
    final result = await useCase();

    // assert
    verify(() => mockUserRepository.getUsers()).called(1);
    expect(result, isEmpty);
  });

  test('should propagate error when repository throws error', () async {
    // arrange
    when(() => mockUserRepository.getUsers())
        .thenThrow(Exception('Failed to get users'));

    // act
    final call = useCase;

    // assert
    expect(() => call(), throwsException);
    verify(() => mockUserRepository.getUsers()).called(1);
  });
} 