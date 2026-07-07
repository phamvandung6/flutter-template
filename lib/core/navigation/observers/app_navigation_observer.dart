import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/navigation/routes/app_routes.dart';
import 'package:flutter_template/core/utils/logger.dart';

/// Custom navigation observer for logging and analytics
@injectable
class AppNavigationObserver extends NavigatorObserver {
  AppNavigationObserver(this._logger);
  final AppLogger _logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    final routeName = route.settings.name;
    final previousRouteName = previousRoute?.settings.name;

    _logger.info(
      'Navigation: Pushed ${AppRoutes.getRouteName(routeName ?? 'Unknown')} '
      'from ${AppRoutes.getRouteName(previousRouteName ?? 'Unknown')}',
    );

    // Here you can add analytics tracking
    _trackScreenView(routeName);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    final routeName = route.settings.name;
    final previousRouteName = previousRoute?.settings.name;

    _logger.info(
      'Navigation: Popped ${AppRoutes.getRouteName(routeName ?? 'Unknown')} '
      'back to ${AppRoutes.getRouteName(previousRouteName ?? 'Unknown')}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    final newRouteName = newRoute?.settings.name;
    final oldRouteName = oldRoute?.settings.name;

    _logger.info(
      'Navigation: Replaced ${AppRoutes.getRouteName(oldRouteName ?? 'Unknown')} '
      'with ${AppRoutes.getRouteName(newRouteName ?? 'Unknown')}',
    );

    // Track the new screen
    _trackScreenView(newRouteName);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    final routeName = route.settings.name;
    final previousRouteName = previousRoute?.settings.name;

    _logger.info(
      'Navigation: Removed ${AppRoutes.getRouteName(routeName ?? 'Unknown')} '
      'previous: ${AppRoutes.getRouteName(previousRouteName ?? 'Unknown')}',
    );
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);

    _logger.debug('Navigation: User gesture started on ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();

    _logger.debug('Navigation: User gesture stopped');
  }

  /// Track screen view for analytics
  void _trackScreenView(String? routeName) {
    if (routeName == null) return;

    // Here you can integrate with analytics services like:
    // - Firebase Analytics
    // - Google Analytics
    // - Custom analytics

    _logger.debug('Analytics: Screen view tracked for $routeName');

    // Example implementation:
    // FirebaseAnalytics.instance.logScreenView(
    //   screenName: routeName,
    //   screenClass: AppRoutes.getRouteName(routeName),
    // );
  }
}

/// Custom route information for better tracking
class AppRouteInformation {
  AppRouteInformation({
    required this.path,
    required this.name,
    required this.parameters,
    required this.timestamp,
  });
  final String path;
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  @override
  String toString() {
    return 'AppRouteInformation(path: $path, name: $name, parameters: $parameters, timestamp: $timestamp)';
  }
}
