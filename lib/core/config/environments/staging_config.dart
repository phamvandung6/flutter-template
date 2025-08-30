import '../models/environment_config.dart';

/// Staging environment configuration
class StagingConfig {
  static const EnvironmentConfig config = EnvironmentConfig(
    environment: AppEnvironment.staging,
    appName: 'Flutter Template',
    appSuffix: 'Staging',
    baseUrl: 'https://staging-api.flutter-template.com',
    apiVersion: 'v1',
    enableLogging: true,
    enableDebugMode: true,
    enableAnalytics: true,
    enableCrashReporting: true,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    sendTimeout: 30000,
    features: {
      // Staging-specific features
      'mock_api': false,
      'debug_panel': true,
      'performance_overlay': false,
      'inspector': false,
      'verbose_logging': false,

      // Feature flags for staging
      'new_ui_components': true,
      'experimental_features': false,
      'beta_features': true,

      // API features
      'api_logging': true,
      'api_mocking': false,
      'network_delay_simulation': false,

      // Database features
      'database_logging': false,
      'seed_data': false,
      'reset_data': false,

      // Testing features
      'integration_tests': true,
      'e2e_tests': true,
      'performance_tests': true,
    },
  );

  /// Staging-specific constants
  static const String bundleId = 'com.example.flutter_template.staging';
  static const String appIcon = 'assets/icons/app_icon_staging.png';
  static const String flavor = 'staging';

  /// Staging API endpoints
  static const Map<String, String> endpoints = {
    'auth': '/auth',
    'users': '/users',
    'products': '/products',
    'orders': '/orders',
    'notifications': '/notifications',
    'analytics': '/analytics',
    'feedback': '/feedback',
  };

  /// Staging database configuration
  static const Map<String, dynamic> database = {
    'name': 'flutter_template_staging.db',
    'version': 1,
    'enable_logging': false,
    'enable_foreign_keys': true,
    'enable_wal': true,
  };

  /// Staging cache configuration
  static const Map<String, dynamic> cache = {
    'max_size': 100 * 1024 * 1024, // 100MB
    'max_age': Duration.millisecondsPerHour * 6, // 6 hours
    'enable_disk_cache': true,
    'enable_memory_cache': true,
  };

  /// Staging security configuration
  static const Map<String, dynamic> security = {
    'enable_certificate_pinning': true,
    'enable_network_security_config': true,
    'enable_obfuscation': false,
    'enable_root_detection': false,
  };
}
