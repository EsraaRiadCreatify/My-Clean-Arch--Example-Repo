import 'package:get_storage/get_storage.dart';
import 'models/user_model.dart';
import 'models/product_model.dart';
import 'dart:async';
import 'storage_service.dart';

/// Get Storage Service Implementation (تنفيذ خدمة تخزين Get Storage)
/// 
/// This service provides a simple and fast key-value storage solution.
/// It's perfect for small to medium-sized data storage needs.
/// Includes additional functionality for user and favorites management.
/// 
/// المميزات:
/// - تخزين بسيط وسريع
/// - مناسب للبيانات الصغيرة والمتوسطة
/// - لا يحتاج إلى تهيئة مسبقة
/// - أداء عالي
/// - إدارة المستخدمين والمفضلات
class GetStorageService implements StorageService {
  /// GetStorage instance (نسخة GetStorage)
  final GetStorage _storage;

  /// Stream controllers for reactive data (متحكمات الدفق للبيانات التفاعلية)
  final _userController = StreamController<UserModel?>.broadcast();
  final _favoritesController = StreamController<List<ProductModel>>.broadcast();

  /// Storage keys (مفاتيح التخزين)
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _favoritesKey = 'favorite_products';

  /// Constructor with optional box name (المنشئ مع اسم الصندوق الاختياري)
  /// 
  /// [boxName] - Optional name for the storage box (اسم اختياري لصندوق التخزين)
  GetStorageService({String boxName = 'default'}) : _storage = GetStorage(boxName) {
    // Listen to changes in user data (الاستماع إلى تغييرات بيانات المستخدم)
    _storage.listenKey(_userKey, (value) {
      _userController.add(value != null ? UserModel.fromJson(value) : null);
    });

    // Listen to changes in favorites (الاستماع إلى تغييرات المفضلات)
    _storage.listenKey(_favoritesKey, (value) {
      if (value is List) {
        _favoritesController.add(
          value.map((item) => ProductModel.fromJson(item)).toList(),
        );
      }
    });
  }

  /// Initialize Get Storage (تهيئة Get Storage)
  /// 
  /// This method initializes the storage service.
  /// Note: GetStorage doesn't require explicit initialization.
  /// 
  /// هذه الطريقة تهيئ خدمة التخزين.
  /// ملاحظة: GetStorage لا يحتاج إلى تهيئة صريحة.
  Future<void> init() async {
    // GetStorage is automatically initialized
    // يتم تهيئة GetStorage تلقائياً
  }

  /// Store data (تخزين البيانات)
  /// 
  /// [key] - Unique identifier for the data (معرف فريد للبيانات)
  /// [value] - Data to be stored (البيانات المراد تخزينها)
  /// 
  /// Returns Future<void> when operation completes (يعيد Future<void> عند اكتمال العملية)
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Retrieve data (استرجاع البيانات)
  /// 
  /// [key] - Unique identifier for the data (معرف فريد للبيانات)
  /// 
  /// Returns the stored data or null if not found (يعيد البيانات المخزنة أو null إذا لم توجد)
  Future<dynamic> read(String key) async {
    return _storage.read(key);
  }

  /// Delete data by key (حذف البيانات باستخدام المفتاح)
  /// 
  /// [key] - Unique identifier for the data to delete (معرف فريد للبيانات المراد حذفها)
  /// 
  /// Returns Future<void> when operation completes (يعيد Future<void> عند اكتمال العملية)
  Future<void> delete(String key) async {
    await _storage.remove(key);
  }

  /// Clear all data (مسح جميع البيانات)
  /// 
  /// Returns Future<void> when operation completes (يعيد Future<void> عند اكتمال العملية)
  Future<void> clear() async {
    await _storage.erase();
  }

  /// Check if data exists for a key (التحقق من وجود بيانات لمفتاح معين)
  /// 
  /// [key] - Unique identifier to check (معرف فريد للتحقق)
  /// 
  /// Returns true if data exists, false otherwise (يعيد true إذا وجدت البيانات، false إذا لم توجد)
  Future<bool> containsKey(String key) async {
    return _storage.hasData(key);
  }

  /// Get all keys (الحصول على جميع المفاتيح)
  /// 
  /// Returns a list of all keys (يعيد قائمة بجميع المفاتيح)
  Future<List<String>> getKeys() async {
    return _storage.getKeys().cast<String>();
  }

  /// Get all values (الحصول على جميع القيم)
  /// 
  /// Returns a list of all values (يعيد قائمة بجميع القيم)
  Future<List<dynamic>> getValues() async {
    return _storage.getValues();
  }

