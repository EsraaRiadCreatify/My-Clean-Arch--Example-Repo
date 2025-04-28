import '../../domain/entities/user_entity.dart';
import '../../../../core/api/network/api_client.dart';
import '../../../../core/shared_widgets/loading/loading_controller.dart';

/// Remote data source for user-related operations
/// (مصدر البيانات البعيد للعمليات المتعلقة بالمستخدم)
class UserRemoteDataSource {
  final ApiClient _apiClient;
  final _loadingController = LoadingController();

  UserRemoteDataSource(this._apiClient);

  /// Get user by ID
  /// (الحصول على مستخدم بواسطة المعرف)
  Future<UserEntity> getUser(String id) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب بيانات المستخدم...",
      );
      
      // Using the new ApiClient with response validation and error handling
      // (استخدام ApiClient الجديد مع التحقق من الاستجابة ومعالجة الأخطاء)
      final response = await _apiClient.get(
        '/users/$id',
        showLoading: false,
        isGlobalLoader: true,
      );
      return UserEntity.fromJson(response);
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Get all users
  /// (الحصول على جميع المستخدمين)
  Future<List<UserEntity>> getUsers() async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب قائمة المستخدمين...",
      );
      
      final response = await _apiClient.get(
        '/users',
        showLoading: false,
        isGlobalLoader: true,
      );
      return (response as List).map((json) => UserEntity.fromJson(json)).toList();
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Create a new user
  /// (إنشاء مستخدم جديد)
  Future<UserEntity> createUser(UserEntity user) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري إنشاء مستخدم جديد...",
      );
      
      final response = await _apiClient.post(
        '/users',
        data: user.toJson(),
        showLoading: false,
        isGlobalLoader: true,
      );
      return UserEntity.fromJson(response);
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Update user by ID
  /// (تحديث مستخدم بواسطة المعرف)
  Future<UserEntity> updateUser(String id, UserEntity user) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري تحديث بيانات المستخدم...",
      );
      
      final response = await _apiClient.put(
        '/users/$id',
        data: user.toJson(),
        showLoading: false,
        isGlobalLoader: true,
      );
      return UserEntity.fromJson(response);
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Delete user by ID
  /// (حذف مستخدم بواسطة المعرف)
  Future<void> deleteUser(String id) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري حذف المستخدم...",
      );
      
      await _apiClient.delete(
        '/users/$id',
        showLoading: false,
        isGlobalLoader: true,
      );
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Change user password
  /// (تغيير كلمة مرور المستخدم)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري تغيير كلمة المرور...",
      );
      
      await _apiClient.post(
        '/users/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        showLoading: false,
        isGlobalLoader: true,
      );
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Login user with email and password
  /// (تسجيل دخول المستخدم باستخدام البريد الإلكتروني وكلمة المرور)
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري تسجيل الدخول...",
      );
      
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        showLoading: false,
        isGlobalLoader: true,
      );
      return UserEntity.fromJson(response);
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  /// Register new user
  /// (تسجيل مستخدم جديد)
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري إنشاء حساب جديد...",
      );
      
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        showLoading: false,
        isGlobalLoader: true,
      );
      return UserEntity.fromJson(response);
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }
} 