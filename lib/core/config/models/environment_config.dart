/// Environment types for the application
enum AppEnvironment {
  development('development'),
  staging('staging'),
  production('production');

  const AppEnvironment(this.value);

  final String value;

  /// Check if current environment is development
  bool get isDevelopment => this == AppEnvironment.development;

  /// Check if current environment is staging
  bool get isStaging => this == AppEnvironment.staging;

  /// Check if current environment is production
  bool get isProduction => this == AppEnvironment.production;

  /// Check if current environment is debug (dev or staging)
  bool get isDebug => isDevelopment || isStaging;

  /// Check if current environment is release
  bool get isRelease => isProduction;
}

/// Configuration model for different environments
class EnvironmentConfig {
  const EnvironmentConfig({
    required this.environment,
    required this.appName,
    required this.appSuffix,
    required this.baseUrl,
    this.apiVersion = 'v1',
    this.enableLogging = true,
    this.enableDebugMode = false,
    this.enableAnalytics = true,
    this.enableCrashReporting = true,
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.features = const {},
  });

  final AppEnvironment environment;
  final String appName;
  final String appSuffix;
  final String baseUrl;
  final String apiVersion;
  final bool enableLogging;
  final bool enableDebugMode;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final int connectTimeout;
  final int receiveTimeout;
  final int sendTimeout;
  final Map<String, dynamic> features;

  /// Get full API URL with version
  String get apiUrl => '$baseUrl/api/$apiVersion';

  /// Get full app name with suffix
  String get fullAppName => appSuffix.isEmpty ? appName : '$appName $appSuffix';

  /// Check if feature is enabled
  bool isFeatureEnabled(String featureName) {
    return features[featureName] == true;
  }

  /// Get feature value
  T? getFeatureValue<T>(String featureName) {
    return features[featureName] as T?;
  }

  @override
  String toString() {
    return 'EnvironmentConfig('
        'environment: ${environment.value}, '
        'appName: $fullAppName, '
        'baseUrl: $baseUrl, '
        'enableLogging: $enableLogging, '
        'enableDebugMode: $enableDebugMode'
        ')';
  }

  /// Create a copy with updated values
  EnvironmentConfig copyWith({
    AppEnvironment? environment,
    String? appName,
    String? appSuffix,
    String? baseUrl,
    String? apiVersion,
    bool? enableLogging,
    bool? enableDebugMode,
    bool? enableAnalytics,
    bool? enableCrashReporting,
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
    Map<String, dynamic>? features,
  }) {
    return EnvironmentConfig(
      environment: environment ?? this.environment,
      appName: appName ?? this.appName,
      appSuffix: appSuffix ?? this.appSuffix,
      baseUrl: baseUrl ?? this.baseUrl,
      apiVersion: apiVersion ?? this.apiVersion,
      enableLogging: enableLogging ?? this.enableLogging,
      enableDebugMode: enableDebugMode ?? this.enableDebugMode,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      features: features ?? this.features,
    );
  }
}
