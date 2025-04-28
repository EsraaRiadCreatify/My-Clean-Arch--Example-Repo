import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart';
import 'models/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';

/// Hive Storage Service Implementation (تنفيذ خدمة تخزين Hive)
/// 
/// This service provides type-safe storage using Hive database.
/// It supports encryption and complex data structures.
/// 
/// المميزات:
/// - تخزين آمن للنوع
/// - دعم التشفير
/// - تخزين هياكل البيانات المعقدة
/// - أداء عالي
class HiveStorageService implements StorageService {
  /// Encryption key for secure storage (مفتاح التشفير للتخزين الآمن)
  final String _encryptionKey;
  
  /// Box name for user data (اسم الصندوق لبيانات المستخدم)
  final String _boxName;
  
  /// Constructor with required parameters (المنشئ مع المعاملات المطلوبة)
  /// 
  /// [encryptionKey] - Key used for data encryption (المفتاح المستخدم في تشفير البيانات)
  /// [boxName] - Name of the Hive box (اسم صندوق Hive)
  HiveStorageService({
    required String encryptionKey,
    required String boxName,
  })  : _encryptionKey = encryptionKey,
        _boxName = boxName;

  /// Initialize Hive storage (تهيئة تخزين Hive)
  /// 
  /// This method:
  /// 1. Initializes Hive with the application's document directory
  /// 2. Opens a box with encryption
  /// 
  /// هذه الطريقة:
  /// 1. تهيئ Hive مع مجلد مستندات التطبيق
  /// 2. تفتح صندوق مع التشفير
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Open box with encryption (فتح الصندوق مع التشفير)
    await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(_encryptionKey.codeUnits),
    );
  }

  /// Store data with type safety (تخزين البيانات مع الأمان النوعي)
  /// 
  /// [key] - Unique identifier for the data (معرف فريد للبيانات)
  /// [value] - Data to be stored (البيانات المراد تخزينها)
  /// 
  /// Returns Future<void> when operation completes (يعيد Future<void> عند اكتمال العملية)
  Future<void> write(String key, dynamic value) async {
    final box = await Hive.openBox(_boxName);
    await box.put(key, value);
  }

  /// Retrieve data with type safety (استرجاع البيانات مع الأمان النوعي)
  /// 
  /// [key] - Unique identifier for the data (معرف فريد للبيانات)
  /// 
  /// Returns the stored data or null if not found (يعيد البيانات المخزنة أو null إذا لم توجد)
  Future<dynamic> read(String key) async {
    final box = await Hive.openBox(_boxName);
    return box.get(key);
  }

  /// Delete data by key (حذف البيانات باستخدام المفتاح)
  /// 
  /// [key] - Unique identifier for the data to delete (معرف فريد للبيانات المراد حذفها)
  /// 
  /// Returns Future<void> when operation completes (يعيد Future<void> عند اكتمال العملية)
  Future<void> delete(String key) async {
    final box = await Hive.openBox(_boxName);
    await box.delete(key);
  }

  /// Clear all data in the box (مسح جميع البيانات في الصندوق)
  /// 
  /// Returns Future<void> when operation completes (يعيد Future<void> عند اكتمال العملية)
  Future<void> clear() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
  }

  /// Check if data exists for a key (التحقق من وجود بيانات لمفتاح معين)
  /// 
  /// [key] - Unique identifier to check (معرف فريد للتحقق)
  /// 
  /// Returns true if data exists, false otherwise (يعيد true إذا وجدت البيانات، false إذا لم توجد)
  Future<bool> containsKey(String key) async {
    final box = await Hive.openBox(_boxName);
    return box.containsKey(key);
  }

  /// Get all keys in the box (الحصول على جميع المفاتيح في الصندوق)
  /// 
  /// Returns a list of all keys (يعيد قائمة بجميع المفاتيح)
  Future<List<String>> getKeys() async {
    final box = await Hive.openBox(_boxName);
    return box.keys.cast<String>().toList();
  }

  /// Get all values in the box (الحصول على جميع القيم في الصندوق)
  /// 
  /// Returns a list of all values (يعيد قائمة بجميع القيم)
  Future<List<dynamic>> getValues() async {
    final box = await Hive.openBox(_boxName);
    return box.values.toList();
  }

  /// Close the Hive box (إغلاق صندوق Hive)
  /// 
  /// This should be called when the storage is no longer needed
  /// 
  /// يجب استدعاء هذه الطريقة عندما لا تكون هناك حاجة للتخزين
  Future<void> close() async {
    final box = await Hive.openBox(_boxName);
    await box.close();
  }

  static const String _userBox = 'userBox';
  static const String _tokenBox = 'tokenBox';
  static const String _favoritesBox = 'favoritesBox';

  late Box<String> _tokenBoxInstance;
  late Box<UserModel> _userBoxInstance;
  late Box<List<ProductModel>> _favoritesBoxInstance;

  Future<void> initHive() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    
    // Open boxes
    _tokenBoxInstance = await Hive.openBox<String>(_tokenBox);
    _userBoxInstance = await Hive.openBox<UserModel>(_userBox);
    _favoritesBoxInstance = await Hive.openBox<List<ProductModel>>(_favoritesBox);
  }

  // Token Operations
  @override
  Future<void> saveToken(String token) async {
    await _tokenBoxInstance.put('token', token);
  }

  @override
  String? getToken() {
    return _tokenBoxInstance.get('token');
  }

  @override
  Future<void> removeToken() async {
    await _tokenBoxInstance.delete('token');
  }

  // User Operations
  @override
  Future<void> saveUser(UserModel user) async {
    await _userBoxInstance.put('user', user);
  }

  @override
  UserModel? getUser() {
    return _userBoxInstance.get('user');
  }

  @override
  Future<void> removeUser() async {
    await _userBoxInstance.delete('user');
  }

  // Favorites Operations
  @override
  Future<void> saveFavoriteProducts(List<ProductModel> products) async {
    await _favoritesBoxInstance.put('favorites', products);
  }

  @override
  List<ProductModel> getFavoriteProducts() {
    return _favoritesBoxInstance.get('favorites') ?? [];
  }

  @override
  Future<void> addToFavorites(ProductModel product) async {
    final favorites = getFavoriteProducts();
    if (!favorites.any((p) => p.id == product.id)) {
      favorites.add(product);
      await saveFavoriteProducts(favorites);
    }
  }

  @override
  Future<void> removeFromFavorites(String productId) async {
    final favorites = getFavoriteProducts();
    favorites.removeWhere((p) => p.id == productId);
    await saveFavoriteProducts(favorites);
  }

  // Advanced Operations
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

  @override
  Future<void> clearAllData() async {
    await Future.wait([
      _tokenBoxInstance.clear(),
      _userBoxInstance.clear(),
      _favoritesBoxInstance.clear(),
    ]);
  }

  // Example of reactive storage
  Stream<UserModel?> watchUser() {
    return _userBoxInstance.watch(key: 'user').map((event) => event.value);
  }

  Stream<List<ProductModel>> watchFavorites() {
    return _favoritesBoxInstance.watch(key: 'favorites').map((event) => event.value ?? []);
  }

  // Example of batch operations
  @override
  Future<void> saveUserSession(UserModel user, String token) async {
    await Future.wait([
      saveUser(user),
      saveToken(token),
    ]);
  }

  // Example of encryption
  Future<void> encryptBox(String boxName, String encryptionKey) async {
    await Hive.openBox(
      boxName,
      encryptionCipher: HiveAesCipher(encryptionKey.codeUnits),
    );
  }
}

// Hive Adapters
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      id: reader.readString(),
      name: reader.readString(),
      email: reader.readString(),
      token: reader.readString(),
      preferences: Map<String, dynamic>.from(reader.readMap()),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.token ?? '');
    writer.writeMap(obj.preferences ?? {});
  }
}

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel(
      id: reader.readString(),
      name: reader.readString(),
      price: reader.readDouble(),
      description: reader.readString(),
      images: reader.readList().cast<String>(),
      isFavorite: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.price);
    writer.writeString(obj.description);
    writer.writeList(obj.images);
    writer.writeBool(obj.isFavorite);
  }
} 