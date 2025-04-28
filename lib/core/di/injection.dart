import 'package:api/features/profile/data/repositories/profile_repository.dart';
import 'package:api/features/profile/domain/services/profile_service.dart';
import 'package:get_it/get_it.dart';
import '../api/network/api_client.dart';
import '../api/config/api_config.dart';
import '../api/config/api_interceptor.dart';
import '../../features/user/data/datasources/user_remote_data_source.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // API Configuration
  getIt.registerLazySingleton<ApiConfig>(() => const  ApiConfig(
    baseUrl: 'https://api.example.com',
    timeout:  Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    enableLogging: true,
    useCache: true,
    handleErrors: true,
    returnErrorResponse: true,
    validateResponse: true,
  ));

  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(
    config: getIt<ApiConfig>(),
    interceptor: ApiInterceptor(),
  ));

  // User Feature
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserRemoteDataSource>()),
  );
   // Repositories
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  // Services
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
} 