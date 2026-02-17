import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../../../product/domain/models/category_model.dart';
import '../../../product/presentation/providers/category_provider.dart';

class CategoryChipsRow extends ConsumerWidget {
  final void Function(Category category)? onCategoryTap;

  const CategoryChipsRow({super.key, this.onCategoryTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(homeCategoriesProvider);

    return SizedBox(
      height: 100,
      child: categoriesAsync.when(
        data: (categories) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          itemCount: categories.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppDimensions.sm),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _CategoryItem(
              category: cat,
              onTap: () => onCategoryTap?.call(cat),
            ).animate().fadeIn(
                  duration: 300.ms,
                  delay: (50 * index).ms,
                );
          },
        ),
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

class _CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const _CategoryItem({required this.category, this.onTap});

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
              child: category.image != null
                  ? ClipOval(
                      child: Image.network(
                        category.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.category_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    )
                  : Icon(
                      _getCategoryIcon(category.name),
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
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

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('pizza') || lower.contains('fast')) {
      return Icons.local_pizza_rounded;
    }
    if (lower.contains('drink') || lower.contains('beverage')) {
      return Icons.local_drink_rounded;
    }
    if (lower.contains('dessert') || lower.contains('sweet')) {
      return Icons.cake_rounded;
    }
    if (lower.contains('shirt') || lower.contains('top')) {
      return Icons.checkroom_rounded;
    }
    if (lower.contains('shoe') || lower.contains('foot')) {
      return Icons.directions_run_rounded;
    }
    if (lower.contains('accessori')) {
      return Icons.watch_rounded;
    }
    return Icons.category_rounded;
  }
}
