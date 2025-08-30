import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_template/core/navigation/routes/app_routes.dart';

/// Extensions for GoRouter to provide convenient navigation methods
extension GoRouterExtension on GoRouter {
  /// Navigate to login with optional redirect
  void goToLogin({String? redirectRoute}) {
    final route = redirectRoute != null
        ? '${AppRoutes.login}?redirect=${Uri.encodeComponent(redirectRoute)}'
        : AppRoutes.login;
    go(route);
  }

  /// Navigate to home and clear stack
  void goToHome() {
    go(AppRoutes.home);
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

  /// Navigate back or to fallback route
  void goBackOrTo(String fallbackRoute) {
    if (canPop()) {
      pop();
    } else {
      go(fallbackRoute);
    }
  }

  /// Show error page
  void showError({String? message, String? code}) {
    final extra = <String, dynamic>{
      if (message != null) 'message': message,
      if (code != null) 'code': code,
    };
    go(AppRoutes.error, extra: extra);
  }
}

/// Extensions for BuildContext to provide convenient navigation
extension NavigationExtension on BuildContext {
  /// Get GoRouter instance
  GoRouter get router => GoRouter.of(this);

  /// Navigate to route
  void goTo(String route, {Map<String, dynamic>? extra}) {
    go(route, extra: extra);
  }

  /// Push route
  void pushTo(String route, {Map<String, dynamic>? extra}) {
    push(route, extra: extra);
  }

  /// Pop current route
  void popRoute<T>([T? result]) {
    if (canPop()) {
      pop(result);
    } else {
      go(AppRoutes.home);
    }
  }

  /// Replace current route
  void replaceTo(String route, {Map<String, dynamic>? extra}) {
    pushReplacement(route, extra: extra);
  }

  /// Navigate to login
  void goToLogin({String? redirectRoute}) {
    router.goToLogin(redirectRoute: redirectRoute);
  }

  /// Navigate to home
  void goToHome() {
    router.goToHome();
  }

  /// Navigate to profile
  void goToProfile() {
    router.goToProfile();
  }

  /// Navigate to settings
  void goToSettings() {
    router.goToSettings();
  }

  /// Navigate to register
  void goToRegister() {
    router.goToRegister();
  }

  /// Go back or to fallback
  void goBackOrTo(String fallbackRoute) {
    router.goBackOrTo(fallbackRoute);
  }

  /// Show error page
  void showError({String? message, String? code}) {
    router.showError(message: message, code: code);
  }

  /// Show not found page
  void showNotFound() {
    go(AppRoutes.notFound);
  }

  /// Get current route path
  String get currentRoute {
    final routerState = GoRouterState.of(this);
    return routerState.fullPath ?? '/';
  }

  /// Check if currently on route
  bool isCurrentRoute(String route) {
    return currentRoute == route;
  }

  /// Get route parameters
  Map<String, String> get routeParams {
    final routerState = GoRouterState.of(this);
    return routerState.pathParameters;
  }

  /// Get query parameters
  Map<String, String> get queryParams {
    final routerState = GoRouterState.of(this);
    return routerState.uri.queryParameters;
  }

  /// Get extra data
  Object? get routeExtra {
    final routerState = GoRouterState.of(this);
    return routerState.extra;
  }
}
