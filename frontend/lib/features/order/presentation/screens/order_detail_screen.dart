import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/models/order_model.dart';
import '../providers/order_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderNumber;

  const OrderDetailScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderNumber));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #$orderNumber'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy order number',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: orderNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order number copied'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: orderAsync.when(
        data: (order) => _buildContent(context, ref, order, theme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.error.withValues(alpha: 0.6)),
              const SizedBox(height: AppDimensions.md),
              Text('Failed to load order',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: AppDimensions.sm),
              CustomButton(
                label: 'Retry',
                onPressed: () =>
                    ref.invalidate(orderDetailProvider(orderNumber)),
                fullWidth: false,
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Order order,
    ThemeData theme,
  ) {
    final statusColor = _getStatusColor(order.status, theme);

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.md),
      children: [
        // Status card
        Card(
          color: statusColor.withValues(alpha: 0.08),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                Icon(_getStatusIcon(order.status),
                    color: statusColor, size: 28),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.statusLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      if (order.createdAt != null)
                        Text(
                          'Placed on ${_formatDate(order.createdAt!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // Status Timeline
        if (order.statusHistory.isNotEmpty) ...[
          Text('Order Timeline',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.sm),
          _StatusTimeline(history: order.statusHistory),
          const SizedBox(height: AppDimensions.md),
        ],

        // Items
        Text('Items (${order.items.length})',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppDimensions.sm),
        ...order.items.map((item) => _OrderItemTile(item: item)),
        const SizedBox(height: AppDimensions.md),

        // Shipping address
        if (order.shippingAddress != null) ...[
          Text('Shipping Address',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.sm),
          _ShippingAddressCard(address: order.shippingAddress!),
          const SizedBox(height: AppDimensions.md),
        ],

        // Price summary
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Details',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppDimensions.sm),
                _PriceRow(
                    label: 'Payment Method',
                    value: order.paymentMethod == 'COD'
                        ? 'Cash on Delivery'
                        : 'Online'),
                const Divider(),
                _PriceRow(label: 'Subtotal', value: '\u20B9${order.subtotal}'),
                if (order.discountValue > 0)
                  _PriceRow(
                    label: 'Discount',
                    value: '-\u20B9${order.discount}',
                    isGreen: true,
                  ),
                if (order.couponCode != null)
                  _PriceRow(
                    label: 'Coupon (${order.couponCode})',
                    value: 'Applied',
                    isGreen: true,
                  ),
                _PriceRow(
                    label: 'Delivery Fee',
                    value: '\u20B9${order.deliveryFee}'),
                _PriceRow(label: 'Tax', value: '\u20B9${order.tax}'),
                const Divider(),
                _PriceRow(
                  label: 'Total',
                  value: '\u20B9${order.total}',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // Customer note
        if (order.customerNote != null &&
            order.customerNote!.isNotEmpty) ...[
          Text('Your Note',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.sm),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Text(
                order.customerNote!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
        ],

        // ── Track order (for active orders) ──
        if (_isTrackable(order.status)) ...[
          CustomButton(
            label: 'Track Order',
            onPressed: () => context.push(
              '/orders/${order.orderNumber}/track',
            ),
            icon: Icons.location_on_rounded,
          ),
          const SizedBox(height: AppDimensions.sm),
        ],

        // ── Reorder (for delivered/cancelled) ──
        if (order.status == 'DELIVERED' || order.status == 'CANCELLED') ...[
          CustomButton(
            label: 'Reorder',
            onPressed: () => _handleReorder(context, ref, order),
            variant: ButtonVariant.outlined,
            icon: Icons.replay_rounded,
          ),
          const SizedBox(height: AppDimensions.sm),
        ],

        // ── Cancel button ──
        if (order.canCancel) ...[
          CustomButton(
            label: 'Cancel Order',
            onPressed: () => _showCancelDialog(context, ref, order),
            variant: ButtonVariant.outlined,
            icon: Icons.cancel_outlined,
          ),
          const SizedBox(height: AppDimensions.md),
        ],

        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }

  bool _isTrackable(String status) {
    const trackable = {
      'CONFIRMED', 'PROCESSING', 'SHIPPED', 'OUT_FOR_DELIVERY',
    };
    return trackable.contains(status);
  }

  Future<void> _handleReorder(
      BuildContext context, WidgetRef ref, Order order) async {
    final result = await ref
        .read(orderListProvider.notifier)
        .reorder(order.orderNumber);
    if (!context.mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] as String? ?? 'Items added to cart.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/cart');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to reorder. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCancelDialog(
      BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
            'Are you sure you want to cancel this order? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(orderListProvider.notifier)
                  .cancelOrder(order.orderNumber);
              if (success && context.mounted) {
                ref.invalidate(orderDetailProvider(orderNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order cancelled'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text('Cancel Order',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    return switch (status) {
      'PENDING' => Colors.orange,
      'CONFIRMED' => Colors.blue,
      'PROCESSING' => Colors.indigo,
      'SHIPPED' => Colors.purple,
      'OUT_FOR_DELIVERY' => Colors.teal,
      'DELIVERED' => Colors.green,
      'CANCELLED' => Colors.red,
      _ => theme.colorScheme.onSurfaceVariant,
    };
  }

  IconData _getStatusIcon(String status) {
    return switch (status) {
      'PENDING' => Icons.access_time_rounded,
      'CONFIRMED' => Icons.check_circle_outline_rounded,
      'PROCESSING' => Icons.inventory_2_outlined,
      'SHIPPED' => Icons.local_shipping_outlined,
      'OUT_FOR_DELIVERY' => Icons.delivery_dining_rounded,
      'DELIVERED' => Icons.check_circle_rounded,
      'CANCELLED' => Icons.cancel_rounded,
      _ => Icons.info_outline_rounded,
    };
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ───── Helper Widgets ─────

class _StatusTimeline extends StatelessWidget {
  final List<OrderStatusHistory> history;

  const _StatusTimeline({required this.history});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: List.generate(history.length, (index) {
        final entry = history[index];
        final isLast = index == history.length - 1;
        final statusLabel = _statusToLabel(entry.status);
        final dateStr = _formatShort(entry.createdAt);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot + line
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLast
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isLast ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (dateStr.isNotEmpty)
                        Text(
                          dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      if (entry.note != null && entry.note!.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 2),
                          child: Text(
                            entry.note!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _statusToLabel(String status) {
    return switch (status) {
      'PENDING' => 'Order Placed',
      'CONFIRMED' => 'Order Confirmed',
      'PROCESSING' => 'Processing',
      'SHIPPED' => 'Shipped',
      'OUT_FOR_DELIVERY' => 'Out for Delivery',
      'DELIVERED' => 'Delivered',
      'CANCELLED' => 'Cancelled',
      _ => status,
    };
  }

  String _formatShort(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM, hh:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: item.productThumbnail != null
                ? Image.network(
                    item.productThumbnail!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(theme),
                  )
                : _placeholder(theme),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                if (item.variantSize != null || item.variantColor != null)
                  Text(
                    [
                      if (item.variantSize != null && item.variantSize!.isNotEmpty) item.variantSize!,
                      if (item.variantColor != null && item.variantColor!.isNotEmpty) item.variantColor!,
                    ].join(' / '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                Text(
                  'Qty: ${item.quantity}  ×  \u20B9${item.price}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\u20B9${item.total}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      color: theme.colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.shopping_bag_outlined, size: 24),
    );
  }
}

class _ShippingAddressCard extends StatelessWidget {
  final Map<String, dynamic> address;

  const _ShippingAddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = address['full_name'] ?? '';
    final line1 = address['address_line1'] ?? '';
    final line2 = address['address_line2'] ?? '';
    final city = address['city'] ?? '';
    final state = address['state'] ?? '';
    final postalCode = address['postal_code'] ?? '';
    final phone = address['phone'] ?? '';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fullName,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              '$line1${line2.isNotEmpty ? '\n$line2' : ''}\n$city, $state $postalCode',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            if (phone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                phone,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isGreen;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isBold
                ? theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium?.copyWith(
                    color: isGreen ? Colors.green.shade700 : null,
                    fontWeight: isGreen ? FontWeight.w600 : null,
                  ),
          ),
        ],
      ),
    );
  }
}
