import 'package:flutter/material.dart';

import '../../../../shared/widgets/widgets.dart';

/// Home page - main dashboard
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Home',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            AppCard.elevated(
              title: 'Welcome to Flutter Template',
              subtitle: 'Clean Architecture Base Project',
              leading: Icon(
                Icons.home,
                color: theme.colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This is a demonstration of the Clean Architecture Flutter template with:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureList(context),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick actions
            AppCard.outlined(
              title: 'Quick Actions',
              child: Column(
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'View and edit your profile',
                    onTap: () {
                      // Navigate to profile
                    },
                  ),
                  const Divider(),
                  _buildActionButton(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences and configuration',
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  const Divider(),
                  _buildActionButton(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    onTap: () {
                      // Trigger logout
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats card
            AppCard.filled(
              title: 'Template Stats',
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Features',
                      '5+',
                      Icons.featured_play_list,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Packages',
                      '15+',
                      Icons.inventory,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Architecture',
                      'Clean',
                      Icons.architecture,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = [
      '✅ Clean Architecture (Domain/Data/Presentation)',
      '✅ BLoC State Management with Single State',
      '✅ Dependency Injection (GetIt + Injectable)',
      '✅ Network Layer (Dio + Retrofit)',
      '✅ Material Design 3 Theme System',
      '✅ Responsive Design',
      '✅ Go Router Navigation',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            feature,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
