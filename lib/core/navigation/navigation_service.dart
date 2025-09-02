import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/navigation/routes/app_routes.dart';
import 'package:flutter_template/core/utils/logger.dart';

/// Service for handling navigation throughout the app
@lazySingleton
class NavigationService {
  NavigationService(this._logger);
  final AppLogger _logger;

  // Global key for accessing navigator without context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to a route
  void go(String route, {Map<String, dynamic>? extra}) {
    _logger.info('Navigation: Going to $route');
    GoRouter.of(currentContext!).go(route, extra: extra);
  }

  /// Push a route
  void push(String route, {Map<String, dynamic>? extra}) {
    _logger.info('Navigation: Pushing $route');
    GoRouter.of(currentContext!).push(route, extra: extra);
  }

  /// Pop current route
  void pop<T>([T? result]) {
    _logger.info('Navigation: Popping current route');
    if (GoRouter.of(currentContext!).canPop()) {
      GoRouter.of(currentContext!).pop(result);
    } else {
      // If can't pop, go to home
      go(AppRoutes.home);
    }
  }

  /// Replace current route
  void replace(String route, {Map<String, dynamic>? extra}) {
    _logger.info('Navigation: Replacing with $route');
    GoRouter.of(currentContext!).pushReplacement(route, extra: extra);
  }

  /// Clear stack and go to route
  void goAndClearStack(String route, {Map<String, dynamic>? extra}) {
    _logger.info('Navigation: Going to $route and clearing stack');
    while (GoRouter.of(currentContext!).canPop()) {
      GoRouter.of(currentContext!).pop();
    }
    go(route, extra: extra);
  }

  /// Navigate to login
  void goToLogin({String? redirectRoute}) {
    final route = redirectRoute != null
        ? '${AppRoutes.login}?redirect=${Uri.encodeComponent(redirectRoute)}'
        : AppRoutes.login;
    go(route);
  }

  /// Navigate to home (after successful auth)
  void goToHome() {
    goAndClearStack(AppRoutes.home);
  }

  /// Navigate to profile
  void goToProfile() {
    go(AppRoutes.profile);
  }

  /// Navigate to settings
  void goToSettings() {
    go(AppRoutes.settings);
  }

  /// Navigate to register
  void goToRegister() {
    go(AppRoutes.register);
  }

  /// Navigate to forgot password
  void goToForgotPassword() {
    go(AppRoutes.forgotPassword);
  }

  /// Navigate back or to fallback route
  void goBackOrTo(String fallbackRoute) {
    if (GoRouter.of(currentContext!).canPop()) {
      pop<void>();
    } else {
      go(fallbackRoute);
    }
  }

  /// Show error page
  void showError({String? message, String? code}) {
    const route = AppRoutes.error;
    final extra = <String, dynamic>{
      if (message != null) 'message': message,
      if (code != null) 'code': code,
    };
    go(route, extra: extra);
  }

  /// Show not found page
  void showNotFound() {
    go(AppRoutes.notFound);
  }

  /// Get current route path
  String get currentRoute {
    final context = currentContext;
    if (context == null) return '/';

    final routerState = GoRouterState.of(context);
    return routerState.fullPath ?? '/';
  }

  /// Check if currently on route
  bool isCurrentRoute(String route) {
    return currentRoute == route;
  }

  /// Show modal bottom sheet
  Future<T?> showModalSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showDragHandle = true,
  }) {
    final context = currentContext;
    if (context == null) return Future.value();

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      builder: (context) => child,
    );
  }

  /// Show dialog
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    final context = currentContext;
    if (context == null) return Future.value();

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  /// Show snack bar
  void showSnackBar({
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    final context = currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: duration,
      ),
    );
  }

  /// Show success snack bar
  void showSuccessSnackBar(String message) {
    showSnackBar(message: message);
  }

  /// Show error snack bar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message: message,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(currentContext!).hideCurrentSnackBar();
        },
      ),
    );
  }
}
