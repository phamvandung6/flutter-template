/// Application constants for technical configurations
class AppConstants {
  // API Configuration
  static const String baseUrlDev = 'https://api-dev.example.com/';
  static const String baseUrlProd = 'https://api.example.com/';
  
  // Network Configuration
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
  static const int sendTimeout = 3000;
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  
  // Cache Configuration
  static const int defaultCacheMaxAge = 60; // minutes
  static const int imageCacheMaxAge = 7; // days
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
}
