import 'package:flutter/material.dart';

import 'package:flutter_template/shared/utils/responsive.dart';

/// Custom button variants for consistent styling
enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  danger,
}

/// Custom button sizes
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Reusable application button with consistent styling
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  });

  /// Primary button constructor
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : variant = AppButtonVariant.primary;

  /// Secondary button constructor
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : variant = AppButtonVariant.secondary;

  /// Outlined button constructor
  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : variant = AppButtonVariant.outlined;

  /// Text button constructor
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : variant = AppButtonVariant.text;

  /// Danger button constructor
  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : variant = AppButtonVariant.danger;
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get size configuration
    final sizeConfig = _getSizeConfig(context);

    // Build button content
    var buttonChild = _buildButtonContent(context);

    // Wrap with loading indicator if needed
    if (isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: sizeConfig.iconSize,
            height: sizeConfig.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getContentColor(colorScheme),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    // Build button based on variant
    var button = _buildButton(context, buttonChild, sizeConfig);

    // Make full width if needed
    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  /// Build button content (text + icon)
  Widget _buildButtonContent(BuildContext context) {
    if (icon != null && !isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getSizeConfig(context).iconSize),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    if (isLoading) {
      return const SizedBox.shrink(); // Content handled in build method
    }

    return Text(text);
  }

  /// Build button widget based on variant
  Widget _buildButton(
    BuildContext context,
    Widget child,
    _ButtonSizeConfig config,
  ) {
    final effectivePadding = padding ?? config.padding;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: effectivePadding,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            textStyle: config.textStyle,
          ),
          child: child,
        );

      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            textStyle: config.textStyle,
          ),
          child: child,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: effectivePadding,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            textStyle: config.textStyle,
          ),
          child: child,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: effectivePadding,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            textStyle: config.textStyle,
          ),
          child: child,
        );

      case AppButtonVariant.danger:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            textStyle: config.textStyle,
          ),
          child: child,
        );
    }
  }

  /// Get size configuration based on button size
  _ButtonSizeConfig _getSizeConfig(BuildContext context) {
    switch (size) {
      case AppButtonSize.small:
        return _ButtonSizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: Theme.of(context).textTheme.labelMedium,
          iconSize: context.responsiveValue(
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        );

      case AppButtonSize.medium:
        return _ButtonSizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: Theme.of(context).textTheme.labelLarge,
          iconSize: context.responsiveValue(
            mobile: 20,
            tablet: 22,
            desktop: 24,
          ),
        );

      case AppButtonSize.large:
        return _ButtonSizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: Theme.of(context).textTheme.titleMedium,
          iconSize: context.responsiveValue(
            mobile: 24,
            tablet: 26,
            desktop: 28,
          ),
        );
    }
  }

  /// Get content color based on variant
  Color _getContentColor(ColorScheme colorScheme) {
    switch (variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return colorScheme.onSecondary;
      case AppButtonVariant.outlined:
        return colorScheme.primary;
      case AppButtonVariant.text:
        return colorScheme.primary;
      case AppButtonVariant.danger:
        return colorScheme.onError;
    }
  }
}

/// Internal configuration class for button sizes
class _ButtonSizeConfig {
  const _ButtonSizeConfig({
    required this.padding,
    required this.textStyle,
    required this.iconSize,
  });
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final double iconSize;
}
