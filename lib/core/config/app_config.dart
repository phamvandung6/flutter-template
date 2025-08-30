import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/config/environments/development_config.dart';
import 'package:flutter_template/core/config/environments/production_config.dart';
import 'package:flutter_template/core/config/environments/staging_config.dart';
import 'package:flutter_template/core/config/models/environment_config.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

/// Global app configuration manager
@lazySingleton
class AppConfig {
  AppConfig();
  static AppConfig? _instance;
  static EnvironmentConfig? _config;

  /// Get singleton instance
  static AppConfig get instance {
    assert(_instance != null, 'AppConfig must be initialized first');
    return _instance!;
  }

  /// Get current environment configuration
  static EnvironmentConfig get config {
    assert(_config != null, 'AppConfig must be initialized first');
    return _config!;
  }

  /// Initialize app configuration
  static Future<void> initialize({
    AppEnvironment? environment,
    AppLogger? logger,
  }) async {
    // Determine environment
    final env = environment ?? _getEnvironmentFromFlavor();

    // Set configuration based on environment
    switch (env) {
      case AppEnvironment.development:
        _config = DevelopmentConfig.config;
      case AppEnvironment.staging:
        _config = StagingConfig.config;
      case AppEnvironment.production:
        _config = ProductionConfig.config;
    }

    // Create instance
    _instance = AppConfig();

    // Log configuration
    if (_config!.enableLogging && logger != null) {
      logger
        ..info('🚀 App initialized with environment: ${env.value}')
        ..debug('📱 App name: ${_config!.fullAppName}')
        ..debug('🌐 Base URL: ${_config!.baseUrl}')
        ..debug('🔧 Debug mode: ${_config!.enableDebugMode}')
        ..debug('📊 Analytics: ${_config!.enableAnalytics}');
    }
  }

  /// Get environment from build flavor or default
  static AppEnvironment _getEnvironmentFromFlavor() {
    // Try to get from flavor first
    const flavor = String.fromEnvironment('FLAVOR');

    if (flavor.isNotEmpty) {
      switch (flavor.toLowerCase()) {
        case 'development':
        case 'dev':
          return AppEnvironment.development;
        case 'staging':
        case 'stg':
          return AppEnvironment.staging;
        case 'production':
        case 'prod':
          return AppEnvironment.production;
      }
    }

    // Fallback to debug mode detection
    if (kDebugMode) {
      return AppEnvironment.development;
    } else if (kProfileMode) {
      return AppEnvironment.staging;
    } else {
      return AppEnvironment.production;
    }
  }

  /// Check if current environment matches
  static bool isEnvironment(AppEnvironment environment) {
    return config.environment == environment;
  }

  /// Check if development environment
  static bool get isDevelopment => config.environment.isDevelopment;

  /// Check if staging environment
  static bool get isStaging => config.environment.isStaging;

  /// Check if production environment
  static bool get isProduction => config.environment.isProduction;

  /// Check if debug environment (dev or staging)
  static bool get isDebug => config.environment.isDebug;

  /// Check if release environment (production)
  static bool get isRelease => config.environment.isRelease;

  /// Get app name
  static String get appName => config.fullAppName;

  /// Get base URL
  static String get baseUrl => config.baseUrl;

  /// Get API URL
  static String get apiUrl => config.apiUrl;

  /// Check if logging is enabled
  static bool get isLoggingEnabled => config.enableLogging;

  /// Check if debug mode is enabled
  static bool get isDebugModeEnabled => config.enableDebugMode;

  /// Check if analytics is enabled
  static bool get isAnalyticsEnabled => config.enableAnalytics;

  /// Check if crash reporting is enabled
  static bool get isCrashReportingEnabled => config.enableCrashReporting;

  /// Check if feature is enabled
  static bool isFeatureEnabled(String featureName) {
    return config.isFeatureEnabled(featureName);
  }

  /// Get feature value
  static T? getFeatureValue<T>(String featureName) {
    return config.getFeatureValue<T>(featureName);
  }

  /// Get network timeouts
  static Map<String, int> get networkTimeouts => {
        'connect': config.connectTimeout,
        'receive': config.receiveTimeout,
        'send': config.sendTimeout,
      };

  /// Get environment-specific bundle ID
  static String get bundleId {
    switch (config.environment) {
      case AppEnvironment.development:
        return DevelopmentConfig.bundleId;
      case AppEnvironment.staging:
        return StagingConfig.bundleId;
      case AppEnvironment.production:
        return ProductionConfig.bundleId;
    }
  }

  /// Get environment-specific app icon
  static String get appIcon {
    switch (config.environment) {
      case AppEnvironment.development:
        return DevelopmentConfig.appIcon;
      case AppEnvironment.staging:
        return StagingConfig.appIcon;
      case AppEnvironment.production:
        return ProductionConfig.appIcon;
    }
  }

  /// Get environment-specific flavor name
  static String get flavor {
    switch (config.environment) {
      case AppEnvironment.development:
        return DevelopmentConfig.flavor;
      case AppEnvironment.staging:
        return StagingConfig.flavor;
      case AppEnvironment.production:
        return ProductionConfig.flavor;
    }
  }

  /// Update configuration at runtime (for testing)
  @visibleForTesting
  static set config(EnvironmentConfig newConfig) {
    _config = newConfig;
  }

  /// Reset configuration (for testing)
  @visibleForTesting
  static void reset() {
    _instance = null;
    _config = null;
  }
}
