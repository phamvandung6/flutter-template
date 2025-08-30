import '../models/environment_config.dart';

/// Development environment configuration
class DevelopmentConfig {
  static const EnvironmentConfig config = EnvironmentConfig(
    environment: AppEnvironment.development,
    appName: 'Flutter Template',
    appSuffix: 'Dev',
    baseUrl: 'https://dev-api.flutter-template.com',
    apiVersion: 'v1',
    enableLogging: true,
    enableDebugMode: true,
    enableAnalytics: false,
    enableCrashReporting: false,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    sendTimeout: 30000,
    features: {
      // Development-specific features
      'mock_api': true,
      'debug_panel': true,
      'performance_overlay': true,
      'inspector': true,
      'verbose_logging': true,

      // Feature flags for development
      'new_ui_components': true,
      'experimental_features': true,
      'beta_features': true,

      // API features
      'api_logging': true,
      'api_mocking': true,
      'network_delay_simulation': false,

      // Database features
      'database_logging': true,
      'seed_data': true,
      'reset_data': true,
    },
  );

  /// Development-specific constants
  static const String bundleId = 'com.example.flutter_template.dev';
  static const String appIcon = 'assets/icons/app_icon_dev.png';
  static const String flavor = 'development';

  /// Development API endpoints
  static const Map<String, String> endpoints = {
    'auth': '/auth',
    'users': '/users',
    'products': '/products',
    'orders': '/orders',
    'notifications': '/notifications',
  };

  /// Development database configuration
  static const Map<String, dynamic> database = {
    'name': 'flutter_template_dev.db',
    'version': 1,
    'enable_logging': true,
    'enable_foreign_keys': true,
    'enable_wal': true,
  };

  /// Development cache configuration
  static const Map<String, dynamic> cache = {
    'max_size': 50 * 1024 * 1024, // 50MB
    'max_age': Duration.millisecondsPerHour * 2, // 2 hours
    'enable_disk_cache': true,
    'enable_memory_cache': true,
  };
}
