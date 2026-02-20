import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/models/brand_model.dart';
import '../../domain/models/category_model.dart';

/// Fetches categories filtered by category type string (FOOD / CLOTHING)
final categoriesProvider =
    FutureProvider.family<List<Category>, String?>((ref, categoryType) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories(categoryType: categoryType);
});

/// Auto-refreshes when the active category changes
final homeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final category = ref.watch(activeCategoryProvider);
  final categoryType = switch (category) {
    AppCategory.food => 'FOOD',
    AppCategory.clothing => 'CLOTHING',
  };
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories(categoryType: categoryType);
});

/// Fetches all brands
final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getBrands();
});
