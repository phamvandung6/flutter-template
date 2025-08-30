import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_template/features/error/presentation/pages/error_page.dart';
import 'package:flutter_template/features/error/presentation/pages/not_found_page.dart';
import 'package:flutter_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_template/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_template/shared/widgets/widgets.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/core/navigation/guards/auth_guard.dart';
import 'package:flutter_template/core/navigation/navigation_service.dart';
import 'package:flutter_template/core/navigation/observers/app_navigation_observer.dart';
import 'package:flutter_template/core/navigation/routes/app_routes.dart';

/// Application router configuration using GoRouter
@injectable
class AppRouter {

  AppRouter(
    this._authGuard,
    this._navigationObserver,
    this._logger,
  );
  final AuthGuard _authGuard;
  final AppNavigationObserver _navigationObserver;
  final AppLogger _logger;

  /// Create and configure GoRouter instance
  GoRouter createRouter(BuildContext context) {
    return GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      initialLocation: AppRoutes.splash,
      observers: [_navigationObserver],
      debugLogDiagnostics: true,

      // Global redirect logic
      redirect: _authGuard.checkAccess,

      // Error handling
      errorBuilder: (context, state) {
        _logger.error('Router error: ${state.error}');
        return const ErrorPage(
          message: 'Navigation error occurred',
          code: 'ROUTER_ERROR',
        );
      },

      routes: [
        // Splash route
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),

        // Authentication routes
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: _buildLoginPage,
        ),

        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: _buildRegisterPage,
        ),

        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgot-password',
          builder: _buildForgotPasswordPage,
        ),

        // Main app routes
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        // Profile routes
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: _buildProfilePage,
          routes: [
            GoRoute(
              path: '/edit',
              name: 'edit-profile',
              builder: _buildEditProfilePage,
            ),
            GoRoute(
              path: '/change-password',
              name: 'change-password',
              builder: _buildChangePasswordPage,
            ),
          ],
        ),

        // Settings routes
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: _buildSettingsPage,
          routes: [
            GoRoute(
              path: '/theme',
              name: 'settings-theme',
              builder: _buildThemeSettingsPage,
            ),
            GoRoute(
              path: '/language',
              name: 'settings-language',
              builder: _buildLanguageSettingsPage,
            ),
            GoRoute(
              path: '/notifications',
              name: 'settings-notifications',
              builder: _buildNotificationSettingsPage,
            ),
            GoRoute(
              path: '/privacy',
              name: 'settings-privacy',
              builder: _buildPrivacySettingsPage,
            ),
            GoRoute(
              path: '/about',
              name: 'settings-about',
              builder: _buildAboutPage,
            ),
          ],
        ),

        // Error routes
        GoRoute(
          path: AppRoutes.error,
          name: 'error',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ErrorPage(
              message: extra?['message'] as String?,
              code: extra?['code'] as String?,
            );
          },
        ),

        GoRoute(
          path: AppRoutes.notFound,
          name: 'not-found',
          builder: (context, state) => const NotFoundPage(),
        ),
      ],
    );
  }

  // Placeholder page builders (will be implemented in future tasks)
  Widget _buildLoginPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Login Page',
      'Authentication login form will be implemented here',
      Icons.login,
    );
  }

  Widget _buildRegisterPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Register Page',
      'User registration form will be implemented here',
      Icons.person_add,
    );
  }

  Widget _buildForgotPasswordPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Forgot Password',
      'Password recovery form will be implemented here',
      Icons.lock_reset,
    );
  }

  Widget _buildProfilePage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Profile Page',
      'User profile display will be implemented here',
      Icons.person,
    );
  }

  Widget _buildEditProfilePage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Edit Profile',
      'Profile editing form will be implemented here',
      Icons.edit,
    );
  }

  Widget _buildChangePasswordPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Change Password',
      'Password change form will be implemented here',
      Icons.lock,
    );
  }

  Widget _buildSettingsPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Settings',
      'App settings and preferences will be implemented here',
      Icons.settings,
    );
  }

  Widget _buildThemeSettingsPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Theme Settings',
      'Theme customization options will be implemented here',
      Icons.palette,
    );
  }

  Widget _buildLanguageSettingsPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Language Settings',
      'Language selection will be implemented here',
      Icons.language,
    );
  }

  Widget _buildNotificationSettingsPage(
      BuildContext context, GoRouterState state,) {
    return _buildPlaceholderPage(
      context,
      'Notification Settings',
      'Notification preferences will be implemented here',
      Icons.notifications,
    );
  }

  Widget _buildPrivacySettingsPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'Privacy Settings',
      'Privacy and security options will be implemented here',
      Icons.privacy_tip,
    );
  }

  Widget _buildAboutPage(BuildContext context, GoRouterState state) {
    return _buildPlaceholderPage(
      context,
      'About',
      'App information and credits will be implemented here',
      Icons.info,
    );
  }

  /// Build placeholder page for routes not yet implemented
  Widget _buildPlaceholderPage(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton.outlined(
                text: 'Go Back',
                icon: Icons.arrow_back,
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
