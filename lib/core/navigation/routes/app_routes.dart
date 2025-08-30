/// Application route paths and names
class AppRoutes {
  AppRoutes._();

  // Root routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';

  // Settings routes
  static const String settings = '/settings';
  static const String settingsTheme = '/settings/theme';
  static const String settingsLanguage = '/settings/language';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsPrivacy = '/settings/privacy';
  static const String settingsAbout = '/settings/about';

  // Error routes
  static const String notFound = '/404';
  static const String error = '/error';

  // Get all route paths for validation
  static List<String> get allRoutes => [
        splash,
        onboarding,
        home,
        login,
        register,
        forgotPassword,
        resetPassword,
        verifyEmail,
        profile,
        editProfile,
        changePassword,
        settings,
        settingsTheme,
        settingsLanguage,
        settingsNotifications,
        settingsPrivacy,
        settingsAbout,
        notFound,
        error,
      ];

  // Route names for analytics and debugging
  static const Map<String, String> routeNames = {
    splash: 'Splash',
    onboarding: 'Onboarding',
    home: 'Home',
    login: 'Login',
    register: 'Register',
    forgotPassword: 'Forgot Password',
    resetPassword: 'Reset Password',
    verifyEmail: 'Verify Email',
    profile: 'Profile',
    editProfile: 'Edit Profile',
    changePassword: 'Change Password',
    settings: 'Settings',
    settingsTheme: 'Theme Settings',
    settingsLanguage: 'Language Settings',
    settingsNotifications: 'Notification Settings',
    settingsPrivacy: 'Privacy Settings',
    settingsAbout: 'About',
    notFound: 'Page Not Found',
    error: 'Error',
  };

  /// Get route name for display
  static String getRouteName(String route) {
    return routeNames[route] ?? 'Unknown';
  }

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    const authRequiredRoutes = [
      home,
      profile,
      editProfile,
      changePassword,
      settings,
      settingsTheme,
      settingsLanguage,
      settingsNotifications,
      settingsPrivacy,
      settingsAbout,
    ];
    return authRequiredRoutes.contains(route);
  }

  /// Check if route is public (no auth required)
  static bool isPublicRoute(String route) {
    return !requiresAuth(route);
  }

  /// Get redirect route for unauthenticated users
  static String getAuthRedirect(String intendedRoute) {
    if (requiresAuth(intendedRoute)) {
      return '$login?redirect=${Uri.encodeComponent(intendedRoute)}';
    }
    return intendedRoute;
  }
}
