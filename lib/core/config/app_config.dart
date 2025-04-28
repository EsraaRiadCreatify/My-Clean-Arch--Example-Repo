import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/network/api_client.dart';
import '../api/config/api_config.dart';

/// App Configuration Class (فئة تكوين التطبيق)
/// 
/// This class manages all app settings, including:
/// - Feature flags
/// - Theme settings
/// - Storage configuration
/// - API configuration
/// 
/// هذه الفئة تدير جميع إعدادات التطبيق، بما في ذلك:
/// - أعلام الميزات
/// - إعدادات المظهر
/// - تكوين التخزين
/// - تكوين API
class AppConfig {
  // Feature Flags (أعلام الميزات)
  static bool enableLocalization = true;
  static bool enableDarkMode = true;
  static bool enableAds = false;
  static bool enableAnalytics = true;
  static bool enableOfflineMode = true;
  static bool enablePushNotifications = true;
  static bool enableBetaFeatures = false;
  static bool maintenanceMode = false;
  static bool enableLogging = true;
  static bool forceUpdateRequired = false;
  static bool showDebugBanner = false;
  static bool isTestMode = false;

  // Theme Settings (إعدادات المظهر)
  static Color primaryColor = const Color(0xFF4A90E2);
  static String fontFamily = 'Cairo';
  static ThemeMode themeMode = ThemeMode.system;
  static double animationSpeedMultiplier = 1.0;

  // API Settings (إعدادات API)
  static String apiBaseUrl = 'https://api.example.com';
  static String defaultLanguage = 'en';

  // Storage Configuration (تكوين التخزين)
  static StorageType storageType = StorageType.hive;
  static bool useLocalDatabase = true;

  // Storage Types (أنواع التخزين)
  static const String _storageTypeKey = 'storage_type';
  static const String _useLocalDatabaseKey = 'use_local_database';

  /// Save configuration to local storage (حفظ التكوين في التخزين المحلي)
  static Future<void> saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageTypeKey, storageType.toString());
    await prefs.setBool(_useLocalDatabaseKey, useLocalDatabase);
  }

  /// Load configuration from local storage (تحميل التكوين من التخزين المحلي)
  static Future<void> loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storageTypeStr = prefs.getString(_storageTypeKey);
    if (storageTypeStr != null) {
      storageType = StorageType.values.firstWhere(
        (e) => e.toString() == storageTypeStr,
        orElse: () => StorageType.hive,
      );
    }
    useLocalDatabase = prefs.getBool(_useLocalDatabaseKey) ?? true;
  }
}

/// Storage Type Enum (تعداد نوع التخزين)
/// 
/// Defines available storage options:
/// - hive: Fast, encrypted local storage
/// - shared_preferences: Simple key-value storage
/// - get_storage: Lightweight storage solution
/// 
/// يحدد خيارات التخزين المتاحة:
/// - hive: تخزين محلي سريع ومشفر
/// - shared_preferences: تخزين بسيط من نوع مفتاح-قيمة
/// - get_storage: حل تخزين خفيف الوزن
enum StorageType {
  hive,
  sharedPreferences,
  getStorage,
}

/// App Config Loader (محمل تكوين التطبيق)
/// 
/// Handles loading configuration from remote sources
/// and managing fallback to local defaults
/// 
/// يتعامل مع تحميل التكوين من المصادر البعيدة
/// وإدارة العودة إلى الإعدادات المحلية الافتراضية
class AppConfigLoader {
  static const String _configUrl = 'https://example.com/config.json';
  static const String _configCacheKey = 'cached_config';

