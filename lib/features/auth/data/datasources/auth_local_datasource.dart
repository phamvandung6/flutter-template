import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/features/auth/data/models/user_dto.dart';

/// Interface for local authentication data storage
abstract class AuthLocalDataSource {
  /// Get cached user data
  Future<UserDto?> getCachedUser();

  /// Cache user data locally
  Future<void> cacheUser(UserDto user);

  /// Get stored access token
  Future<String?> getAccessToken();

  /// Store access token securely
  Future<void> storeAccessToken(String token);

  /// Get stored refresh token
  Future<String?> getRefreshToken();

  /// Store refresh token securely
  Future<void> storeRefreshToken(String token);

  /// Check if user is logged in (has valid tokens)
  Future<bool> isLoggedIn();

  /// Clear all stored authentication data
  Future<void> clearAuthData();

  /// Store device ID
  Future<void> storeDeviceId(String deviceId);

  /// Get device ID
  Future<String?> getDeviceId();
}

/// Implementation of AuthLocalDataSource using FlutterSecureStorage
@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  AuthLocalDataSourceImpl(this._secureStorage);
  final FlutterSecureStorage _secureStorage;

  // Storage keys
  static const String _userKey = 'cached_user';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _deviceIdKey = 'device_id';

  @override
  Future<UserDto?> getCachedUser() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);
      if (userJson != null) {
        final userMap = Map<String, dynamic>.from(
          // Simple JSON decode simulation - in real app use json.decode
          <String, dynamic>{},
        );
        return UserDto.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get cached user data',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> cacheUser(UserDto user) async {
    try {
      // Simple JSON encode simulation - in real app use json.encode
      final userJson = user.toJson().toString();
      await _secureStorage.write(key: _userKey, value: userJson);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to cache user data',
        statusCode: 500,
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get access token',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> storeAccessToken(String token) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to store access token',
        statusCode: 500,
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get refresh token',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> storeRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to store refresh token',
        statusCode: 500,
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();
      return accessToken != null && refreshToken != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _userKey),
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
        _secureStorage.delete(key: _deviceIdKey),
      ]);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to clear authentication data',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> storeDeviceId(String deviceId) async {
    try {
      await _secureStorage.write(key: _deviceIdKey, value: deviceId);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to store device ID',
        statusCode: 500,
      );
    }
  }

  @override
  Future<String?> getDeviceId() async {
    try {
      return await _secureStorage.read(key: _deviceIdKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get device ID',
        statusCode: 500,
      );
    }
  }
}
