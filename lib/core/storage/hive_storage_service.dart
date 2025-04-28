import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart';
import 'models/product_model.dart';

class HiveStorageService {
  static const String _userBox = 'userBox';
  static const String _tokenBox = 'tokenBox';
  static const String _favoritesBox = 'favoritesBox';

  late Box<String> _tokenBoxInstance;
  late Box<UserModel> _userBoxInstance;
  late Box<List<ProductModel>> _favoritesBoxInstance;

  Future<void> init() async {
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
  Future<void> saveToken(String token) async {
    await _tokenBoxInstance.put('token', token);
  }

  String? getToken() {
    return _tokenBoxInstance.get('token');
  }

  Future<void> removeToken() async {
    await _tokenBoxInstance.delete('token');
  }

  // User Operations
  Future<void> saveUser(UserModel user) async {
    await _userBoxInstance.put('user', user);
  }

  UserModel? getUser() {
    return _userBoxInstance.get('user');
  }

  Future<void> removeUser() async {
    await _userBoxInstance.delete('user');
  }

  // Favorites Operations
  Future<void> saveFavoriteProducts(List<ProductModel> products) async {
    await _favoritesBoxInstance.put('favorites', products);
  }

  List<ProductModel> getFavoriteProducts() {
    return _favoritesBoxInstance.get('favorites') ?? [];
  }

  Future<void> addToFavorites(ProductModel product) async {
    final favorites = getFavoriteProducts();
    if (!favorites.any((p) => p.id == product.id)) {
      favorites.add(product);
      await saveFavoriteProducts(favorites);
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    final favorites = getFavoriteProducts();
    favorites.removeWhere((p) => p.id == productId);
    await saveFavoriteProducts(favorites);
  }

  // Advanced Operations
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
  Future<void> saveUserSession(UserModel user, String token) async {
    await Future.wait([
      saveUser(user),
      saveToken(token),
    ]);
  }

  // Example of encryption
  Future<void> encryptBox(String boxName, String encryptionKey) async {
    final encryptedBox = await Hive.openBox(
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