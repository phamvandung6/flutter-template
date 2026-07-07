import 'package:flutter_template/core/config/models/environment_config.dart';

/// Production environment configuration
class ProductionConfig {
  static const EnvironmentConfig config = EnvironmentConfig(
    environment: AppEnvironment.production,
    appName: 'Flutter Template',
    appSuffix: '',
    baseUrl: 'https://api.flutter-template.com',
    enableLogging: false,
    connectTimeout: 15000,
    receiveTimeout: 15000,
    sendTimeout: 15000,
    features: {
      // Production-specific features
      'mock_api': false,
      'debug_panel': false,
      'performance_overlay': false,
      'inspector': false,
      'verbose_logging': false,

      // Feature flags for production
      'new_ui_components': false,
      'experimental_features': false,
      'beta_features': false,

      // API features
      'api_logging': false,
      'api_mocking': false,
      'network_delay_simulation': false,

      // Database features
      'database_logging': false,
      'seed_data': false,
      'reset_data': false,

      // Production features
      'push_notifications': true,
      'in_app_purchases': true,
      'social_sharing': true,
      'deep_linking': true,

      // Security features
      'certificate_pinning': true,
      'network_security': true,
      'obfuscation': true,
      'root_detection': true,

      // Performance features
      'image_optimization': true,
      'lazy_loading': true,
      'caching_strategy': true,
    },
  );

  /// Production-specific constants
  static const String bundleId = 'com.example.flutter_template';
  static const String appIcon = 'assets/icons/app_icon.png';
  static const String flavor = 'production';

  /// Production API endpoints
  static const Map<String, String> endpoints = {
    'auth': '/auth',
    'users': '/users',
    'products': '/products',
    'orders': '/orders',
    'notifications': '/notifications',
    'analytics': '/analytics',
    'payments': '/payments',
    'support': '/support',
  };

  /// Production database configuration
  static const Map<String, dynamic> database = {
    'name': 'flutter_template.db',
    'version': 1,
    'enable_logging': false,
    'enable_foreign_keys': true,
    'enable_wal': true,
  };

  /// Production cache configuration
  static const Map<String, dynamic> cache = {
    'max_size': 200 * 1024 * 1024, // 200MB
    'max_age': Duration.millisecondsPerDay, // 24 hours
    'enable_disk_cache': true,
    'enable_memory_cache': true,
  };

  /// Production security configuration
  static const Map<String, dynamic> security = {
    'enable_certificate_pinning': true,
    'enable_network_security_config': true,
    'enable_obfuscation': true,
    'enable_root_detection': true,
    'enable_ssl_validation': true,
    'min_tls_version': '1.2',
  };

  /// Production analytics configuration
  static const Map<String, dynamic> analytics = {
    'firebase_analytics': true,
    'crashlytics': true,
    'performance_monitoring': true,
    'user_engagement': true,
    'conversion_tracking': true,
  };
}
