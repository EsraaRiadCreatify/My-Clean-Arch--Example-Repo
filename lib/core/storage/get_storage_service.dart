import 'package:get_storage/get_storage.dart';
import 'models/user_model.dart';
import 'models/product_model.dart';
import 'dart:async';

class GetStorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _favoritesKey = 'favorite_products';

  final GetStorage _storage;
  final _userController = StreamController<UserModel?>.broadcast();
  final _favoritesController = StreamController<List<ProductModel>>.broadcast();

  GetStorageService(this._storage) {
    // Listen to changes
    _storage.listenKey(_userKey, (value) {
      _userController.add(getUser());
    });

    _storage.listenKey(_favoritesKey, (value) {
      _favoritesController.add(getFavoriteProducts());
    });
  }

  // Token Operations
  void saveToken(String token) {
    _storage.write(_tokenKey, token);
  }

  String? getToken() {
    return _storage.read<String>(_tokenKey);
  }

  void removeToken() {
    _storage.remove(_tokenKey);
  }

  // User Operations
  void saveUser(UserModel user) {
    _storage.write(_userKey, user.toJson());
  }

  UserModel? getUser() {
    final userJson = _storage.read<Map<String, dynamic>>(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(userJson);
  }

  void removeUser() {
    _storage.remove(_userKey);
  }

  // Favorites Operations
  void saveFavoriteProducts(List<ProductModel> products) {
    final productsJson = products.map((p) => p.toJson()).toList();
    _storage.write(_favoritesKey, productsJson);
  }

  List<ProductModel> getFavoriteProducts() {
    final productsJson = _storage.read<List<dynamic>>(_favoritesKey);
    if (productsJson == null) return [];
    
    return productsJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void addToFavorites(ProductModel product) {
    final favorites = getFavoriteProducts();
    if (!favorites.any((p) => p.id == product.id)) {
      favorites.add(product);
      saveFavoriteProducts(favorites);
    }
  }

  void removeFromFavorites(String productId) {
    final favorites = getFavoriteProducts();
    favorites.removeWhere((p) => p.id == productId);
    saveFavoriteProducts(favorites);
  }

  // Advanced Operations
  void updateUserPreferences(Map<String, dynamic> preferences) {
    final user = getUser();
    if (user != null) {
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        token: user.token,
        preferences: preferences,
      );
      saveUser(updatedUser);
    }
  }

  void clearAllData() {
    _storage.erase();
  }

  // Stream getters
  Stream<UserModel?> get userStream => _userController.stream;
  Stream<List<ProductModel>> get favoritesStream => _favoritesController.stream;

  // Example of batch operations
  void saveUserSession(UserModel user, String token) {
    saveUser(user);
    saveToken(token);
  }

  // Cleanup
  void dispose() {
    _userController.close();
    _favoritesController.close();
  }
} 