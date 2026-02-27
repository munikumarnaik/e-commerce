import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/search_bar_shortcut.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_chips_row.dart';
import '../widgets/category_toggle.dart';
import '../widgets/product_grid_section.dart';
import '../../../../core/theme/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(activeCategoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 300) {
            ref.read(homeProductListProvider.notifier).loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(homeProductListProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Premium app bar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: theme.colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0.5,
                titleSpacing: AppDimensions.md,
                title: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 18,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                actions: [
                  _NotificationBellButton(),
                  const SizedBox(width: 4),
                ],
              ),

              // Category toggle
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppDimensions.md,
                    bottom: AppDimensions.sm,
                  ),
                  child: CategoryToggle(),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md,
                    AppDimensions.sm,
                    AppDimensions.md,
                    0,
                  ),
                  child: SearchBarShortcut(
                    onTap: () => context.push('/search'),
                  ),
                ),
              ),

              // Banner carousel
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.lg),
                  child: BannerCarousel(category: category),
                ),
              ),

              // Brands (clothing) / Food types (food)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.lg),
                  child: CategoryChipsRow(
                    onItemTap: (title, filter) {
                      context.push(
                        '/filtered-products',
                        extra: {'title': title, 'filter': filter},
                      );
                    },
                  ),
                ),
              ),

              // All products grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.lg),
                  child: ProductGridSection(
                    onProductTap: (product) {
                      context.push('/products/${product.slug}');
                    },
                  ),
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBellButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unreadAsync = ref.watch(unreadNotificationCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return IconButton(
      icon: Badge(
        isLabelVisible: unreadCount > 0,
        label: Text(
          unreadCount > 99 ? '99+' : '$unreadCount',
          style: const TextStyle(fontSize: 10),
        ),
        child: const Icon(Icons.notifications_none_rounded),
      ),
      onPressed: () => context.push(RouteNames.notifications),
      style: IconButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
