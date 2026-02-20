import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/order_model.dart';

class OrderRepository {
  final Dio _dio;

  OrderRepository(this._dio);

  Future<Map<String, dynamic>> createOrder({
    required String shippingAddressId,
    required String paymentMethod,
    String? customerNote,
    String? couponCode,
  }) async {
    try {
      final body = <String, dynamic>{
        'shipping_address_id': shippingAddressId,
        'payment_method': paymentMethod,
      };
      if (customerNote != null && customerNote.isNotEmpty) {
        body['customer_note'] = customerNote;
      }
      if (couponCode != null && couponCode.isNotEmpty) {
        body['coupon_code'] = couponCode;
      }
      final response = await _dio.post(ApiEndpoints.orderCreate, data: body);
      final data = response.data['data'] ?? response.data;
      return data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get(ApiEndpoints.orders);
      final data = response.data['data'] ?? response.data;
      final results = data['results'] as List? ?? data as List;
      return results
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Order> getOrderDetail(String orderNumber) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.orderDetail(orderNumber));
      final data = response.data['data'] ?? response.data;
      return Order.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelOrder(String orderNumber) async {
    try {
      await _dio.post(ApiEndpoints.orderCancel(orderNumber));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> reorder(String orderNumber) async {
    try {
      await _dio.post(ApiEndpoints.orderReorder(orderNumber));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) return e.error as AppException;
    return const UnknownException();
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio);
});
