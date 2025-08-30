import 'package:flutter_template/shared/presentation/bloc/base_bloc_state.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';

/// Type alias for AuthState using single state approach
typedef AuthState = BaseBlocState<UserEntity>;

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
    return const BaseBlocState<UserEntity>();
  }

  /// Create loading auth state
  static AuthState loading({String? message}) {
    return BaseBlocState<UserEntity>(
      status: BlocStatus.loading,
      message: message ?? 'Authenticating...',
    );
  }

  /// Create authenticated state
  static AuthState authenticated(UserEntity user) {
    return BaseBlocState<UserEntity>(
      status: BlocStatus.success,
      data: user,
      message: 'Authentication successful',
    );
  }

  /// Create unauthenticated state
  static AuthState unauthenticated() {
    return const BaseBlocState<UserEntity>(
      status: BlocStatus.empty,
      message: 'Not authenticated',
    );
  }

  /// Create error state
  static AuthState error(String message, {String? context}) {
    return BaseBlocState<UserEntity>(
      status: BlocStatus.error,
      message: message,
      context: context,
    );
  }

  /// Create registration success state (awaiting verification)
  static AuthState registrationSuccess(String email, String message) {
    return BaseBlocState<UserEntity>(
      status: BlocStatus.success,
      message: message,
      context: 'registration_success:$email',
    );
  }

  /// Create password reset sent state
  static AuthState passwordResetSent(String email) {
    return BaseBlocState<UserEntity>(
      status: BlocStatus.success,
      message: 'Password reset email sent',
      context: 'password_reset_sent:$email',
    );
  }
}
