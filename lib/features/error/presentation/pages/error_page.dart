import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_template/shared/widgets/widgets.dart';

/// Error page for handling app errors
class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    this.message,
    this.code,
  });
  final String? message;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppErrorScaffold(
      title: 'Error',
      message: message ?? 'An unexpected error occurred',
      onRetry: () {
        // Go back or to home
        context.canPop() ? context.pop() : context.go('/home');
      },
      errorWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          if (code != null) ...[
            const SizedBox(height: 8),
            Text(
              'Error Code: $code',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
