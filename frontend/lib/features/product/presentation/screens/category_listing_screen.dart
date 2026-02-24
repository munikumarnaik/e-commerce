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
    // Re-copy all active filters except the cleared one
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);
    final isFood = _baseFilter.categoryType == 'FOOD';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // ── Visible sort + filter bar ────────────────────
          _SortFilterBar(
            filter: _activeFilter,
            baseFilter: _baseFilter,
            onSortTap: () => _showSortSheet(context),
            onFilterTap: () => _showFilterSheet(context, isFood),
            onClearFilter: _clearOneFilter,
          ),
          const Divider(height: 1),

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
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
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

  void _showSortSheet(BuildContext context) async {
    final result =
        await _SortSheet.show(context, _activeFilter.ordering);
    if (result != null) {
      final updated = ProductFilter(
        categoryType: _activeFilter.categoryType,
        clothingType: _activeFilter.clothingType,
        foodType: _activeFilter.foodType,
        brandId: _activeFilter.brandId,
        gender: _activeFilter.gender,
        size: _activeFilter.size,
        color: _activeFilter.color,
        minPrice: _activeFilter.minPrice,
        maxPrice: _activeFilter.maxPrice,
        minRating: _activeFilter.minRating,
        cuisineType: _activeFilter.cuisineType,
        ordering: result.isEmpty ? null : result,
      );
      _applyFilter(updated);
    }
  }

  void _showFilterSheet(BuildContext context, bool isFood) async {
    final result = await FilterBottomSheet.show(
      context,
      currentFilter: _activeFilter,
      isFood: isFood,
    );
    if (result != null) {
      // Always preserve the base chip filter context
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

// ─── Sort + Filter bar ────────────────────────────────────────────────────

class _SortFilterBar extends StatelessWidget {
  final ProductFilter filter;
  final ProductFilter baseFilter;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;
  final void Function(String key) onClearFilter;

  const _SortFilterBar({
    required this.filter,
    required this.baseFilter,
    required this.onSortTap,
    required this.onFilterTap,
    required this.onClearFilter,
  });

  int get _extraFilterCount {
    int count = 0;
    if (filter.minRating != null) count++;
    if (filter.brandId != null) count++;
    if (filter.gender != null) count++;
    if (filter.size != null) count++;
    if (filter.color != null) count++;
    if (filter.minPrice != null || filter.maxPrice != null) count++;
    if (filter.foodType != null &&
        filter.foodType != baseFilter.foodType) {
      count++;
    }
    if (filter.cuisineType != null) count++;
    return count;
  }

  String get _sortLabel {
    switch (filter.ordering) {
      case 'price':
        return 'Price ↑';
      case '-price':
        return 'Price ↓';
      case '-created_at':
        return 'Newest';
      case '-average_rating':
        return 'Top Rated';
      default:
        return 'Sort';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeChips = _buildActiveChips();

    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: 10,
        ),
        child: Row(
          children: [
            // Sort button
            _BarChip(
              label: _sortLabel,
              icon: Icons.swap_vert_rounded,
              isActive: filter.ordering != null,
              onTap: onSortTap,
              trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 16),
            ),
            const SizedBox(width: 8),

            // Filter button
            _BarChip(
              label: _extraFilterCount > 0
                  ? 'Filters ($_extraFilterCount)'
                  : 'Filters',
              icon: Icons.tune_rounded,
              isActive: _extraFilterCount > 0,
              onTap: onFilterTap,
            ),

            // Active filter quick-chips with ✕
            if (activeChips.isNotEmpty) ...[
              Container(
                height: 20,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: theme.colorScheme.outlineVariant,
              ),
              ...activeChips,
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];
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
    if (filter.foodType != null &&
        filter.foodType != baseFilter.foodType) {
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
}

class _BarChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? trailing;

  const _BarChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 2),
              IconTheme(
                data: IconThemeData(
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
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

// ─── Sort Sheet ───────────────────────────────────────────────────────────

class _SortSheet {
  static Future<String?> show(BuildContext context, String? current) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (ctx) => _SortSheetContent(current: current),
    );
  }
}

class _SortSheetContent extends StatelessWidget {
  final String? current;

  const _SortSheetContent({this.current});

  static const _options = [
    (label: 'Relevance', value: ''),
    (label: 'Newest First', value: '-created_at'),
    (label: 'Price: Low to High', value: 'price'),
    (label: 'Price: High to Low', value: '-price'),
    (label: 'Top Rated', value: '-average_rating'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.sm,
                AppDimensions.lg,
                AppDimensions.md,
              ),
              child: Text(
                'Sort By',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            for (final opt in _options)
              ListTile(
                title: Text(opt.label),
                leading: Radio<String>(
                  value: opt.value,
                  groupValue: current ?? '',
                  onChanged: (v) => Navigator.pop(context, v),
                ),
                onTap: () => Navigator.pop(context, opt.value),
                selected: (current ?? '') == opt.value,
                selectedTileColor:
                    theme.colorScheme.primary.withValues(alpha: 0.06),
                trailing: (current ?? '') == opt.value
                    ? Icon(Icons.check_rounded,
                        color: theme.colorScheme.primary, size: 18)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
