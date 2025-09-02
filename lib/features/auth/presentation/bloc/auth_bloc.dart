import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/core/utils/usecase.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/usecases/get_current_user.dart';
import 'package:flutter_template/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_template/features/auth/domain/usecases/logout_user.dart';
import 'package:flutter_template/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_event.dart';

/// BLoC for authentication state management using single state approach
@injectable
class AuthBloc extends BaseBloc<AuthEvent, UserEntity> {
  AuthBloc(
    this._loginUser,
    this._registerUser,
    this._logoutUser,
    this._getCurrentUser,
    AppLogger logger,
  ) : super(AuthStateFactory.initial(), logger) {
    // Register event handlers
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;

  /// Handle login requests
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final params = LoginUserParams(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
      deviceId: event.deviceId,
    );

    await handleEitherResult<UserEntity>(
      emit,
      _loginUser(params),
      onSuccess: (user) => emit(AuthStateFactory.authenticated(user)),
      context: 'login',
    );
  }

  /// Handle registration requests
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    final params = RegisterUserParams(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      phoneNumber: event.phoneNumber,
      termsAccepted: event.termsAccepted,
    );

    await handleEitherResult<UserEntity>(
      emit,
      _registerUser(params),
      onSuccess: (user) => emit(AuthStateFactory.authenticated(user)),
      context: 'registration',
    );
  }

  /// Handle logout requests
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await handleEitherResult<void>(
      emit,
      _logoutUser(const NoParams()),
      onSuccess: (_) => emit(AuthStateFactory.unauthenticated()),
      context: 'logout',
    );
  }

  /// Handle auth status check
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    await handleEitherResult<UserEntity>(
      emit,
      _getCurrentUser(const NoParams()),
      onSuccess: (user) => emit(AuthStateFactory.authenticated(user)),
      context: 'auth_check',
      showLoading: !event.silent,
    );
  }

  @override
  Future<void> onRefresh(RefreshEvent event, Emitter<AuthState> emit) async {
    // Refresh auth status
    add(CheckAuthStatus(silent: !event.forceRefresh));
  }

  @override
  Future<void> onReset(ResetEvent event, Emitter<AuthState> emit) async {
    // Reset to initial state
    emit(AuthStateFactory.initial());
  }

  @override
  Future<void> onRetry(RetryEvent event, Emitter<AuthState> emit) async {
    // Retry based on current context
    if (event.context == 'auth_check') {
      add(const CheckAuthStatus());
    } else {
      // For other contexts, just refresh
      await onRefresh(const RefreshEvent(), emit);
    }
  }
}
