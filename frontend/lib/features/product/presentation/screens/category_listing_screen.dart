import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product_filter.dart';
import '../providers/product_list_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card_skeleton.dart';

/// A generic filtered product listing screen.
/// Pass a [ProductFilter] via the `extra` field in GoRouter.
/// Falls back to filtering by brand or food_type query params.
class FilteredProductListingScreen extends ConsumerStatefulWidget {
  final String title;
  final ProductFilter filter;

  const FilteredProductListingScreen({
    super.key,
    required this.title,
    required this.filter,
  });

  @override
  ConsumerState<FilteredProductListingScreen> createState() =>
      _FilteredProductListingScreenState();
}

class _FilteredProductListingScreenState
    extends ConsumerState<FilteredProductListingScreen> {
  late final StateNotifierProvider<ProductListNotifier, ProductListState>
      _provider;

  @override
  void initState() {
    super.initState();
    // Create a unique provider keyed on the filter's string representation
    _provider = StateNotifierProvider<ProductListNotifier, ProductListState>(
      (ref) {
        final repository = ref.watch(productRepositoryProvider);
        final notifier = ProductListNotifier(repository);
        notifier.loadProducts(filter: widget.filter);
        return notifier;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 300) {
            ref.read(_provider.notifier).loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => ref.read(_provider.notifier).refresh(),
          child: _buildBody(context, ref, state, wishlist, theme),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
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
                ),
                const SizedBox(height: AppDimensions.lg),
                FilledButton.tonal(
                  onPressed: () => ref.read(_provider.notifier).refresh(),
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
}

/// Keep the old class name as an alias for backward compatibility with router
typedef CategoryListingScreen = FilteredProductListingScreen;
