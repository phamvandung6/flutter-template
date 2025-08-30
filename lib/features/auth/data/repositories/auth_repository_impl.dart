import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/network/network_info.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_template/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_template/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_template/features/auth/data/models/login_request_dto.dart';
import 'package:flutter_template/features/auth/data/models/register_request_dto.dart';
import 'package:flutter_template/features/auth/data/models/user_dto.dart';

/// Implementation of AuthRepository following Clean Architecture principles
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._logger,
  );
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppLogger _logger;

  @override
  ResultFuture<UserEntity> login({
    required String email,
    required String password,
    bool rememberMe = false,
    String? deviceId,
  }) async {
    try {
      // Check network connectivity
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Attempting login for email: $email');

      // Create login request
      final request = LoginRequestDto(
        email: email,
        password: password,
        rememberMe: rememberMe,
        deviceId: deviceId,
      );

      // Call remote API
      final response = await _remoteDataSource.login(request);

      _logger.info('Login successful for user: ${response.user.email}');

      // Store tokens and user data locally
      await Future.wait([
        _localDataSource.storeAccessToken(response.accessToken),
        _localDataSource.storeRefreshToken(response.refreshToken),
        _localDataSource.cacheUser(response.user),
        if (deviceId != null) _localDataSource.storeDeviceId(deviceId),
      ]);

      // Convert DTO to Entity and return
      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      _logger.error('Server error during login', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on NetworkException catch (e) {
      _logger.error('Network error during login', e);
      return Left(NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on CacheException catch (e) {
      _logger.error('Cache error during login', e);
      return Left(CacheFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error during login', e);
      return const Left(GeneralFailure(
        message: 'An unexpected error occurred during login',
      ),);
    }
  }

  @override
  ResultFuture<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required bool termsAccepted, String? phoneNumber,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Attempting registration for email: $email');

      final request = RegisterRequestDto(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        termsAccepted: termsAccepted,
      );

      final userDto = await _remoteDataSource.register(request);

      _logger.info('Registration successful for user: ${userDto.email}');

      // Cache user data
      await _localDataSource.cacheUser(userDto);

      return Right(userDto.toEntity());
    } on ServerException catch (e) {
      _logger.error('Server error during registration', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on ValidationException catch (e) {
      _logger.error('Validation error during registration', e);
      return Left(ValidationFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on NetworkException catch (e) {
      _logger.error('Network error during registration', e);
      return Left(NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error during registration', e);
      return const Left(GeneralFailure(
        message: 'An unexpected error occurred during registration',
      ),);
    }
  }

  @override
  ResultFuture<UserEntity> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();

      if (refreshToken == null) {
        return const Left(AuthenticationFailure(
          message: 'No refresh token available',
        ),);
      }

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Refreshing authentication token');

      final response = await _remoteDataSource.refreshToken(refreshToken);

      // Update stored tokens and user data
      await Future.wait([
        _localDataSource.storeAccessToken(response.accessToken),
        _localDataSource.storeRefreshToken(response.refreshToken),
        _localDataSource.cacheUser(response.user),
      ]);

      _logger.info('Token refresh successful');
      return Right(response.user.toEntity());
    } on AuthenticationException catch (e) {
      _logger.error('Authentication error during token refresh', e);
      // Clear invalid tokens
      await _localDataSource.clearAuthData();
      return Left(AuthenticationFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on NetworkException catch (e) {
      _logger.error('Network error during token refresh', e);
      return Left(NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error during token refresh', e);
      return const Left(GeneralFailure(
        message: 'Failed to refresh authentication token',
      ),);
    }
  }

  @override
  ResultVoid logout() async {
    try {
      _logger.info('Logging out user');

      // Try to call remote logout (best effort)
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.logout();
        } catch (e) {
          _logger.warning('Remote logout failed, continuing with local logout');
        }
      }

      // Always clear local data
      await _localDataSource.clearAuthData();

      _logger.info('Logout successful');
      return const Right(null);
    } catch (e) {
      _logger.error('Error during logout', e);
      return const Left(GeneralFailure(
        message: 'Failed to logout properly',
      ),);
    }
  }

  @override
  ResultFuture<UserEntity> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await _localDataSource.getCachedUser();

      if (cachedUser != null) {
        _logger.debug('Returning cached user data');
        return Right(cachedUser.toEntity());
      }

      // If no cache and network available, fetch from server
      if (await _networkInfo.isConnected) {
        _logger.info('Fetching current user from server');

        final userDto = await _remoteDataSource.getCurrentUser();

        // Cache the fresh data
        await _localDataSource.cacheUser(userDto);

        return Right(userDto.toEntity());
      }

      // No cache and no network
      return const Left(CacheFailure(
        message: 'No user data available offline',
      ),);
    } on AuthenticationException catch (e) {
      _logger.error('Authentication error getting current user', e);
      await _localDataSource.clearAuthData();
      return Left(AuthenticationFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on NetworkException catch (e) {
      _logger.error('Network error getting current user', e);
      return Left(NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error getting current user', e);
      return const Left(GeneralFailure(
        message: 'Failed to get current user',
      ),);
    }
  }

  @override
  ResultFuture<UserEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Updating user profile');

      final profileData = <String, dynamic>{};
      if (firstName != null) profileData['first_name'] = firstName;
      if (lastName != null) profileData['last_name'] = lastName;
      if (phoneNumber != null) profileData['phone_number'] = phoneNumber;
      if (avatarUrl != null) profileData['avatar_url'] = avatarUrl;

      final updatedUser = await _remoteDataSource.updateProfile(profileData);

      // Update cache
      await _localDataSource.cacheUser(updatedUser);

      _logger.info('Profile update successful');
      return Right(updatedUser.toEntity());
    } on ServerException catch (e) {
      _logger.error('Server error updating profile', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on ValidationException catch (e) {
      _logger.error('Validation error updating profile', e);
      return Left(ValidationFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error updating profile', e);
      return const Left(GeneralFailure(
        message: 'Failed to update profile',
      ),);
    }
  }

  @override
  ResultVoid changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Changing user password');

      final passwordData = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      };

      await _remoteDataSource.changePassword(passwordData);

      _logger.info('Password change successful');
      return const Right(null);
    } on ServerException catch (e) {
      _logger.error('Server error changing password', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } on ValidationException catch (e) {
      _logger.error('Validation error changing password', e);
      return Left(ValidationFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error changing password', e);
      return const Left(GeneralFailure(
        message: 'Failed to change password',
      ),);
    }
  }

  @override
  ResultVoid forgotPassword(String email) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Requesting password reset for email: $email');

      await _remoteDataSource.forgotPassword(email);

      _logger.info('Password reset request sent successfully');
      return const Right(null);
    } on ServerException catch (e) {
      _logger.error('Server error requesting password reset', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error requesting password reset', e);
      return const Left(GeneralFailure(
        message: 'Failed to request password reset',
      ),);
    }
  }

  @override
  ResultVoid resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          statusCode: 0,
        ),);
      }

      _logger.info('Resetting password with token');

      await _remoteDataSource.resetPassword(token, newPassword);

      _logger.info('Password reset successful');
      return const Right(null);
    } on ServerException catch (e) {
      _logger.error('Server error resetting password', e);
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ),);
    } catch (e) {
      _logger.error('Unexpected error resetting password', e);
      return const Left(GeneralFailure(
        message: 'Failed to reset password',
      ),);
    }
  }

  @override
  bool get isAuthenticated {
    // This should be implemented synchronously for immediate UI decisions
    // In real app, you might want to check token expiry as well
    try {
      // Simple check - in production you'd want to verify token validity
      return true; // Placeholder - implement actual logic
    } catch (e) {
      return false;
    }
  }

  @override
  UserEntity? get currentUser {
    // Synchronous getter for immediate access to cached user
    // Implementation would need to be synchronous or use a state management solution
    return null; // Placeholder - implement actual caching strategy
  }

  @override
  ResultVoid clearAuthData() async {
    try {
      _logger.info('Clearing all authentication data');

      await _localDataSource.clearAuthData();

      _logger.info('Authentication data cleared successfully');
      return const Right(null);
    } catch (e) {
      _logger.error('Error clearing authentication data', e);
      return const Left(GeneralFailure(
        message: 'Failed to clear authentication data',
      ),);
    }
  }
}
