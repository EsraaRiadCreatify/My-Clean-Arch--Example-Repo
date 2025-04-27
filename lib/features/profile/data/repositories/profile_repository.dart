abstract class ProfileRepository {
  Future<Map<String, dynamic>> getUserProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Map<String, dynamic>> getUserProfile() async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'avatar': 'https://example.com/avatar.jpg'
    };
  }
} 