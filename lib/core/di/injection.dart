import 'package:clean_architecture_example/features/profile/data/repositories/profile_repository.dart';
import 'package:clean_architecture_example/features/profile/domain/services/profile_service.dart';
import 'package:clean_architecture_example/features/user/data/datasources/user_local_data_source.dart';
import 'package:clean_architecture_example/features/user/data/datasources/user_remote_data_source.dart';

import 'package:clean_architecture_example/core/database/database_helper.dart';
import 'package:clean_architecture_example/features/user/data/datasources/user_remote_data_source_impl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../api/config/api_config.dart';
import '../api/interceptors/auth_interceptor.dart';
import '../api/interceptors/error_interceptor.dart';
import '../api/interceptors/logger_interceptor.dart';
import '../api/interceptors/retry_interceptor.dart';
import '../api/network/api_client.dart';
import '../api/utils/api_cache.dart';
import '../api/utils/api_validator.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  await _initExternal();

  // Core
  _initCore();

  // Features
  _initFeatures();
}

Future<void> _initExternal() async {
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  final box = await Hive.openBox('appBox');
  sl.registerSingleton<Box>(box);

  // Initialize Memory Storage
  final memoryStorage = <String, dynamic>{};
  sl.registerSingleton<Map<String, dynamic>>(memoryStorage);

  // Initialize Connectivity
  sl.registerSingleton<Connectivity>(Connectivity());
}

void _initCore() {
  // API Config
  final config = ApiConfig(
    baseUrl: 'YOUR_BASE_URL',
    timeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  sl.registerLazySingleton<ApiConfig>(() => config);

  // API Cache
  sl.registerLazySingleton<ApiCache>(() => ApiCache(sl<SharedPreferences>()));

  // API Validator
  sl.registerLazySingleton<ApiValidator>(() => ApiValidator());

  // API Client
  sl.registerLazySingleton<ApiClient>(() {
    final apiClient = ApiClient(
      config: config,
      cache: sl<ApiCache>(),
    );
    return apiClient;
  });

  // Interceptors
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl<SharedPreferences>()));
  sl.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor(
        prefs: sl<SharedPreferences>(),
        hiveBox: sl<Box>(),
        memoryStorage: sl<Map<String, dynamic>>(),
      ));
  sl.registerLazySingleton<LoggerInterceptor>(() => LoggerInterceptor());
  sl.registerLazySingleton<RetryInterceptor>(() => RetryInterceptor(sl<ApiClient>().dio));

  // Add interceptors to ApiClient's Dio instance
  final apiClient = sl<ApiClient>();
  apiClient.dio.interceptors.addAll([
    sl<AuthInterceptor>(),
    sl<ErrorInterceptor>(),
    sl<RetryInterceptor>(),
    if (kDebugMode) sl<LoggerInterceptor>(),
  ]);
}

void _initFeatures() {
  // Register your feature-specific dependencies here
  // Example:
  // sl.registerFactory<HomeBloc>(() => HomeBloc(sl()));

  // User Feature
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl<DatabaseHelper>()),
  );

  // Register Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
      localDataSource: sl<UserLocalDataSource>(),
      connectivity: sl<Connectivity>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  // Services
  sl.registerLazySingleton<ProfileService>(() => ProfileService());
} 