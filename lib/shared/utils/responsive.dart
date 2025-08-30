import 'package:flutter/material.dart';

/// Responsive design utilities for different screen sizes
class Responsive {
  Responsive._();

  // Breakpoints following Material Design guidelines
  static const double mobileMaxWidth = 599;
  static const double tabletMaxWidth = 1239;
  static const double desktopMaxWidth = 1919;

  /// Check if screen is mobile size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobileMaxWidth;
  }

  /// Check if screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobileMaxWidth && width <= tabletMaxWidth;
  }

  /// Check if screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > tabletMaxWidth;
  }

  /// Get responsive value based on screen size
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(
      responsiveValue(
        context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
    );
  }

  /// Get responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return EdgeInsets.all(
      responsiveValue(
        context,
        mobile: 8.0,
        tablet: 12.0,
        desktop: 16.0,
      ),
    );
  }

  /// Get responsive font size multiplier
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final multiplier = responsiveValue(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
    return baseSize * multiplier;
  }

  /// Get responsive icon size
  static double responsiveIconSize(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  /// Get responsive card width
  static double responsiveCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isMobile(context)) {
      return screenWidth - 32; // Full width with margin
    } else if (isTablet(context)) {
      return screenWidth * 0.7; // 70% of screen width
    } else {
      return 400; // Fixed width for desktop
    }
  }

  /// Get responsive grid columns
  static int responsiveGridColumns(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }
}

/// Extension for easy responsive access
extension ResponsiveExtension on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);

  EdgeInsets get responsivePadding => Responsive.responsivePadding(this);
  EdgeInsets get responsiveMargin => Responsive.responsiveMargin(this);

  double responsiveFontSize(double baseSize) =>
      Responsive.responsiveFontSize(this, baseSize);

  double get responsiveIconSize => Responsive.responsiveIconSize(this);
  double get responsiveCardWidth => Responsive.responsiveCardWidth(this);
  int get responsiveGridColumns => Responsive.responsiveGridColumns(this);

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      Responsive.responsiveValue(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