  /// Close the storage (إغلاق التخزين)
  /// 
  /// Note: GetStorage doesn't require explicit closing
  /// 
  /// ملاحظة: GetStorage لا يحتاج إلى إغلاق صريح
  Future<void> close() async {
    await _userController.close();
    await _favoritesController.close();
  }

  /// User Management Methods (طرق إدارة المستخدم)

  /// Get current user (الحصول على المستخدم الحالي)
  /// 
  /// Returns the current user or null if not logged in (يعيد المستخدم الحالي أو null إذا لم يكن مسجل الدخول)
  @override
  UserModel? getUser() {
    final userData = _storage.read(_userKey);
    return userData != null ? UserModel.fromJson(userData) : null;
  }

  /// Set current user (تعيين المستخدم الحالي)
  /// 
  /// [user] - User to set as current (المستخدم المراد تعيينه كحالي)
  @override
  Future<void> saveUser(UserModel user) async {
    await write(_userKey, user.toJson());
  }

  /// Remove current user (إزالة المستخدم الحالي)
  @override
  Future<void> removeUser() async {
    await delete(_userKey);
  }

  /// Get auth token (الحصول على رمز المصادقة)
  /// 
  /// Returns the stored auth token or null if not found (يعيد رمز المصادقة المخزن أو null إذا لم يوجد)
  @override
  String? getToken() {
    return _storage.read(_tokenKey);
  }

  /// Set auth token (تعيين رمز المصادقة)
  /// 
  /// [token] - Token to store (الرمز المراد تخزينه)
  @override
  Future<void> saveToken(String token) async {
    await write(_tokenKey, token);
  }

  /// Remove auth token (إزالة رمز المصادقة)
  @override
  Future<void> removeToken() async {
    await delete(_tokenKey);
  }

  /// Favorites Management Methods (طرق إدارة المفضلات)

  /// Get favorite products (الحصول على المنتجات المفضلة)
  /// 
  /// Returns a list of favorite products (يعيد قائمة بالمنتجات المفضلة)
  @override
  List<ProductModel> getFavoriteProducts() {
    final favorites = _storage.read(_favoritesKey) ?? [];
    return (favorites as List).map((item) => ProductModel.fromJson(item)).toList();
  }

  /// Save favorite products (حفظ المنتجات المفضلة)
  /// 
  /// [products] - List of products to save (قائمة المنتجات المراد حفظها)
  @override
  Future<void> saveFavoriteProducts(List<ProductModel> products) async {
    await write(_favoritesKey, products.map((p) => p.toJson()).toList());
  }

  /// Add product to favorites (إضافة منتج إلى المفضلات)
  /// 
  /// [product] - Product to add (المنتج المراد إضافته)
  @override
  Future<void> addToFavorites(ProductModel product) async {
    final favorites = getFavoriteProducts();
    if (!favorites.any((p) => p.id == product.id)) {
      favorites.add(product);
      await saveFavoriteProducts(favorites);
    }
  }

  /// Remove product from favorites (إزالة منتج من المفضلات)
  /// 
  /// [productId] - ID of product to remove (معرف المنتج المراد إزالته)
  @override
  Future<void> removeFromFavorites(String productId) async {
    final favorites = getFavoriteProducts();
    favorites.removeWhere((p) => p.id == productId);
    await saveFavoriteProducts(favorites);
  }

  /// Clear all data (مسح جميع البيانات)
  @override
  Future<void> clearAllData() async {
    await clear();
  }

  /// Save user session (حفظ جلسة المستخدم)
  /// 
  /// [user] - User to save (المستخدم المراد حفظه)
  /// [token] - Token to save (الرمز المراد حفظه)
  @override
  Future<void> saveUserSession(UserModel user, String token) async {
    await Future.wait([
      saveUser(user),
      saveToken(token),
    ]);
  }

  /// Update user preferences (تحديث تفضيلات المستخدم)
  /// 
  /// [preferences] - New preferences to set (التفضيلات الجديدة المراد تعيينها)
  @override
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    final user = getUser();
    if (user != null) {
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        token: user.token,
        preferences: preferences,
      );
      await saveUser(updatedUser);
    }
  }

  /// Streams (التدفقات)

  /// User stream (تدفق المستخدم)
  /// 
  /// Returns a stream of user changes (يعيد تدفقاً لتغييرات المستخدم)
  Stream<UserModel?> get userStream => _userController.stream;

  /// Favorites stream (تدفق المفضلات)
  /// 
  /// Returns a stream of favorites changes (يعيد تدفقاً لتغييرات المفضلات)
  Stream<List<ProductModel>> get favoritesStream => _favoritesController.stream;
} 