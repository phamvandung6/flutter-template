import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/core/utils/logger.dart';

/// Interceptor for handling authentication tokens
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage, this._logger);
  final FlutterSecureStorage _secureStorage;
  final AppLogger _logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get access token from secure storage
      final accessToken = await _secureStorage.read(
        key: AppConstants.accessTokenKey,
      );

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        _logger.debug('Added auth token to request: ${options.path}');
      }

      handler.next(options);
    } catch (e) {
      _logger.error('Error adding auth token', e);
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      _logger.warning('Received 401 - attempting token refresh');

      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final retryResponse = await _retryRequest(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (e) {
        _logger.error('Token refresh failed', e);
        await _clearTokens();
      }
    }

    handler.next(err);
  }

  /// Refresh the access token using refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        _logger.warning('No refresh token available');
        return false;
      }

      // TODO(auth): Implement actual token refresh API call
      // This is a placeholder - replace with actual refresh endpoint
      final dio = Dio();
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data!['access_token'] as String?;
        final newRefreshToken = response.data!['refresh_token'] as String?;

        if (newAccessToken != null) {
          await _secureStorage.write(
            key: AppConstants.accessTokenKey,
            value: newAccessToken,
          );
          _logger.info('Access token refreshed successfully');
        }

        if (newRefreshToken != null) {
          await _secureStorage.write(
            key: AppConstants.refreshTokenKey,
            value: newRefreshToken,
          );
          _logger.info('Refresh token updated');
        }

        return true;
      }

      return false;
    } catch (e) {
      _logger.error('Token refresh error', e);
      return false;
    }
  }

  /// Retry the original request with new token
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    // Get the new access token
    final accessToken = await _secureStorage.read(
      key: AppConstants.accessTokenKey,
    );

    if (accessToken != null) {
      requestOptions.headers['Authorization'] = 'Bearer $accessToken';
    }

    final dio = Dio();
    return dio.fetch(requestOptions);
  }

  /// Clear all tokens (for logout or when refresh fails)
  Future<void> _clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: AppConstants.accessTokenKey),
      _secureStorage.delete(key: AppConstants.refreshTokenKey),
      _secureStorage.delete(key: AppConstants.userIdKey),
    ]);
    _logger.info('All tokens cleared');
  }
}
