import 'package:flutter/material.dart';

/// Application typography following Material Design 3 type scale
class AppTypography {
  AppTypography._();

  // Font family
  static const String fontFamily = 'Roboto';

  // Base text theme using Material 3 type scale
  static const TextTheme baseTextTheme = TextTheme(
    // Display styles - large, high-emphasis text
    displayLarge: TextStyle(
      fontSize: 57,
      height: 1.12,
      letterSpacing: -0.25,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      height: 1.16,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      height: 1.22,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),

    // Headline styles - high-emphasis, shorter text
    headlineLarge: TextStyle(
      fontSize: 32,
      height: 1.25,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      height: 1.29,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 1.33,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),

    // Title styles - medium-emphasis text
    titleLarge: TextStyle(
      fontSize: 22,
      height: 1.27,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      height: 1.50,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    ),

    // Label styles - text for components
    labelLarge: TextStyle(
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 1.45,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
    ),

    // Body styles - body text
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.50,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.43,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
    ),
  );

  // Custom text styles for specific use cases
  static const TextStyle button = TextStyle(
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    height: 1.6,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w500,
  );

  // Error text styles
  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  // Helper text styles
  static const TextStyle helperText = TextStyle(
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );
}

/// Extension to provide convenient typography access
extension AppTypographyExtension on TextTheme {
  TextStyle get button => AppTypography.button;
  TextStyle get caption => AppTypography.caption;
  TextStyle get overline => AppTypography.overline;
  TextStyle get errorText => AppTypography.errorText;
  TextStyle get helperText => AppTypography.helperText;
}
