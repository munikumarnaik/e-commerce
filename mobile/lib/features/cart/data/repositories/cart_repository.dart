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

  Future<Cart> addToCart({
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
      final response = await _dio.post(ApiEndpoints.cartAdd, data: data);
      final cartData = response.data['data'] ?? response.data;
      return Cart.fromJson(cartData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.cartItem(itemId),
        data: {'quantity': quantity},
      );
      final data = response.data['data'] ?? response.data;
      return Cart.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> removeCartItem(String itemId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.cartItem(itemId));
      final data = response.data['data'] ?? response.data;
      return Cart.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> clearCart() async {
    try {
      final response = await _dio.delete(ApiEndpoints.cartClear);
      final data = response.data['data'] ?? response.data;
      return Cart.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> applyCoupon(String couponCode) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.applyCoupon,
        data: {'coupon_code': couponCode},
      );
      final data = response.data['data'] ?? response.data;
      return Cart.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Cart> removeCoupon() async {
    try {
      final response = await _dio.delete(ApiEndpoints.removeCoupon);
      final data = response.data['data'] ?? response.data;
      return Cart.fromJson(data as Map<String, dynamic>);
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
