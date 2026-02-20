import 'package:flutter/material.dart';

import '../providers/admin_stats_provider.dart';

class DashboardProductsCard extends StatelessWidget {
  final AdminStats stats;

  const DashboardProductsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Products Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${stats.totalProducts}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Active Products',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status Indicators
          Row(
            children: [
              Expanded(
                child: _StatusIndicator(
                  label: 'Out of Stock',
                  value: stats.outOfStock,
                  icon: Icons.remove_shopping_cart_rounded,
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusIndicator(
                  label: 'Low Stock',
                  value: stats.lowStock,
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusIndicator(
                  label: 'Completed',
                  value: stats.completedOrders,
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Gradient Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product Type Breakdown
          _ProductTypeRow(
            icon: Icons.restaurant_rounded,
            label: 'Food Products',
            count: stats.foodProducts,
            total: stats.totalProducts,
            color: const Color(0xFFF97316),
          ),
          const SizedBox(height: 12),
          _ProductTypeRow(
            icon: Icons.checkroom_rounded,
            label: 'Clothing Products',
            count: stats.clothingProducts,
            total: stats.totalProducts,
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

// ── Status Indicator Tile ──

class _StatusIndicator extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatusIndicator({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Product Type Row with Progress Bar ──

class _ProductTypeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final int total;
  final Color color;

  const _ProductTypeRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$count',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
