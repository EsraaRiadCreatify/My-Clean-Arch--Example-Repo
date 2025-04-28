import '../../domain/entities/user_entity.dart';
import '../../../../core/api/network/api_client.dart';
import '../../../../core/shared_widgets/loading/loading_controller.dart';
import 'package:flutter/material.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;
  final _loadingController = LoadingController();

  UserRemoteDataSource(this._apiClient);

  Future<UserEntity> getUser(String id) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب بيانات المستخدم...",
      );
      
      final response = await _apiClient.get<UserEntity>(
        endpoint: '/users/$id',
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  Future<List<UserEntity>> getUsers() async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب قائمة المستخدمين...",
      );
      
      final response = await _apiClient.get<List<UserEntity>>(
        endpoint: '/users',
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  Future<UserEntity> createUser(UserEntity user) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري إنشاء مستخدم جديد...",
      );
      
      final response = await _apiClient.post<UserEntity>(
        endpoint: '/users',
        data: user.toJson(),
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  Future<UserEntity> updateUser(String id, UserEntity user) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري تحديث بيانات المستخدم...",
      );
      
      final response = await _apiClient.put<UserEntity>(
        endpoint: '/users/$id',
        data: user.toJson(),
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري حذف المستخدم...",
      );
      
      await _apiClient.delete<void>(
        endpoint: '/users/$id',
      );
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري تغيير كلمة المرور...",
      );
      
      await _apiClient.post<void>(
        endpoint: '/users/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري تسجيل الدخول...",
      );
      
      final response = await _apiClient.post<UserEntity>(
        endpoint: '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }

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
      
      final response = await _apiClient.post<UserEntity>(
        endpoint: '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }
} 