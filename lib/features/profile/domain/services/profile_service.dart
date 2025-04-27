import 'package:get_it/get_it.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileService {
  final ProfileRepository _repository = GetIt.I<ProfileRepository>();

  Future<Map<String, dynamic>> getUserProfile() async {
    return await _repository.getUserProfile();
  }
} 