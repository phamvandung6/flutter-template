import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/widgets.dart';

/// 404 Not Found page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Page Not Found',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 120,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              '404',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton.primary(
              text: 'Go Home',
              icon: Icons.home,
              onPressed: () {
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
