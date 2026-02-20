import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/paginated_response.dart';
import '../../domain/models/product_detail_model.dart';
import '../../domain/models/product_model.dart';
import '../../domain/models/product_variant_model.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<PaginatedResponse<Product>> getProducts({
    Map<String, dynamic> queryParams = const {},
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {...queryParams, 'page': page},
      );
      final data = response.data['data'] ?? response.data;
      return PaginatedResponse.fromJson(data, Product.fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductDetail> getProductDetail(String slug) async {
    try {
      final response = await _dio.get(ApiEndpoints.productDetail(slug));
      // RetrieveAPIView returns the object directly (no {"data":...} wrapper)
      final data = response.data['data'] ?? response.data;
      return ProductDetail.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Product>> getFeaturedProducts({
    String? categoryType,
    int limit = 10,
  }) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      if (categoryType != null) params['category_type'] = categoryType;

      final response = await _dio.get(
        ApiEndpoints.featuredProducts,
        queryParameters: params,
      );
      final results = response.data['data'] ?? response.data;
      if (results is List) {
        return results
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      final list = results['results'] as List? ?? [];
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ProductVariant>> getProductVariants(String slug) async {
    try {
      final response = await _dio.get(ApiEndpoints.productVariants(slug));
      final data = response.data['data'] ?? response.data;
      final list = data is List ? data : (data['results'] as List? ?? []);
      return list
          .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> trackProductView(String slug) async {
    try {
      await _dio.post(ApiEndpoints.productView(slug));
    } on DioException {
      // Silently ignore view tracking failures
    }
  }

  // Wishlist
  Future<List<String>> getWishlistProductIds() async {
    try {
      final response = await _dio.get(ApiEndpoints.wishlist);
      final data = response.data['data'];
      if (data == null) return [];
      final items = data['items'] as List? ?? [];
      return items
          .map((e) => (e['product']?['id'] ?? e['product_id'] ?? '') as String)
          .where((id) => id.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      await _dio.post(
        ApiEndpoints.wishlistAdd,
        data: {'product_id': productId},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _dio.delete(ApiEndpoints.wishlistRemove(productId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Cart
  Future<void> addToCart({
    required String productId,
    String? variantId,
    int quantity = 1,
  }) async {
    try {
      final data = <String, dynamic>{
        'product_id': productId,
        'quantity': quantity,
      };
      if (variantId != null) data['variant_id'] = variantId;
      await _dio.post(ApiEndpoints.cartAdd, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return const UnknownException();
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepository(dio);
});
