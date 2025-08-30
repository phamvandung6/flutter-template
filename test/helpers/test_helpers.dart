import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Test helper utilities for the Flutter Template project
class TestHelpers {
  /// Create a Material App wrapper for widget testing
  static Widget createApp({
    required Widget child,
    List<BlocProvider>? providers,
    ThemeData? theme,
    Locale? locale,
  }) {
    Widget app = MaterialApp(
      home: child,
      theme: theme,
      locale: locale,
      localizationsDelegates: const [],
    );

    if (providers != null && providers.isNotEmpty) {
      app = MultiBlocProvider(
        providers: providers,
        child: app,
      );
    }

    return app;
  }

  /// Create a Scaffold wrapper for testing widgets that need a Scaffold
  static Widget createScaffold({
    required Widget child,
    AppBar? appBar,
    Widget? drawer,
    Widget? floatingActionButton,
  }) {
    return Scaffold(
      appBar: appBar,
      body: child,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
    );
  }

  /// Pump and settle with a default duration
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }

  /// Find widget by type with optional index
  static Finder findWidgetByType<T extends Widget>([int index = 0]) {
    final finder = find.byType(T);
    return index == 0 ? finder : finder.at(index);
  }

  /// Find widget by key
  static Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Verify that a widget exists
  static void verifyWidgetExists<T extends Widget>() {
    expect(find.byType(T), findsOneWidget);
  }

  /// Verify that a widget does not exist
  static void verifyWidgetNotExists<T extends Widget>() {
    expect(find.byType(T), findsNothing);
  }

  /// Verify text content
  static void verifyText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Tap on a widget by type
  static Future<void> tapWidget<T extends Widget>(
    WidgetTester tester, [
    int index = 0,
  ]) async {
    await tester.tap(findWidgetByType<T>(index));
    await pumpAndSettle(tester);
  }

  /// Tap on a widget by key
  static Future<void> tapByKey(WidgetTester tester, String key) async {
    await tester.tap(findByKey(key));
    await pumpAndSettle(tester);
  }

  /// Enter text into a text field
  static Future<void> enterText(
    WidgetTester tester,
    String text, {
    String? key,
    Type? widgetType,
  }) async {
    final finder = key != null
        ? findByKey(key)
        : widgetType != null
            ? find.byType(widgetType)
            : find.byType(TextField);

    await tester.enterText(finder, text);
    await pumpAndSettle(tester);
  }
}

/// Mock class registration helper
class MockRegistration {
  static void registerFallbackValues() {
    // Register fallback values for common types used in mocks
    registerFallbackValue(const Duration(seconds: 1));
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(StackTrace.empty);
  }
}

/// Common test constants
class TestConstants {
  static const String testAccessToken = 'test_access_token';
  static const String testRefreshToken = 'test_refresh_token';
  static const String testUserId = 'test_user_id';
  static const String testUserEmail = 'test@example.com';
  static const String testUserName = 'Test User';
  static const String testDeviceId = 'test_device_id';

  static const Duration testTimeout = Duration(seconds: 5);
  static const Duration testDelay = Duration(milliseconds: 100);
}
