import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/domain/models/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePlaceholderScreen extends ConsumerWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    final user = authState is AuthAuthenticated ? authState.user : null;
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Profile'))),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user != null && user.firstName.isNotEmpty
                    ? user.firstName[0].toUpperCase()
                    : 'G',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Center(
            child: Text(
              user != null ? '${user.firstName} ${user.lastName}' : 'Guest',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (user?.email != null) ...[
            const SizedBox(height: 4),
            Center(
              child: Text(
                user!.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.xl),

          // Menu items
          _ProfileMenuItem(
            icon: Icons.receipt_long_rounded,
            title: 'My Orders',
            subtitle: 'View order history & track orders',
            onTap: () => context.push(RouteNames.orders),
          ),
          _ProfileMenuItem(
            icon: Icons.location_on_rounded,
            title: 'My Addresses',
            subtitle: 'Manage delivery addresses',
            onTap: () => context.push(RouteNames.profileAddresses),
          ),
          _ProfileMenuItem(
            icon: Icons.favorite_rounded,
            title: 'Wishlist',
            subtitle: 'Your saved items',
            onTap: () => context.push(RouteNames.wishlist),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Dark mode toggle
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                'Dark Mode',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isDark
                    ? 'Currently using dark theme'
                    : 'Currently using light theme',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (_) {
                  ref.read(themeModeProvider.notifier).state =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                },
                activeColor: theme.colorScheme.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.lg),

          // Logout button
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context, ref),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(AppStrings.logout),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
            },
            child: Text(
              AppStrings.logout,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}
