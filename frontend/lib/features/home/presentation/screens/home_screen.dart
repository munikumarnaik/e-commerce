import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/search_bar_shortcut.dart';
import '../../../auth/domain/models/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_chips_row.dart';
import '../widgets/category_toggle.dart';
import '../widgets/home_greeting.dart';
import '../widgets/product_grid_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(activeCategoryProvider);
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);

    final userName =
        authState is AuthAuthenticated ? authState.user.firstName : 'Guest';

    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
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
                // App bar
                SliverAppBar(
                  floating: true,
                  title: Text(AppStrings.appName),
                  actions: [
                    IconButton(
                      icon: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).state =
                            themeMode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded),
                      onPressed: () {},
                    ),
                  ],
                ),

                // Greeting
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.sm),
                    child: HomeGreeting(userName: userName),
                  ),
                ),

                // Category toggle
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppDimensions.lg),
                    child: CategoryToggle(),
                  ),
                ),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.md,
                      AppDimensions.lg,
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

                // Featured products
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: AppDimensions.lg),
                //     child: FeaturedProductsSection(
                //       onProductTap: (product) {
                //         context.push('/products/${product.slug}');
                //       },
                //     ),
                //   ),
                // ),

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
      ),
    );
  }
}
