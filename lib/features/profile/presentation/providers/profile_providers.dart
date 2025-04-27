import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';
import '../../domain/services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return GetIt.I<ProfileService>();
});

final profileStateProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return ProfileNotifier(ref.watch(profileServiceProvider));
});

class ProfileNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ProfileService _service;

  ProfileNotifier(this._service) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 