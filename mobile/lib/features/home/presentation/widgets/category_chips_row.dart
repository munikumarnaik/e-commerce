import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../../../product/domain/models/brand_model.dart';
import '../../../product/domain/models/product_filter.dart';
import '../../../product/presentation/providers/category_provider.dart';

/// Shows brands (for Clothing) or food types (for Food) on the home screen.
class CategoryChipsRow extends ConsumerWidget {
  final void Function(String title, ProductFilter filter)? onItemTap;

  const CategoryChipsRow({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(activeCategoryProvider);

    if (category == AppCategory.clothing) {
      return _BrandsRow(onItemTap: onItemTap);
    }
    return _FoodTypesRow(onItemTap: onItemTap);
  }
}

// ─── Food Types ────────────────────────────────────────────────────────────

class _FoodTypeItem {
  final String label;
  final String value;
  final IconData icon;

  const _FoodTypeItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

const _foodTypes = [
  _FoodTypeItem(label: 'Veg', value: 'VEG', icon: Icons.eco_rounded),
  _FoodTypeItem(label: 'Non-Veg', value: 'NON_VEG', icon: Icons.restaurant_rounded),
  _FoodTypeItem(label: 'Vegan', value: 'VEGAN', icon: Icons.spa_rounded),
  _FoodTypeItem(label: 'Egg', value: 'EGG', icon: Icons.egg_rounded),
];

class _FoodTypesRow extends StatelessWidget {
  final void Function(String title, ProductFilter filter)? onItemTap;

  const _FoodTypesRow({this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: _foodTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final item = _foodTypes[index];
          return _ChipItem(
            label: item.label,
            icon: item.icon,
            onTap: () => onItemTap?.call(
              item.label,
              ProductFilter(foodType: item.value, categoryType: 'FOOD'),
            ),
          ).animate().fadeIn(
                duration: 300.ms,
                delay: (50 * index).ms,
              );
        },
      ),
    );
  }
}

// ─── Brands ────────────────────────────────────────────────────────────────

class _BrandsRow extends ConsumerWidget {
  final void Function(String title, ProductFilter filter)? onItemTap;

  const _BrandsRow({this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);

    return SizedBox(
      height: 100,
      child: brandsAsync.when(
        data: (brands) {
          if (brands.isEmpty) return const SizedBox.shrink();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            itemCount: brands.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.sm),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return _BrandItem(
                brand: brand,
                onTap: () => onItemTap?.call(
                  brand.name,
                  ProductFilter(brandId: brand.id, categoryType: 'CLOTHING'),
                ),
              ).animate().fadeIn(
                    duration: 300.ms,
                    delay: (50 * index).ms,
                  );
            },
          );
        },
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          itemCount: 6,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppDimensions.sm),
          itemBuilder: (_, __) => Column(
            children: [
              ShimmerWidget.circular(size: 60),
              const SizedBox(height: 6),
              ShimmerWidget(height: 10, width: 50),
            ],
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final Brand brand;
  final VoidCallback? onTap;

  const _BrandItem({required this.brand, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: brand.logo != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: brand.logo!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Icon(
                          Icons.store_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.store_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              brand.name,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Generic chip item for food types ─────────────────────────────────────

class _ChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _ChipItem({
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
