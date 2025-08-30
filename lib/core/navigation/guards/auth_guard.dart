import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/navigation/routes/app_routes.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity_extensions.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_template/features/auth/presentation/bloc/auth_state_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// Guard for protecting authenticated routes
@injectable
class AuthGuard {
  AuthGuard(this._logger);
  final AppLogger _logger;

  /// Check if user can access the route
  String? checkAccess(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    _logger
      ..debug('AuthGuard: Checking access to ${state.fullPath}')
      ..debug('AuthGuard: User authenticated: ${authState.isAuthenticated}');

    // Allow access to public routes
    if (AppRoutes.isPublicRoute(state.fullPath ?? '')) {
      _logger.debug('AuthGuard: Public route, access granted');
      return null;
    }

    // Check authentication for protected routes
    if (!authState.isAuthenticated) {
      _logger.info(
        'AuthGuard: Unauthenticated access attempt to ${state.fullPath}',
      );

      // Store intended route for redirect after login
      final intendedRoute = state.fullPath ?? AppRoutes.home;
      final loginRoute =
          '${AppRoutes.login}?redirect=${Uri.encodeComponent(intendedRoute)}';

      return loginRoute;
    }

    // Check if user is active
    if (authState.user?.isActive != true) {
      _logger.warning(
        'AuthGuard: Inactive user attempting access to ${state.fullPath}',
      );
      return AppRoutes.error;
    }

    _logger.debug('AuthGuard: Access granted to ${state.fullPath}');
    return null;
  }

  /// Check role-based access
  String? checkRoleAccess(
    BuildContext context,
    GoRouterState state,
    List<String> requiredRoles,
  ) {
    // First check basic authentication
    final basicCheck = checkAccess(context, state);
    if (basicCheck != null) return basicCheck;

    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    // Check if user has required roles
    if (requiredRoles.isNotEmpty && authState.user != null) {
      final hasRequiredRole = authState.user!.hasAnyRole(requiredRoles);

      if (!hasRequiredRole) {
        _logger.warning(
          'AuthGuard: User ${authState.user!.email} lacks required roles $requiredRoles for ${state.fullPath}',
        );
        return AppRoutes.error;
      }
    }

    return null;
  }

  /// Check admin access
  String? checkAdminAccess(BuildContext context, GoRouterState state) {
    return checkRoleAccess(context, state, ['admin', 'super_admin']);
  }
}

/// Extension for easy auth guard usage
extension AuthGuardExtension on GoRouterState {
  /// Get redirect parameter from query
  String? get redirectParam => uri.queryParameters['redirect'];

  /// Get intended route after successful auth
  String get intendedRoute => redirectParam ?? AppRoutes.home;
}
