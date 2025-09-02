import 'package:flutter_template/core/utils/typedef.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';

/// Repository interface for authentication operations
/// This defines the contract that the data layer must implement
abstract class AuthRepository {
  /// Authenticate user with email and password
  ResultFuture<UserEntity> login({
    required String email,
    required String password,
    bool rememberMe = false,
    String? deviceId,
  });

  /// Register new user account
  ResultFuture<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required bool termsAccepted,
    String? phoneNumber,
  });

  /// Refresh authentication token
  ResultFuture<UserEntity> refreshToken();

  /// Sign out current user
  ResultVoid logout();

  /// Get current authenticated user
  ResultFuture<UserEntity> getCurrentUser();

  /// Update user profile information
  ResultFuture<UserEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Change user password
  ResultVoid changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// Request password reset email
  ResultVoid forgotPassword(String email);

  /// Reset password with token
  ResultVoid resetPassword({
    required String token,
    required String newPassword,
  });

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Get stored user data (offline)
  UserEntity? get currentUser;

  /// Clear all stored authentication data
  ResultVoid clearAuthData();
}
