import 'package:clean_architecture_example/core/api/network/api_client.dart';
import 'package:clean_architecture_example/core/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_architecture_example/main.dart';
import '../helpers/test_providers.dart';

class MockStorageService extends Mock implements StorageService {}
class MockApiClient extends Mock implements ApiClient {
  bool _isConnected = true;
  
  bool get isConnected => _isConnected;
  
  void setConnected(bool value) => _isConnected = value;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Management Flow', () {
    late ProviderContainer container;
    late MockStorageService storageService;
    late MockApiClient apiClient;

    setUp(() {
      storageService = MockStorageService();
      apiClient = MockApiClient();
      container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          apiClientProvider.overrideWithValue(apiClient),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Complete User Management Flow', (tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MyApp(
            storageService: storageService,
            apiClient: apiClient,
          ),
        ),
      );

      // Verify initial state
      expect(find.text('No users found'), findsOneWidget);

      // Add a new user
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), '1234567890');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify user was added
      expect(find.text('Test User'), findsOneWidget);

      // Edit the user
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Updated User');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify user was updated
      expect(find.text('Updated User'), findsOneWidget);

      // Delete the user
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify user was deleted
      expect(find.text('No users found'), findsOneWidget);
    });

    testWidgets('Offline Mode Handling', (tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MyApp(
            storageService: storageService,
            apiClient: apiClient,
          ),
        ),
      );

      // Simulate offline mode
      apiClient.setConnected(false);

      // Add a user while offline
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Offline User');
      await tester.enterText(find.byType(TextField).at(1), 'offline@example.com');
      await tester.enterText(find.byType(TextField).at(2), '9876543210');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify user was added locally
      expect(find.text('Offline User'), findsOneWidget);

      // Simulate coming back online
      apiClient.setConnected(true);
      await tester.tap(find.byIcon(Icons.sync));
      await tester.pumpAndSettle();

      // Verify user was synced
      expect(find.text('Offline User'), findsOneWidget);
    });
  });
} 