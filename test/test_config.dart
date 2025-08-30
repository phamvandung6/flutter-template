import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_dependencies.dart';

/// Global test configuration and setup
class TestConfig {
  /// Setup common test configuration
  static void setupTests() {
    // Setup mock fallback values
    MockSetup.setupMocks();

    // Set up test environment
    setUpAll(() {
      // Any global setup that needs to run once before all tests
    });

    setUp(() {
      // Any setup that needs to run before each test
    });

    tearDown(() {
      // Any cleanup that needs to run after each test
    });
  }
}

/// Test group helper for organizing tests
class TestGroups {
  static void runUnitTests(String description, Function() body) {
    group('Unit Tests - $description', body);
  }

  static void runWidgetTests(String description, Function() body) {
    group('Widget Tests - $description', body);
  }

  static void runIntegrationTests(String description, Function() body) {
    group('Integration Tests - $description', body);
  }
}
