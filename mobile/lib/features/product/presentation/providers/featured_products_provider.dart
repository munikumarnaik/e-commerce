import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product_model.dart';

/// Fetches featured products filtered by category type string (FOOD / CLOTHING)
final featuredProductsProvider =
    FutureProvider.family<List<Product>, String?>((ref, categoryType) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getFeaturedProducts(categoryType: categoryType);
});

/// Auto-refreshes when the active category changes
final homeFeaturedProductsProvider =
    FutureProvider<List<Product>>((ref) async {
  final category = ref.watch(activeCategoryProvider);
  final categoryType = switch (category) {
    AppCategory.food => 'FOOD',
    AppCategory.clothing => 'CLOTHING',
  };
  final repository = ref.watch(productRepositoryProvider);
  return repository.getFeaturedProducts(categoryType: categoryType);
});
