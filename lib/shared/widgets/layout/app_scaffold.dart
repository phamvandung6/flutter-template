import 'package:flutter/material.dart';

import '../../utils/responsive.dart';

/// Custom scaffold with responsive layout and common functionality
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool addSafeArea;
  final bool addPadding;
  final EdgeInsets? padding;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.addSafeArea = true,
    this.addPadding = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Build effective app bar
    PreferredSizeWidget? effectiveAppBar = appBar;
    if (effectiveAppBar == null && title != null) {
      effectiveAppBar = AppBar(
        title: Text(title!),
      );
    }

    // Build body with optional padding and safe area
    Widget effectiveBody = body;

    if (addPadding) {
      final effectivePadding = padding ?? context.responsivePadding;
      effectiveBody = Padding(
        padding: effectivePadding,
        child: effectiveBody,
      );
    }

    if (addSafeArea) {
      effectiveBody = SafeArea(child: effectiveBody);
    }

    return Scaffold(
      appBar: effectiveAppBar,
      body: effectiveBody,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
    );
  }
}

/// Centered content scaffold for forms and simple layouts
class AppCenteredScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final PreferredSizeWidget? appBar;
  final double maxWidth;
  final bool addPadding;
  final EdgeInsets? padding;

  const AppCenteredScaffold({
    super.key,
    required this.child,
    this.title,
    this.appBar,
    this.maxWidth = 400,
    this.addPadding = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? context.responsivePadding;

    return AppScaffold(
      title: title,
      appBar: appBar,
      addPadding: false,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: addPadding
              ? Padding(
                  padding: effectivePadding,
                  child: child,
                )
              : child,
        ),
      ),
    );
  }
}

/// Loading scaffold for async operations
class AppLoadingScaffold extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? loadingWidget;

  const AppLoadingScaffold({
    super.key,
    this.title,
    this.message,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingWidget ?? const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error scaffold for error states
class AppErrorScaffold extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final Widget? errorWidget;

  const AppErrorScaffold({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorWidget ??
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: colorScheme.error,
                ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
