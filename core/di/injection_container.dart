import 'package:get_it/get_it.dart';
import '../../lib/features/profile/data/repositories/profile_repository.dart';
import '../../lib/features/profile/domain/services/profile_service.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  // Services
  sl.registerLazySingleton<ProfileService>(() => ProfileService());
} 