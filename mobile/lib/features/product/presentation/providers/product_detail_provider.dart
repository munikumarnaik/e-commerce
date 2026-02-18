import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product_detail_model.dart';
import '../../domain/models/product_variant_model.dart';

/// Fetches product detail by slug.
/// Uses autoDispose so data is re-fetched each time the detail screen opens,
/// preventing stale/cached error states from blocking navigation.
final productDetailProvider =
    FutureProvider.autoDispose.family<ProductDetail, String>((ref, slug) async {
  final repository = ref.watch(productRepositoryProvider);
  // Fire-and-forget view tracking
  repository.trackProductView(slug);
  return repository.getProductDetail(slug);
});

/// Fetches product variants by slug
final productVariantsProvider =
    FutureProvider.autoDispose.family<List<ProductVariant>, String>((ref, slug) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductVariants(slug);
});
