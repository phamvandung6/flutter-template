import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart';

import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/shared/presentation/bloc/base_bloc_state.dart';
import 'package:flutter_template/shared/presentation/cubit/base_cubit.dart';

/// Theme mode options
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Theme state data
class AppThemeData {
  const AppThemeData({
    required this.mode,
    required this.isDark,
  });
  final AppThemeMode mode;
  final bool isDark;
}

/// Cubit for managing app theme
@injectable
class ThemeCubit extends BaseCubit<AppThemeData> {
  ThemeCubit(AppLogger logger)
      : super(
          const BaseBlocState<AppThemeData>(
            status: BlocStatus.success,
            data: AppThemeData(
              mode: AppThemeMode.system,
              isDark: false,
            ),
          ),
          logger,
        );

  /// Set theme mode
  void setThemeMode(AppThemeMode mode) {
    final brightness = _getBrightness(mode);
    final isDark = brightness == Brightness.dark;

    emitSuccess(
      AppThemeData(mode: mode, isDark: isDark),
      message: 'Theme changed to ${mode.name}',
    );
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    final currentIsDark = state.data?.isDark ?? false;

    final newMode = currentIsDark ? AppThemeMode.light : AppThemeMode.dark;
    setThemeMode(newMode);
  }

  /// Set light theme
  void setLightTheme() => setThemeMode(AppThemeMode.light);

  /// Set dark theme
  void setDarkTheme() => setThemeMode(AppThemeMode.dark);

  /// Set system theme
  void setSystemTheme() => setThemeMode(AppThemeMode.system);

  /// Get brightness based on theme mode and system settings
  Brightness _getBrightness(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        // In a real app, you'd get this from MediaQuery or system settings
        // For now, default to light
        return Brightness.light;
    }
  }
}

/// Extension for easy theme access
extension ThemeCubitExtension on ThemeCubit {
  /// Get current theme mode
  AppThemeMode get currentMode => state.data?.mode ?? AppThemeMode.system;

  /// Check if current theme is dark
  bool get isDark => state.data?.isDark ?? false;

  /// Check if current theme is light
  bool get isLight => !isDark;

  /// Get theme mode display name
  String get themeModeDisplayName {
    switch (currentMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
}
