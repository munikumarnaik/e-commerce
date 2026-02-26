import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widgets/category_toggle.dart';
import '../../../product/domain/models/product_filter.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(activeCategoryProvider);
    final theme = Theme.of(context);
    final items =
        category == AppCategory.food ? _foodCategories : _clothingCategories;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            centerTitle: false,
            title: Text(
              'Categories',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
          ),

          // ── Food / Fashion toggle ────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.md),
              child: CategoryToggle(),
            ),
          ),

          // ── Category grid ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return _CategoryCard(
                    data: item,
                    onTap: () => context.push(
                      '/filtered-products',
                      extra: {
                        'title': item.label,
                        'filter': item.filter,
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: (index * 60).ms,
                      )
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 400.ms,
                        delay: (index * 60).ms,
                        curve: Curves.easeOut,
                      );
                },
                childCount: items.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.xxl),
          ),
        ],
      ),
    );
  }
}

// ── Card widget ──────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final _CategoryItem data;
  final VoidCallback onTap;

  const _CategoryCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: data.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: data.gradient.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background decorative emoji
            Positioned(
              right: -8,
              bottom: -8,
              child: Text(
                data.emoji,
                style: const TextStyle(fontSize: 64),
              ),
            ),
            // Semi-transparent overlay for readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.emoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(
                    data.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ───────────────────────────────────────────────────────────────

class _CategoryItem {
  final String label;
  final String emoji;
  final List<Color> gradient;
  final ProductFilter filter;

  const _CategoryItem({
    required this.label,
    required this.emoji,
    required this.gradient,
    required this.filter,
  });
}

// ── Food categories ──────────────────────────────────────────────────────────

final _foodCategories = [
  _CategoryItem(
    label: 'Dosa',
    emoji: '\u{1F95E}',
    gradient: const [Color(0xFFFF6B35), Color(0xFFFF9F1C)],
    filter: ProductFilter(search: 'Pizza', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Idli',
    emoji: '\u{1F358}',
    gradient: const [Color(0xFFE94560), Color(0xFFFF6B6B)],
    filter: ProductFilter(search: 'Burger', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Chicken',
    emoji: '\u{1F357}',
    gradient: const [Color(0xFFFF8A65), Color(0xFFFFAB91)],
    filter: ProductFilter(search: 'Chicken', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Biryani',
    emoji: '\u{1F35A}',
    gradient: const [Color(0xFFFFC107), Color(0xFFFFD54F)],
    filter: ProductFilter(search: 'Biryani', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Rolls',
    emoji: '\u{1F32F}',
    gradient: const [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
    filter: ProductFilter(search: 'Roll', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Noodles',
    emoji: '\u{1F35C}',
    gradient: const [Color(0xFF42A5F5), Color(0xFF90CAF9)],
    filter: ProductFilter(search: 'Noodle', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Sandwich',
    emoji: '\u{1F96A}',
    gradient: const [Color(0xFFAB47BC), Color(0xFFCE93D8)],
    filter: ProductFilter(search: 'Sandwich', categoryType: 'FOOD'),
  ),
  _CategoryItem(
    label: 'Salads',
    emoji: '\u{1F957}',
    gradient: const [Color(0xFF2EC4B6), Color(0xFF80DEEA)],
    filter: ProductFilter(search: 'Salad', categoryType: 'FOOD'),
  ),
];

// ── Clothing categories ──────────────────────────────────────────────────────

final _clothingCategories = [
  _CategoryItem(
    label: 'Formal Shirts',
    emoji: '\u{1F454}',
    gradient: const [Color(0xFF1A1A2E), Color(0xFF16213E)],
    filter: ProductFilter(search: 'Formal Shirt', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'Casual Shirts',
    emoji: '\u{1F455}',
    gradient: const [Color(0xFF42A5F5), Color(0xFF90CAF9)],
    filter: ProductFilter(search: 'Casual Shirt', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'Check Shirts',
    emoji: '\u{1F455}',
    gradient: const [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
    filter: ProductFilter(search: 'Check Shirt', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'T-Shirts',
    emoji: '\u{1F455}',
    gradient: const [Color(0xFFE94560), Color(0xFFFF6B6B)],
    filter: ProductFilter(search: 'T-Shirt', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'Formal Pants',
    emoji: '\u{1F456}',
    gradient: const [Color(0xFF5C6BC0), Color(0xFF9FA8DA)],
    filter: ProductFilter(search: 'Formal Pant', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'Casual Pants',
    emoji: '\u{1F456}',
    gradient: const [Color(0xFFFF8A65), Color(0xFFFFAB91)],
    filter: ProductFilter(search: 'Casual Pant', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'Jeans',
    emoji: '\u{1F456}',
    gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
    filter: ProductFilter(search: 'Jeans', categoryType: 'CLOTHING'),
  ),
  _CategoryItem(
    label: 'Jackets',
    emoji: '\u{1F9E5}',
    gradient: const [Color(0xFF6C63FF), Color(0xFF8B83FF)],
    filter: ProductFilter(search: 'Jacket', categoryType: 'CLOTHING'),
  ),
];
