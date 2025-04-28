import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCache {
  static const String _cachePrefix = 'api_cache_';
  static const Duration _defaultCacheDuration = Duration(hours: 1);
  
  final SharedPreferences _prefs;
  
  ApiCache(this._prefs);
  
  Future<void> cacheResponse({
    required String key,
    required dynamic data,
    Duration? cacheDuration,
  }) async {
    final cacheKey = '$_cachePrefix$key';
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'duration': (cacheDuration ?? _defaultCacheDuration).inMilliseconds,
    };
    
    await _prefs.setString(cacheKey, jsonEncode(cacheData));
  }
  
  Future<T?> getCachedResponse<T>({
    required String key,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final cacheKey = '$_cachePrefix$key';
    final cachedData = _prefs.getString(cacheKey);
    
    if (cachedData == null) return null;
    
    final decodedData = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = decodedData['timestamp'] as int;
    final duration = decodedData['duration'] as int;
    
    if (DateTime.now().millisecondsSinceEpoch - timestamp > duration) {
      await _prefs.remove(cacheKey);
      return null;
    }
    
    final data = decodedData['data'];
    if (fromJson != null && data is Map<String, dynamic>) {
      return fromJson(data);
    }
    
    return data as T?;
  }
  
  Future<void> clearCache({String? key}) async {
    if (key != null) {
      await _prefs.remove('$_cachePrefix$key');
    } else {
      final keys = _prefs.getKeys().where((k) => k.startsWith(_cachePrefix));
      for (final key in keys) {
        await _prefs.remove(key);
      }
    }
  }
} 