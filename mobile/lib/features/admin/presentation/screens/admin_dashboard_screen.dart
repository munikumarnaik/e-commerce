import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/admin_stats_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(AppStrings.adminDashboard),
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(adminStatsProvider),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const _LoadingGrid(),
        error: (e, _) => _ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(adminStatsProvider),
        ),
        data: (stats) => _DashboardGrid(stats: stats),
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
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
            },
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}

// ───── Dashboard Grid ─────

class _DashboardGrid extends StatelessWidget {
  final AdminStats stats;

  const _DashboardGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger via parent ref — handled by Consumer below
      },
      child: Consumer(
        builder: (context, ref, _) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(adminStatsProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                // Greeting
                _GreetingHeader(stats: stats),
                const SizedBox(height: AppDimensions.lg),

                // Row 1: Users + Revenue
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people_alt_rounded,
                        label: 'Total Users',
                        value: '${stats.totalUsers}',
                        subtitle: '+${stats.todayNewUsers} today',
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.currency_rupee_rounded,
                        label: 'Revenue',
                        value: '₹${_formatAmount(stats.totalRevenue)}',
                        subtitle: '₹${_formatAmount(stats.todayRevenue)} today',
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),

                // Row 2: Food Orders + Clothes Orders
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.restaurant_rounded,
                        label: 'Food Orders',
                        value: '${stats.foodOrders}',
                        subtitle: '${stats.foodProducts} products',
                        color: const Color(0xFFF97316),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.checkroom_rounded,
                        label: 'Clothes Orders',
                        value: '${stats.clothingOrders}',
                        subtitle: '${stats.clothingProducts} products',
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),

                // Row 3: Total Orders + Pending
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.receipt_long_rounded,
                        label: 'Total Orders',
                        value: '${stats.totalOrders}',
                        subtitle: '${stats.todayOrders} today',
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.pending_actions_rounded,
                        label: 'Pending',
                        value: '${stats.pendingOrders}',
                        subtitle: '${stats.completedOrders} completed',
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.md),

                // Products section header
                Row(
                  children: [
                    const Icon(Icons.inventory_2_rounded, size: 18),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      'Products Overview',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),

                // Products big card
                _ProductsCard(stats: stats),
                const SizedBox(height: AppDimensions.md),

                // Add Product CTA
                _AddProductCard(),
                const SizedBox(height: AppDimensions.lg),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatAmount(String amount) {
    final value = double.tryParse(amount) ?? 0.0;
    if (value >= 100000) return '${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}

// ───── Widgets ─────

class _GreetingHeader extends StatelessWidget {
  final AdminStats stats;

  const _GreetingHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Admin Panel',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${stats.totalUsers}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Customers',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsCard extends StatelessWidget {
  final AdminStats stats;

  const _ProductsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total products header
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
                    ),
                  ),
                  Text(
                    'Total Active Products',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 26,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          const Divider(),
          const SizedBox(height: AppDimensions.sm),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _ProductStatTile(
                  label: 'Out of Stock',
                  value: stats.outOfStock,
                  icon: Icons.remove_shopping_cart_rounded,
                  color: Colors.red.shade600,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _ProductStatTile(
                  label: 'Low Stock',
                  value: stats.lowStock,
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange.shade600,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _ProductStatTile(
                  label: 'Completed Orders',
                  value: stats.completedOrders,
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          const Divider(),
          const SizedBox(height: AppDimensions.sm),

          // Product type breakdown
          Row(
            children: [
              Expanded(
                child: _TypeBreakdownTile(
                  icon: Icons.restaurant_rounded,
                  label: 'Food',
                  count: stats.foodProducts,
                  color: const Color(0xFFF97316),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: _TypeBreakdownTile(
                  icon: Icons.checkroom_rounded,
                  label: 'Clothing',
                  count: stats.clothingProducts,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductStatTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _ProductStatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TypeBreakdownTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _TypeBreakdownTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.sm, horizontal: AppDimensions.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '$count products',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color:
          Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
    );
  }
}

class _AddProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push(RouteNames.adminCreateProduct),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.addProduct,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Create a new food or clothing listing',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}

// ───── Loading skeleton ─────

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.md),
      children: [
        _shimmer(context, 80),
        const SizedBox(height: AppDimensions.sm),
        Row(children: [
          Expanded(child: _shimmer(context, 110)),
          const SizedBox(width: AppDimensions.sm),
          Expanded(child: _shimmer(context, 110)),
        ]),
        const SizedBox(height: AppDimensions.sm),
        Row(children: [
          Expanded(child: _shimmer(context, 110)),
          const SizedBox(width: AppDimensions.sm),
          Expanded(child: _shimmer(context, 110)),
        ]),
        const SizedBox(height: AppDimensions.sm),
        Row(children: [
          Expanded(child: _shimmer(context, 110)),
          const SizedBox(width: AppDimensions.sm),
          Expanded(child: _shimmer(context, 110)),
        ]),
        const SizedBox(height: AppDimensions.md),
        _shimmer(context, 200),
        const SizedBox(height: AppDimensions.md),
        _shimmer(context, 70),
      ],
    );
  }

  Widget _shimmer(BuildContext context, double height) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
    );
  }
}

// ───── Error state ─────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56,
                color: theme.colorScheme.error.withValues(alpha: 0.6)),
            const SizedBox(height: AppDimensions.md),
            Text('Failed to load stats', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppDimensions.sm),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
