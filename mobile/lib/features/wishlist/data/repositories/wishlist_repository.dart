import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../product/domain/models/product_model.dart';

class WishlistRepository {
  final Dio _dio;

  WishlistRepository(this._dio);

  Future<List<Product>> getWishlistProducts() async {
    try {
      final response = await _dio.get(ApiEndpoints.wishlist);
      final data = response.data['data'];
      if (data == null) return [];
      final items = data['items'] as List? ?? [];
      return items
          .where((e) => e['product'] != null)
          .map((e) => Product.fromJson(e['product'] as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) return e.error as AppException;
    return const UnknownException();
  }
}

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return WishlistRepository(dio);
});
