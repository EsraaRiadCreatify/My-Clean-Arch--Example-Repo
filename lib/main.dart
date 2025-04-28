import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';
import 'core/config/app_config.dart';
import 'core/storage/storage_service.dart';
import 'core/storage/hive_storage_service.dart';
import 'core/storage/get_storage_service.dart';
import 'core/api/network/api_client.dart';
import 'core/api/config/api_config.dart';

void main() async {
  // Ensure Flutter is initialized (تأكد من تهيئة Flutter)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging if enabled (تهيئة التسجيل إذا كان مفعلاً)
  if (AppConfig.enableLogging) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  // Load configuration (تحميل التكوين)
  await AppConfigLoader.loadConfig();
  await AppConfig.loadFromLocalStorage();

  // Initialize services based on config (تهيئة الخدمات بناءً على التكوين)
  await _initializeServices();

  // Set system UI overlay style (تعيين نمط واجهة النظام)
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppConfig.themeMode == ThemeMode.dark 
          ? Brightness.light 
          : Brightness.dark,
    ),
  );

  // Initialize storage service based on config (تهيئة خدمة التخزين بناءً على التكوين)
  final storageService = _initializeStorageService();

  // Initialize API client (تهيئة عميل API)
  final apiClient = _initializeApiClient();

  runApp(MyApp(
    storageService: storageService,
    apiClient: apiClient,
  ));
}

/// Initialize services based on configuration (تهيئة الخدمات بناءً على التكوين)
Future<void> _initializeServices() async {
  // Initialize Firebase Analytics if enabled (تهيئة تحليلات Firebase إذا كانت مفعلة)
  if (AppConfig.enableAnalytics) {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  // Initialize Firebase Messaging if enabled (تهيئة رسائل Firebase إذا كانت مفعلة)
  if (AppConfig.enablePushNotifications) {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Check connectivity if offline mode is enabled (التحقق من الاتصال إذا كان وضع عدم الاتصال مفعلاً)
  if (AppConfig.enableOfflineMode) {
    final connectivity = Connectivity();
    await connectivity.checkConnectivity();
  }
}

/// Background message handler for Firebase (معالج الرسائل الخلفية لـ Firebase)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

/// Initialize the appropriate storage service (تهيئة خدمة التخزين المناسبة)
StorageService _initializeStorageService() {
  switch (AppConfig.storageType) {
    case StorageType.hive:
      return HiveStorageService(
        encryptionKey: 'your-encryption-key',
        boxName: 'app_data',
      );
    case StorageType.sharedPreferences:
      return GetStorageService(); // Fallback to GetStorage if SharedPreferences is not available
    case StorageType.getStorage:
      return GetStorageService();
  }
}

/// Initialize API client (تهيئة عميل API)
ApiClient _initializeApiClient() {
  return ApiClient(
    config: ApiConfig(
      baseUrl: AppConfig.apiBaseUrl,
      timeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      enableLogging: AppConfig.enableLogging,
      enableRetry: true,
      maxRetries: 3,
      retryDelay: const Duration(seconds: 1),
      handleErrors: true,
      returnErrorResponse: false,
      validateResponse: true,
      useCache: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final ApiClient apiClient;

  const MyApp({
    super.key,
    required this.storageService,
    required this.apiClient,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: AppConfig.showDebugBanner,
      
      // Localization (الترجمة)
      localizationsDelegates: AppConfig.enableLocalization
          ? const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ]
          : null,
      supportedLocales: AppConfig.enableLocalization
          ? const [
              Locale('en'),
              Locale('ar'),
            ]
          : const [Locale('en')],
      locale: Locale(AppConfig.defaultLanguage),
      
      // Theme (المظهر)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConfig.primaryColor,
          brightness: Brightness.light,
        ),
        fontFamily: AppConfig.fontFamily,
        // Apply animation speed multiplier (تطبيق مضاعف سرعة الحركة)
        pageTransitionsTheme:const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConfig.primaryColor,
          brightness: Brightness.dark,
        ),
        fontFamily: AppConfig.fontFamily,
        // Apply animation speed multiplier (تطبيق مضاعف سرعة الحركة)
        pageTransitionsTheme:const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: AppConfig.themeMode,
      
      // Maintenance Mode Check (التحقق من وضع الصيانة)
      builder: (context, child) {
        if (AppConfig.maintenanceMode) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('App is under maintenance'),
              ),
            ),
          );
        }
        return child!;
      },
      
      // Add your app routes and other configurations here
      // أضف مسارات تطبيقك والتكوينات الأخرى هنا
    );
  }
} 