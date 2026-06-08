import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/shared/presentation/bloc/base_view_state.dart';

/// Type alias for AuthState using single state approach
typedef AuthState = BaseViewState<UserEntity>;

/// Enum for specific authentication statuses
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  registrationSuccess,
  passwordResetSent,
}

/// Factory methods for creating AuthState instances
class AuthStateFactory {
  /// Create initial auth state
  static AuthState initial() {
    return const BaseViewState<UserEntity>();
  }

  /// Create loading auth state
  static AuthState loading({String? message}) {
    return BaseViewState<UserEntity>(
      status: ViewStatus.loading,
      message: message ?? 'Authenticating...',
    );
  }

  /// Create authenticated state
  static AuthState authenticated(UserEntity user) {
    return BaseViewState<UserEntity>(
      status: ViewStatus.success,
      data: user,
      message: 'Authentication successful',
    );
  }

  /// Create unauthenticated state
  static AuthState unauthenticated() {
    return const BaseViewState<UserEntity>(
      status: ViewStatus.empty,
      message: 'Not authenticated',
    );
  }

  /// Create error state
  static AuthState error(String message, {String? context}) {
    return BaseViewState<UserEntity>(
      status: ViewStatus.error,
      message: message,
      context: context,
    );
  }

  /// Create registration success state (awaiting verification)
  static AuthState registrationSuccess(String email, String message) {
    return BaseViewState<UserEntity>(
      status: ViewStatus.success,
      message: message,
      context: 'registration_success:$email',
    );
  }

  /// Create password reset sent state
  static AuthState passwordResetSent(String email) {
    return BaseViewState<UserEntity>(
      status: ViewStatus.success,
      message: 'Password reset email sent',
      context: 'password_reset_sent:$email',
    );
  }
}
