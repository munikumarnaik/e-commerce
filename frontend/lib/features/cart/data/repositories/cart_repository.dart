import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/cart_model.dart';

class CartRepository {
  final Dio _dio;

  CartRepository(this._dio);

  Future<Cart> getCart() async {
    try {
      final response = await _dio.get(ApiEndpoints.cart);
      final data = response.data['data'] ?? response.data;
      return Cart.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /cart/add/ → backend returns cart_item + cart_summary (not full Cart)
  /// So we call getCart() afterwards to get the fresh full cart.
  Future<Cart> addToCart({
    required String productId,
    String? variantId,
    int quantity = 1,
  }) async {
    try {
      final body = <String, dynamic>{
        'product_id': productId,
        'quantity': quantity,
      };
      if (variantId != null) body['variant_id'] = variantId;
      await _dio.post(ApiEndpoints.cartAdd, data: body);
      return getCart();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH /cart/items/{id}/ → backend returns cart_summary + cart_item (not full Cart)
  Future<Cart> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      await _dio.patch(
        ApiEndpoints.cartItem(itemId),
        data: {'quantity': quantity},
      );
      return getCart();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE /cart/items/{id}/delete/ → backend returns 204 No Content
  Future<Cart> removeCartItem(String itemId) async {
    try {
      await _dio.delete(ApiEndpoints.cartItemDelete(itemId));
      return getCart();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE /cart/clear/ → backend returns 204 No Content
  Future<Cart> clearCart() async {
    try {
      await _dio.delete(ApiEndpoints.cartClear);
      return Cart.empty();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> applyCoupon(String couponCode) async {
    try {
      await _dio.post(
        ApiEndpoints.applyCoupon,
        data: {'coupon_code': couponCode},
      );
      return getCart();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> removeCoupon() async {
    try {
      await _dio.delete(ApiEndpoints.removeCoupon);
      return getCart();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) return e.error as AppException;
    return const UnknownException();
  }
}

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CartRepository(dio);
});
