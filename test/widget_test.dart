// Main app widget test
// This is a basic smoke test to ensure the app builds and runs correctly

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/di/injection.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/main.dart';
import 'test_config.dart';

void main() {
  // Setup test configuration
  TestConfig.setupTests();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.initialize(logger: AppLogger());
    await configureDependencies();
  });

  group('MyApp', () {
    testWidgets('should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app builds successfully
      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
