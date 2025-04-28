import 'package:get_it/get_it.dart';
import '../../data/repositories/profile_repository.dart';
import '../../../../core/shared_widgets/loading/loading_controller.dart';
import 'package:flutter/material.dart';

class ProfileService {
  final ProfileRepository _repository = GetIt.I<ProfileRepository>();
  final _loadingController = LoadingController();

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب بيانات الملف الشخصي...",
        backgroundColor: Colors.black54,
        spinnerColor: Colors.white,
      );
      
      final profile = await _repository.getUserProfile();
      
      return profile;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }
} 