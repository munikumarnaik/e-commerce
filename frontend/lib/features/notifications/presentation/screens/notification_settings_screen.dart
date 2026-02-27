import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        children: [
          // Push notifications master toggle
          _SectionHeader(title: 'Push Notifications', theme: theme),
          const SizedBox(height: AppDimensions.sm),
          _ToggleTile(
            icon: Icons.notifications_active_rounded,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications on your device',
            value: _pushEnabled,
            onChanged: (v) => setState(() => _pushEnabled = v),
            theme: theme,
          ),
          const SizedBox(height: AppDimensions.lg),

          // Notification categories
          _SectionHeader(title: 'Notification Categories', theme: theme),
          const SizedBox(height: AppDimensions.sm),
          _ToggleTile(
            icon: Icons.local_shipping_rounded,
            title: 'Order Updates',
            subtitle: 'Order placed, shipped, delivered, cancelled',
            value: _orderUpdates,
            onChanged: _pushEnabled
                ? (v) => setState(() => _orderUpdates = v)
                : null,
            theme: theme,
          ),
          _ToggleTile(
            icon: Icons.local_offer_rounded,
            title: 'Promotions & Offers',
            subtitle: 'Discounts, deals, and special offers',
            value: _promotions,
            onChanged: _pushEnabled
                ? (v) => setState(() => _promotions = v)
                : null,
            theme: theme,
          ),
          const SizedBox(height: AppDimensions.lg),

          // Email notifications
          _SectionHeader(title: 'Email', theme: theme),
          const SizedBox(height: AppDimensions.sm),
          _ToggleTile(
            icon: Icons.email_rounded,
            title: 'Email Notifications',
            subtitle: 'Receive order updates via email',
            value: _emailNotifications,
            onChanged: (v) => setState(() => _emailNotifications = v),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final ThemeData theme;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onChanged != null;

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
        leading: Icon(
          icon,
          color: isEnabled
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isEnabled ? null : theme.colorScheme.outline,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}
