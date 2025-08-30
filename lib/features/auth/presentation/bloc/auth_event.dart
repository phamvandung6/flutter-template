import '../../../../shared/presentation/bloc/base_bloc_event.dart';

/// Base class for all authentication events
abstract class AuthEvent extends BaseBlocEvent {
  const AuthEvent();
}

/// Event triggered when user requests login
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
  final String? deviceId;

  const LoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.deviceId,
  });

  @override
  List<Object?> get props => [email, password, rememberMe, deviceId];
}

/// Event triggered when user requests registration
class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phoneNumber;
  final bool termsAccepted;

  const RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phoneNumber,
    required this.termsAccepted,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        passwordConfirmation,
        phoneNumber,
        termsAccepted,
      ];
}

/// Event triggered when user requests logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Event triggered to check current authentication status
class CheckAuthStatus extends AuthEvent {
  final bool silent;

  const CheckAuthStatus({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

/// Event triggered when authentication token expires
class TokenExpired extends AuthEvent {
  const TokenExpired();
}

/// Event triggered to refresh authentication token
class RefreshTokenRequested extends AuthEvent {
  const RefreshTokenRequested();
}
