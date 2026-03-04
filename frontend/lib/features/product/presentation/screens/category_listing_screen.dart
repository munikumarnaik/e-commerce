import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product_filter.dart';
import '../providers/product_list_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card_skeleton.dart';

/// A generic filtered product listing screen.
/// Pass a [ProductFilter] via the `extra` field in GoRouter.
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
  late StateNotifierProvider<ProductListNotifier, ProductListState> _provider;

  // The base filter passed in (chip context: clothingType, categoryType, etc.)
  late ProductFilter _baseFilter;

  // Currently applied additional filters (rating, brand, price, etc.)
  late ProductFilter _activeFilter;

  @override
  void initState() {
    super.initState();
    _baseFilter = widget.filter;
    _activeFilter = widget.filter;
    _createProvider(_activeFilter);
  }

  void _createProvider(ProductFilter filter) {
    _provider =
        StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
      final repository = ref.watch(productRepositoryProvider);
      final notifier = ProductListNotifier(repository);
      notifier.loadProducts(filter: filter);
      return notifier;
    });
  }

  void _applyFilter(ProductFilter newFilter) {
    setState(() {
      _activeFilter = newFilter;
      _createProvider(newFilter);
    });
  }

  void _clearOneFilter(String key) {
    final f = ProductFilter(
      categoryType: _baseFilter.categoryType,
      clothingType: _baseFilter.clothingType,
      foodType: _activeFilter.foodType != _baseFilter.foodType
          ? _activeFilter.foodType
          : _baseFilter.foodType,
    );
    f.minRating = key == 'rating' ? null : _activeFilter.minRating;
    f.brandId = key == 'brand' ? null : _activeFilter.brandId;
    f.gender = key == 'gender' ? null : _activeFilter.gender;
    f.size = key == 'size' ? null : _activeFilter.size;
    f.color = key == 'color' ? null : _activeFilter.color;
    f.ordering = key == 'sort' ? null : _activeFilter.ordering;
    f.cuisineType = key == 'cuisine' ? null : _activeFilter.cuisineType;
    if (key == 'price') {
      f.minPrice = null;
      f.maxPrice = null;
    } else {
      f.minPrice = _activeFilter.minPrice;
      f.maxPrice = _activeFilter.maxPrice;
    }
    if (key == 'foodType') {
      f.foodType = _baseFilter.foodType;
    } else {
      f.foodType = _activeFilter.foodType;
    }
    _applyFilter(f);
  }

  int get _activeFilterCount {
    int count = 0;
    if (_activeFilter.minRating != null) count++;
    if (_activeFilter.brandId != null) count++;
    if (_activeFilter.gender != null) count++;
    if (_activeFilter.size != null) count++;
    if (_activeFilter.color != null) count++;
    if (_activeFilter.minPrice != null || _activeFilter.maxPrice != null) count++;
    if (_activeFilter.foodType != null &&
        _activeFilter.foodType != _baseFilter.foodType) { count++; }
    if (_activeFilter.cuisineType != null) count++;
    if (_activeFilter.ordering != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);
    final isFood = _baseFilter.categoryType == 'FOOD';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Badge(
            isLabelVisible: _activeFilterCount > 0,
            label: Text('$_activeFilterCount'),
            child: IconButton(
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Filter',
              onPressed: () => _showFilterSheet(context, isFood),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Active filter chips (only shown when filters are applied) ──
          _ActiveFiltersRow(
            filter: _activeFilter,
            baseFilter: _baseFilter,
            onClearFilter: _clearOneFilter,
          ),

          // ── Product list ─────────────────────────────────
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter < 300) {
                  ref.read(_provider.notifier).loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () => ref.read(_provider.notifier).refresh(),
                child: _buildBody(context, state, wishlist, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
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
                Icon(Icons.error_outline_rounded,
                    size: 56, color: theme.colorScheme.error),
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
                const SizedBox(height: AppDimensions.sm),
                TextButton(
                  onPressed: () => _applyFilter(_baseFilter),
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.md,
                  AppDimensions.sm,
                  AppDimensions.md,
                  0,
                ),
                child: Text(
                  '${state.products.length} results',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
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
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
          ],
        );
    }
  }

  void _showFilterSheet(BuildContext context, bool isFood) async {
    final result = await FilterBottomSheet.show(
      context,
      currentFilter: _activeFilter,
      isFood: isFood,
    );
    if (result != null) {
      result.categoryType = _baseFilter.categoryType;
      result.clothingType = _baseFilter.clothingType;
      if (_baseFilter.foodType != null && result.foodType == null) {
        result.foodType = _baseFilter.foodType;
      }
      _applyFilter(result);
    }
  }
}

/// Keep the old class name as an alias for backward compatibility with router
typedef CategoryListingScreen = FilteredProductListingScreen;

// ─── Active Filters Row ───────────────────────────────────────────────────

class _ActiveFiltersRow extends StatelessWidget {
  final ProductFilter filter;
  final ProductFilter baseFilter;
  final void Function(String key) onClearFilter;

  const _ActiveFiltersRow({
    required this.filter,
    required this.baseFilter,
    required this.onClearFilter,
  });

  List<Widget> _buildChips() {
    final chips = <Widget>[];

    if (filter.ordering != null) {
      final label = switch (filter.ordering) {
        'price' => 'Price: Low–High',
        '-price' => 'Price: High–Low',
        '-created_at' => 'Newest',
        '-average_rating' => 'Top Rated',
        _ => filter.ordering!,
      };
      chips.add(_ActiveChip(
        label: label,
        onRemove: () => onClearFilter('sort'),
      ));
    }
    if (filter.minRating != null) {
      chips.add(_ActiveChip(
        label: '${filter.minRating}★+',
        onRemove: () => onClearFilter('rating'),
      ));
    }
    if (filter.brandId != null) {
      chips.add(_ActiveChip(
        label: 'Brand',
        onRemove: () => onClearFilter('brand'),
      ));
    }
    if (filter.gender != null) {
      chips.add(_ActiveChip(
        label: filter.gender!,
        onRemove: () => onClearFilter('gender'),
      ));
    }
    if (filter.size != null) {
      chips.add(_ActiveChip(
        label: filter.size!,
        onRemove: () => onClearFilter('size'),
      ));
    }
    if (filter.color != null) {
      chips.add(_ActiveChip(
        label: filter.color!,
        onRemove: () => onClearFilter('color'),
      ));
    }
    if (filter.minPrice != null || filter.maxPrice != null) {
      chips.add(_ActiveChip(
        label:
            '₹${(filter.minPrice ?? 0).toInt()}–₹${(filter.maxPrice ?? 10000).toInt()}',
        onRemove: () => onClearFilter('price'),
      ));
    }
    if (filter.foodType != null && filter.foodType != baseFilter.foodType) {
      final label = switch (filter.foodType) {
        'VEG' => 'Veg',
        'NON_VEG' => 'Non-Veg',
        'VEGAN' => 'Vegan',
        'EGG' => 'Egg',
        _ => filter.foodType!,
      };
      chips.add(_ActiveChip(
        label: label,
        onRemove: () => onClearFilter('foodType'),
      ));
    }
    if (filter.cuisineType != null) {
      chips.add(_ActiveChip(
        label: filter.cuisineType!,
        onRemove: () => onClearFilter('cuisine'),
      ));
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final chips = _buildChips();
    if (chips.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: 8,
          ),
          child: Row(children: chips),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.only(left: 10, right: 4, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
