import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_template/core/utils/logger.dart';

@lazySingleton
class DioClient {
  DioClient(this._secureStorage, this._logger) {
    _dio = Dio();
    _setupBaseOptions();
    _setupInterceptors();
  }
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final AppLogger _logger;

  Dio get dio => _dio;

  void _setupBaseOptions() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrlDev, // Will be configured by environment
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      followRedirects: true,
    );
  }

  void _setupInterceptors() {
    // Order matters: Auth → Cache → Logging → Error
    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage, _logger),
      _getCacheInterceptor(),
      LoggingInterceptor(_logger),
      ErrorInterceptor(_logger),
    ]);
  }

  DioCacheInterceptor _getCacheInterceptor() {
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.forceCache,
      maxStale: const Duration(minutes: AppConstants.defaultCacheMaxAge),
    );

    return DioCacheInterceptor(options: cacheOptions);
  }

  /// Update base URL (for environment switching)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _logger.info('Base URL updated to: $baseUrl');
  }

  /// Add or update header
  void setHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Clear all custom headers
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
  }
}
