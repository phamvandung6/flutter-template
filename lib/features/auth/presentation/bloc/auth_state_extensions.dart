import 'package:flutter_template/shared/presentation/bloc/base_bloc_state_extensions.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity_extensions.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_state.dart';

/// Extensions for AuthState to provide authentication-specific functionality
extension AuthStateX on AuthState {
  /// Check if user is authenticated
  bool get isAuthenticated => isSuccess && hasData;

  /// Check if user is unauthenticated
  bool get isUnauthenticated => isEmpty || (isSuccess && !hasData);

  /// Get authenticated user (null if not authenticated)
  UserEntity? get user => isAuthenticated ? data : null;

  /// Check if registration was successful but needs verification
  bool get isRegistrationSuccess =>
      isSuccess &&
      context != null &&
      context!.startsWith('registration_success:');

  /// Check if password reset email was sent
  bool get isPasswordResetSent =>
      isSuccess &&
      context != null &&
      context!.startsWith('password_reset_sent:');

  /// Get email from registration success context
  String? get registrationEmail {
    if (!isRegistrationSuccess) return null;
    return context?.split(':').last;
  }

  /// Get email from password reset sent context
  String? get passwordResetEmail {
    if (!isPasswordResetSent) return null;
    return context?.split(':').last;
  }

  /// Check if user has specific role
  bool hasRole(String role) => user?.hasRole(role) ?? false;

  /// Check if user is admin
  bool get isAdmin => user?.isAdmin ?? false;

  /// Get user display name
  String get displayName => user?.displayName ?? 'Guest';

  /// Get user full name
  String get fullName => user?.fullName ?? '';

  /// Check if user is verified
  bool get isVerified => user?.isVerified ?? false;

  /// Check if user is active
  bool get isActive => user?.isActive ?? false;

  /// Check if should show login form
  bool get shouldShowLoginForm => isInitial || isUnauthenticated;

  /// Check if should show authenticated content
  bool get shouldShowAuthenticatedContent => isAuthenticated;

  /// Check if should show loading indicator
  bool get shouldShowLoading => isLoading;

  /// Check if should show error message
  bool get shouldShowError => hasError;

  /// Check if should show registration success message
  bool get shouldShowRegistrationSuccess => isRegistrationSuccess;

  /// Check if should show password reset success message
  bool get shouldShowPasswordResetSuccess => isPasswordResetSent;

  /// Get authentication status message
  String get statusMessage {
    if (isLoading) return loadingMessage;
    if (hasError) return errorMessage;
    if (isAuthenticated) return 'Welcome, ${user!.firstName}!';
    if (isRegistrationSuccess) return message ?? 'Registration successful!';
    if (isPasswordResetSent) return message ?? 'Password reset email sent!';
    if (isUnauthenticated) return 'Please sign in to continue';
    return 'Checking authentication...';
  }

  /// Create a copy with authenticated user
  AuthState copyWithUser(UserEntity user) {
    return AuthStateFactory.authenticated(user);
  }

  /// Create a copy with error
  AuthState copyWithError(String errorMessage, {String? context}) {
    return AuthStateFactory.error(errorMessage, context: context);
  }

  /// Create a copy with loading state
  AuthState copyWithLoading({String? message}) {
    return AuthStateFactory.loading(message: message);
  }
}
