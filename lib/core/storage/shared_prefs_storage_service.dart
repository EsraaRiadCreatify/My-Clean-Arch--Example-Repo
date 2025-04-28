import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'models/product_model.dart';
import 'dart:convert';

class SharedPrefsStorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _favoritesKey = 'favorite_products';

  final SharedPreferences _prefs;

  SharedPrefsStorageService(this._prefs);

  // Token Operations
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  // User Operations
  Future<void> saveUser(UserModel user) async {
    final userJson = user.toJson();
    await _prefs.setString(_userKey, jsonEncode(userJson));
  }

  UserModel? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }

  // Favorites Operations
  Future<void> saveFavoriteProducts(List<ProductModel> products) async {
    final productsJson = products.map((p) => p.toJson()).toList();
    await _prefs.setString(_favoritesKey, jsonEncode(productsJson));
  }

  List<ProductModel> getFavoriteProducts() {
    final productsJson = _prefs.getString(_favoritesKey);
    if (productsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(productsJson);
    return decoded.map((json) => ProductModel.fromJson(json)).toList();
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
    await _prefs.clear();
  }

  // Example of batch operations
  Future<void> saveUserSession(UserModel user, String token) async {
    await Future.wait([
      saveUser(user),
      saveToken(token),
    ]);
  }
} 