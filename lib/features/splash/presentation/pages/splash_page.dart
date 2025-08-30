import 'package:flutter/material.dart';

import '../../../../shared/widgets/widgets.dart';

/// Splash screen page
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      addPadding: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.flutter_dash,
                  size: 60,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              // App name
              Text(
                'Flutter Template',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // App tagline
              Text(
                'Clean Architecture Base Project',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 48),

              // Loading indicator
              AppLoadingIndicator.pulse(
                color: theme.colorScheme.onPrimary,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
