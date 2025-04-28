import 'package:clean_architecture_example/core/api/network/api_client.dart';
import 'package:clean_architecture_example/core/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Provider not overridden');
});

final apiClientProvider = Provider<ApiClient>((ref) {
  throw UnimplementedError('Provider not overridden');
}); 