  /// Load configuration from remote source (تحميل التكوين من مصدر بعيد)
  /// 
  /// Tries to fetch config from remote URL first
  /// Falls back to cached config if available
  /// Finally falls back to default local config
  /// 
  /// يحاول جلب التكوين من URL البعيد أولاً
  /// يعود إلى التكوين المخزن مؤقتاً إذا كان متاحاً
  /// أخيراً يعود إلى التكوين المحلي الافتراضي
  static Future<void> loadConfig() async {
    try {
      // Initialize API client (تهيئة عميل API)
      final apiClient = ApiClient(
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

      // Try to fetch remote config (محاولة جلب التكوين البعيد)
      final response = await apiClient.get(_configUrl);
      if (response.statusCode == 200) {
        final config = json.decode(response.data);
        _updateConfig(config);
        await _cacheConfig(config);
      } else {
        await _loadCachedConfig();
      }
    } catch (e) {
      await _loadCachedConfig();
    }
  }

  /// Update app config with new values (تحديث تكوين التطبيق بقيم جديدة)
  static void _updateConfig(Map<String, dynamic> config) {
    // Feature Flags (أعلام الميزات)
    AppConfig.enableLocalization = config['enableLocalization'] ?? AppConfig.enableLocalization;
    AppConfig.enableDarkMode = config['enableDarkMode'] ?? AppConfig.enableDarkMode;
    AppConfig.enableAds = config['enableAds'] ?? AppConfig.enableAds;
    AppConfig.enableAnalytics = config['enableAnalytics'] ?? AppConfig.enableAnalytics;
    AppConfig.enableOfflineMode = config['enableOfflineMode'] ?? AppConfig.enableOfflineMode;
    AppConfig.enablePushNotifications = config['enablePushNotifications'] ?? AppConfig.enablePushNotifications;
    AppConfig.enableBetaFeatures = config['enableBetaFeatures'] ?? AppConfig.enableBetaFeatures;
    AppConfig.maintenanceMode = config['maintenanceMode'] ?? AppConfig.maintenanceMode;
    AppConfig.enableLogging = config['enableLogging'] ?? AppConfig.enableLogging;
    AppConfig.forceUpdateRequired = config['forceUpdateRequired'] ?? AppConfig.forceUpdateRequired;
    AppConfig.showDebugBanner = config['showDebugBanner'] ?? AppConfig.showDebugBanner;
    AppConfig.isTestMode = config['isTestMode'] ?? AppConfig.isTestMode;

    // Theme Settings (إعدادات المظهر)
    if (config['primaryColor'] != null) {
      AppConfig.primaryColor = Color(int.parse(config['primaryColor'].replaceAll('#', '0xFF')));
    }
    AppConfig.fontFamily = config['fontFamily'] ?? AppConfig.fontFamily;
    AppConfig.themeMode = _parseThemeMode(config['themeMode']);
    AppConfig.animationSpeedMultiplier = config['animationSpeedMultiplier'] ?? AppConfig.animationSpeedMultiplier;

    // API Settings (إعدادات API)
    AppConfig.apiBaseUrl = config['apiBaseUrl'] ?? AppConfig.apiBaseUrl;
    AppConfig.defaultLanguage = config['defaultLanguage'] ?? AppConfig.defaultLanguage;

    // Storage Configuration (تكوين التخزين)
    if (config['storageType'] != null) {
      AppConfig.storageType = StorageType.values.firstWhere(
        (e) => e.toString() == config['storageType'],
        orElse: () => StorageType.hive,
      );
    }
    AppConfig.useLocalDatabase = config['useLocalDatabase'] ?? AppConfig.useLocalDatabase;
  }

  /// Cache configuration locally (تخزين التكوين محلياً)
  static Future<void> _cacheConfig(Map<String, dynamic> config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_configCacheKey, json.encode(config));
  }

  /// Load cached configuration (تحميل التكوين المخزن)
  static Future<void> _loadCachedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedConfig = prefs.getString(_configCacheKey);
    if (cachedConfig != null) {
      final config = json.decode(cachedConfig);
      _updateConfig(config);
    }
  }

  /// Parse theme mode from string (تحليل نمط المظهر من النص)
  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode?.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
} 