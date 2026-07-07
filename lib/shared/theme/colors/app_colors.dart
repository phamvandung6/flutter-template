import 'package:flutter/material.dart';

/// Application color schemes following Material Design 3
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primarySeed = Color(0xFF6750A4);
  static const Color secondarySeed = Color(0xFF625B71);
  static const Color tertiarySeed = Color(0xFF7D5260);

  // Light Theme ColorScheme
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeed,
  );

  // Dark Theme ColorScheme
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primarySeed,
    brightness: Brightness.dark,
  );

  // Custom Colors (outside Material 3 system)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Light theme custom colors
  static const Color successLight = Color(0xFFE8F5E8);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Dark theme custom colors
  static const Color successDark = Color(0xFF1B5E20);
  static const Color warningDark = Color(0xFFE65100);
  static const Color infoDark = Color(0xFF0D47A1);

  // Neutral colors for custom usage
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6750A4),
      Color(0xFF8E7CC3),
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF625B71),
      Color(0xFF8A7F8D),
    ],
  );

  // Shadow colors
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);
}

/// Extension to get custom colors from ThemeData
extension AppColorsExtension on ColorScheme {
  Color get success =>
      brightness == Brightness.light ? AppColors.success : AppColors.success;

  Color get successContainer => brightness == Brightness.light
      ? AppColors.successLight
      : AppColors.successDark;

  Color get warning =>
      brightness == Brightness.light ? AppColors.warning : AppColors.warning;

  Color get warningContainer => brightness == Brightness.light
      ? AppColors.warningLight
      : AppColors.warningDark;

  Color get info =>
      brightness == Brightness.light ? AppColors.info : AppColors.info;

  Color get infoContainer =>
      brightness == Brightness.light ? AppColors.infoLight : AppColors.infoDark;
}
