import 'package:flutter/material.dart';
import 'package:flutter_template/shared/utils/responsive.dart';

/// Card variants for different use cases
enum AppCardVariant {
  elevated,
  filled,
  outlined,
}

/// Reusable card component with consistent styling
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.elevation,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showDivider = false,
  });

  /// Elevated card constructor
  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.elevation,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showDivider = false,
  }) : variant = AppCardVariant.elevated;

  /// Filled card constructor
  const AppCard.filled({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showDivider = false,
  })  : variant = AppCardVariant.filled,
        elevation = 0;

  /// Outlined card constructor
  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showDivider = false,
  })  : variant = AppCardVariant.outlined,
        elevation = 0;
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onTap;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get responsive padding
    final effectivePadding = padding ?? context.responsivePadding;
    final effectiveMargin = margin ?? context.responsiveMargin;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);

    final cardContent = _buildCardContent(context);

    var card = _buildCard(
      context,
      cardContent,
      effectivePadding,
      effectiveBorderRadius,
      colorScheme,
    );

    // Add margin if specified
    if (effectiveMargin != EdgeInsets.zero) {
      card = Padding(
        padding: effectiveMargin,
        child: card,
      );
    }

    // Add tap functionality if specified
    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: card,
      );
    }

    return card;
  }

  /// Build card content with optional header
  Widget _buildCardContent(BuildContext context) {
    final theme = Theme.of(context);

    final content = <Widget>[];

    // Add header if title is provided
    if (title != null) {
      content.add(_buildHeader(context, theme));

      if (showDivider) {
        content.add(const Divider());
      } else {
        content.add(const SizedBox(height: 16));
      }
    }

    // Add main content
    content.add(child);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  }

  /// Build card header with title, subtitle, and icons
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: theme.textTheme.titleMedium,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing!,
        ],
      ],
    );
  }

  /// Build card widget based on variant
  Widget _buildCard(
    BuildContext context,
    Widget content,
    EdgeInsets effectivePadding,
    BorderRadius effectiveBorderRadius,
    ColorScheme colorScheme,
  ) {
    switch (variant) {
      case AppCardVariant.elevated:
        return Card(
          elevation: elevation ?? 1,
          color: backgroundColor ?? colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          child: Padding(
            padding: effectivePadding,
            child: content,
          ),
        );

      case AppCardVariant.filled:
        return Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ??
                colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: effectiveBorderRadius,
          ),
          child: content,
        );

      case AppCardVariant.outlined:
        return Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surface,
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: colorScheme.outline,
            ),
          ),
          child: content,
        );
    }
  }
}

/// Card with built-in loading state
class AppLoadingCard extends StatelessWidget {
  const AppLoadingCard({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.loadingMessage,
  });
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: isLoading
          ? Center(
              child: loadingWidget ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      if (loadingMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          loadingMessage!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
            )
          : child,
    );
  }
}
