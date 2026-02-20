import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../domain/models/product_filter.dart';
import '../providers/product_list_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card_skeleton.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  final String? title;
  final ProductFilter? initialFilter;

  const ProductListingScreen({
    super.key,
    this.title,
    this.initialFilter,
  });

  @override
  ConsumerState<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialFilter != null) {
        ref
            .read(productListProvider.notifier)
            .loadProducts(filter: widget.initialFilter);
      } else {
        ref.read(productListProvider.notifier).loadProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListProvider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Products'),
        actions: [
          // Filter badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => _showFilterSheet(context),
              ),
              if (state.filter.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 300) {
            ref.read(productListProvider.notifier).loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => ref.read(productListProvider.notifier).refresh(),
          child: _buildBody(state, wishlist, theme),
        ),
      ),
    );
  }

  Widget _buildBody(
    ProductListState state,
    Set<String> wishlist,
    ThemeData theme,
  ) {
    switch (state.status) {
      case ProductListStatus.initial:
      case ProductListStatus.loading:
        return const ProductGridSkeleton(itemCount: 6);

      case ProductListStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  state.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppDimensions.lg),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.read(productListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case ProductListStatus.loaded:
        if (state.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 56,
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.4),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  'No products found',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.md),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: AppDimensions.sm,
                  mainAxisSpacing: AppDimensions.sm,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      product: product,
                      isWishlisted: wishlist.contains(product.id),
                      onTap: () =>
                          context.push('/products/${product.slug}'),
                      onWishlistTap: () => ref
                          .read(wishlistProvider.notifier)
                          .toggle(product.id),
                    );
                  },
                  childCount: state.products.length,
                ),
              ),
            ),
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.lg),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
    }
  }

  void _showFilterSheet(BuildContext context) async {
    final state = ref.read(productListProvider);
    final isFood = state.filter.categoryType == 'FOOD';

    final result = await FilterBottomSheet.show(
      context,
      currentFilter: state.filter,
      isFood: isFood,
    );

    if (result != null) {
      ref.read(productListProvider.notifier).updateFilter(result);
    }
  }
}
