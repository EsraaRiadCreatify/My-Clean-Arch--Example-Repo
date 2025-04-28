import 'models/user_model.dart';
import 'models/product_model.dart';

abstract class StorageService {
  // Token Operations
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> removeToken();

  // User Operations
  Future<void> saveUser(UserModel user);
  UserModel? getUser();
  Future<void> removeUser();

  // Favorites Operations
  Future<void> saveFavoriteProducts(List<ProductModel> products);
  List<ProductModel> getFavoriteProducts();
  Future<void> addToFavorites(ProductModel product);
  Future<void> removeFromFavorites(String productId);

  // Advanced Operations
  Future<void> updateUserPreferences(Map<String, dynamic> preferences);
  Future<void> clearAllData();
  Future<void> saveUserSession(UserModel user, String token);
} 