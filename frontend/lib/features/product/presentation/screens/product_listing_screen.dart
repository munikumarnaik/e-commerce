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
  Widget build(BuildContext context, ) {
    final state = ref.watch(productListProvider);
    final wishlist = ref.watch(wishlistProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Products'),
      ),
      body: Column(
        children: [
          // ── Visible sort + filter bar ───────────────────
          _SortFilterBar(
            filter: state.filter,
            onSortTap: () => _showSortSheet(context, state.filter),
            onFilterTap: () => _showFilterSheet(context),
            onClearFilter: (key) => _clearOneFilter(key, state.filter),
          ),
          const Divider(height: 1),

          // ── Product list ────────────────────────────────
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter < 300) {
                  ref.read(productListProvider.notifier).loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(productListProvider.notifier).refresh(),
                child: _buildBody(state, wishlist, theme),
              ),
            ),
          ),
        ],
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
                const SizedBox(height: AppDimensions.sm),
                TextButton(
                  onPressed: () {
                    final clearedFilter = ProductFilter(
                      categoryType: state.filter.categoryType,
                      clothingType: state.filter.clothingType,
                      foodType: state.filter.foodType,
                    );
                    ref
                        .read(productListProvider.notifier)
                        .updateFilter(clearedFilter);
                  },
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Result count
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
    }
  }

  void _showSortSheet(BuildContext context, ProductFilter currentFilter) async {
    final result = await _SortSheet.show(context, currentFilter.ordering);
    if (result != null) {
      final updated = currentFilter.copyWith(ordering: result == '' ? null : result);
      ref.read(productListProvider.notifier).updateFilter(updated);
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

  void _clearOneFilter(String key, ProductFilter current) {
    final f = current.copyWith();
    switch (key) {
      case 'rating':
        f.minRating = null;
      case 'brand':
        f.brandId = null;
      case 'gender':
        f.gender = null;
      case 'size':
        f.size = null;
      case 'color':
        f.color = null;
      case 'price':
        f.minPrice = null;
        f.maxPrice = null;
      case 'sort':
        f.ordering = null;
      case 'foodType':
        f.foodType = null;
      case 'cuisine':
        f.cuisineType = null;
    }
    ref.read(productListProvider.notifier).updateFilter(f);
  }
}

// ─── Sort + Filter bar ────────────────────────────────────────────────────

class _SortFilterBar extends StatelessWidget {
  final ProductFilter filter;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;
  final void Function(String key) onClearFilter;

  const _SortFilterBar({
    required this.filter,
    required this.onSortTap,
    required this.onFilterTap,
    required this.onClearFilter,
  });

  int get _activeFilterCount {
    int count = 0;
    if (filter.minRating != null) count++;
    if (filter.brandId != null) count++;
    if (filter.gender != null) count++;
    if (filter.size != null) count++;
    if (filter.color != null) count++;
    if (filter.minPrice != null || filter.maxPrice != null) count++;
    if (filter.foodType != null) count++;
    if (filter.cuisineType != null) count++;
    return count;
  }

  String get _sortLabel {
    switch (filter.ordering) {
      case 'price':
        return 'Price: Low to High';
      case '-price':
        return 'Price: High to Low';
      case '-created_at':
        return 'Newest';
      case '-average_rating':
        return 'Top Rated';
      default:
        return 'Sort';
    }
  }

  bool get _hasSortActive => filter.ordering != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = _buildActiveChips();

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sort + Filter buttons row ─────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: 10,
            ),
            child: Row(
              children: [
                // Sort button
                _ActionChip(
                  label: _sortLabel,
                  icon: Icons.swap_vert_rounded,
                  isActive: _hasSortActive,
                  onTap: onSortTap,
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16),
                ),
                const SizedBox(width: AppDimensions.sm),

                // Filter button
                _ActionChip(
                  label: _activeFilterCount > 0
                      ? 'Filters ($_activeFilterCount)'
                      : 'Filters',
                  icon: Icons.tune_rounded,
                  isActive: _activeFilterCount > 0,
                  onTap: onFilterTap,
                ),

                // Active filter quick-view chips
                if (chips.isNotEmpty) ...[
                  Container(
                    height: 20,
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: theme.colorScheme.outlineVariant,
                  ),
                  ...chips,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];
    if (filter.minRating != null) {
      chips.add(_ActiveFilterChip(
        label: '${filter.minRating}★ & above',
        onRemove: () => onClearFilter('rating'),
      ));
    }
    if (filter.brandId != null) {
      chips.add(_ActiveFilterChip(
        label: 'Brand',
        onRemove: () => onClearFilter('brand'),
      ));
    }
    if (filter.gender != null) {
      chips.add(_ActiveFilterChip(
        label: filter.gender!,
        onRemove: () => onClearFilter('gender'),
      ));
    }
    if (filter.size != null) {
      chips.add(_ActiveFilterChip(
        label: 'Size: ${filter.size}',
        onRemove: () => onClearFilter('size'),
      ));
    }
    if (filter.color != null) {
      chips.add(_ActiveFilterChip(
        label: filter.color!,
        onRemove: () => onClearFilter('color'),
      ));
    }
    if (filter.minPrice != null || filter.maxPrice != null) {
      final min = (filter.minPrice ?? 0).toInt();
      final max = (filter.maxPrice ?? 10000).toInt();
      chips.add(_ActiveFilterChip(
        label: '₹$min–₹$max',
        onRemove: () => onClearFilter('price'),
      ));
    }
    if (filter.foodType != null) {
      final label = switch (filter.foodType) {
        'VEG' => 'Veg',
        'NON_VEG' => 'Non-Veg',
        'VEGAN' => 'Vegan',
        'EGG' => 'Egg',
        _ => filter.foodType!,
      };
      chips.add(_ActiveFilterChip(
        label: label,
        onRemove: () => onClearFilter('foodType'),
      ));
    }
    if (filter.cuisineType != null) {
      chips.add(_ActiveFilterChip(
        label: filter.cuisineType!,
        onRemove: () => onClearFilter('cuisine'),
      ));
    }
    return chips;
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ActionChip({
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

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: AppDimensions.sm),
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
