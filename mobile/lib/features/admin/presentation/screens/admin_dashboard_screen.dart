import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/admin_stats_provider.dart';
import '../widgets/dashboard_add_product_card.dart';
import '../widgets/dashboard_gradient_stat_card.dart';
import '../widgets/dashboard_loading_error.dart';
import '../widgets/dashboard_products_card.dart';
import '../widgets/dashboard_stat_container.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: statsAsync.when(
        loading: () => const DashboardLoadingGrid(),
        error: (e, _) => DashboardErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(adminStatsProvider),
        ),
        data: (stats) => _DashboardBody(stats: stats),
      ),
    );
  }
}

// ───── Dashboard Body ─────

class _DashboardBody extends ConsumerWidget {
  final AdminStats stats;
  const _DashboardBody({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(adminStatsProvider),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── Clean App Bar ──
          SliverAppBar(
            expandedHeight: 130,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              title: Text(
                AppStrings.adminDashboard,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 44),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.dashboard_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Admin Panel',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Action Buttons Row ──
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.refresh_rounded,
                          label: 'Refresh',
                          color: const Color(0xFF3B82F6),
                          onTap: () => ref.invalidate(adminStatsProvider),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          color: const Color(0xFFEF4444),
                          onTap: () => _showLogoutDialog(context, ref),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Users & Revenue ──
                  Row(
                    children: [
                      Expanded(
                        child: DashboardGradientStatCard(
                          icon: Icons.people_alt_rounded,
                          label: 'Total Users',
                          value: '${stats.totalUsers}',
                          subtitle: '+${stats.todayNewUsers} today',
                          gradientColors: const [
                            Color(0xFF3B82F6),
                            Color(0xFF60A5FA),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardGradientStatCard(
                          icon: Icons.currency_rupee_rounded,
                          label: 'Revenue',
                          value: '₹${_formatAmount(stats.totalRevenue)}',
                          subtitle:
                              '₹${_formatAmount(stats.todayRevenue)} today',
                          gradientColors: const [
                            Color(0xFF10B981),
                            Color(0xFF34D399),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Food & Clothes Orders ──
                  _SectionLabel(title: 'Orders Overview'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatContainer(
                          icon: Icons.restaurant_rounded,
                          label: 'Food Orders',
                          value: '${stats.foodOrders}',
                          subtitle: '${stats.foodProducts} products',
                          accentColor: const Color(0xFFF97316),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardStatContainer(
                          icon: Icons.checkroom_rounded,
                          label: 'Clothes Orders',
                          value: '${stats.clothingOrders}',
                          subtitle: '${stats.clothingProducts} products',
                          accentColor: const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Total & Pending Orders ──
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatContainer(
                          icon: Icons.receipt_long_rounded,
                          label: 'Total Orders',
                          value: '${stats.totalOrders}',
                          subtitle: '${stats.todayOrders} today',
                          accentColor: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardStatContainer(
                          icon: Icons.pending_actions_rounded,
                          label: 'Pending',
                          value: '${stats.pendingOrders}',
                          subtitle: '${stats.completedOrders} completed',
                          accentColor: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Products ──
                  _SectionLabel(title: 'Products Overview'),
                  const SizedBox(height: 10),
                  DashboardProductsCard(stats: stats),
                  const SizedBox(height: 16),

                  // ── Add Product ──
                  const DashboardAddProductCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️ Good Morning';
    if (hour < 17) return '🌤️ Good Afternoon';
    return '🌙 Good Evening';
  }

  String _formatAmount(String amount) {
    final value = double.tryParse(amount) ?? 0.0;
    if (value >= 100000) return '${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}

// ── Tiny reusable helpers (kept inline since they're tiny) ──

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(Icons.bar_chart_rounded,
              size: 14, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
