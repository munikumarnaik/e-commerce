import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../domain/models/order_model.dart';
import '../providers/order_provider.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderListProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context, ) {
    final state = ref.watch(orderListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(OrderListState state, ThemeData theme) {
    switch (state.status) {
      case OrderListStatus.initial:
      case OrderListStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case OrderListStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.error.withValues(alpha: 0.6)),
              const SizedBox(height: AppDimensions.md),
              Text('Failed to load orders',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: AppDimensions.sm),
              CustomButton(
                label: 'Retry',
                onPressed: () =>
                    ref.read(orderListProvider.notifier).loadOrders(),
                fullWidth: false,
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        );

      case OrderListStatus.loaded:
        if (state.orders.isEmpty) {
          return EmptyStateWidget(
            title: 'No orders yet',
            subtitle: 'Your order history will appear here.',
            icon: Icons.receipt_long_outlined,
            actionLabel: 'Start Shopping',
            onAction: () => context.go('/home'),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(orderListProvider.notifier).loadOrders(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.md),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppDimensions.sm),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return _OrderCard(
                order: order,
                onTap: () => context.push('/orders/${order.orderNumber}'),
              );
            },
          ),
        );
    }
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusColor = _getStatusColor(order.status, theme);
    final dateStr = _formatDate(order.createdAt);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.orderNumber}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      order.statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),

              // Date & items count
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Icon(Icons.shopping_bag_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${order.itemsCount} item${order.itemsCount != 1 ? 's' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),

              // Total & payment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\u20B9${order.total}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        order.paymentMethod == 'COD'
                            ? Icons.money_rounded
                            : Icons.account_balance_wallet_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.paymentMethod == 'COD'
                            ? 'Cash on Delivery'
                            : 'Online',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
