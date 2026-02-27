import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete_rounded, color: theme.colorScheme.onError),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isUnread
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
                : null,
            border: Border(
              left: BorderSide(
                color: isUnread
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconColor(theme).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _icon,
                  size: 20,
                  color: _iconColor(theme),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(notification.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, left: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _icon {
    switch (notification.notificationType) {
      case 'ORDER_PLACED':
        return Icons.receipt_long_rounded;
      case 'ORDER_CONFIRMED':
        return Icons.check_circle_rounded;
      case 'ORDER_SHIPPED':
        return Icons.local_shipping_rounded;
      case 'ORDER_DELIVERED':
        return Icons.inventory_2_rounded;
      case 'ORDER_CANCELLED':
        return Icons.cancel_rounded;
      case 'PAYMENT_SUCCESS':
        return Icons.payment_rounded;
      case 'PAYMENT_FAILED':
        return Icons.error_rounded;
      case 'PROMOTIONAL':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _iconColor(ThemeData theme) {
    switch (notification.notificationType) {
      case 'ORDER_PLACED':
        return Colors.blue;
      case 'ORDER_CONFIRMED':
        return Colors.green;
      case 'ORDER_SHIPPED':
        return Colors.orange;
      case 'ORDER_DELIVERED':
        return Colors.teal;
      case 'ORDER_CANCELLED':
        return Colors.red;
      case 'PAYMENT_SUCCESS':
        return Colors.green;
      case 'PAYMENT_FAILED':
        return Colors.red;
      case 'PROMOTIONAL':
        return Colors.purple;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, y').format(dateTime);
  }
}
