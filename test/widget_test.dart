// Main app widget test
// This is a basic smoke test to ensure the app builds and runs correctly

import 'package:flutter_template/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_config.dart';

void main() {
  // Setup test configuration
  TestConfig.setupTests();

  group('MyApp', () {
    testWidgets('should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app builds successfully
      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
