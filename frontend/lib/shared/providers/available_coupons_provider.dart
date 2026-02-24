import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AvailableCoupon {
  final String id;
  final String code;
  final String discountType;
  final double discountValue;
  final double? maxDiscount;
  final double minOrderValue;
  final String validUntil;
  final List<String> applicableProductIds;

  const AvailableCoupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    required this.minOrderValue,
    required this.validUntil,
    this.applicableProductIds = const [],
  });

  factory AvailableCoupon.fromJson(Map<String, dynamic> json) {
    return AvailableCoupon(
      id: json['id'] as String,
      code: json['code'] as String,
      discountType: json['discount_type'] as String,
      discountValue: double.parse(json['discount_value'].toString()),
      maxDiscount: json['max_discount'] != null
          ? double.parse(json['max_discount'].toString())
          : null,
      minOrderValue: double.parse(json['min_order_value'].toString()),
      validUntil: json['valid_until'] as String,
      applicableProductIds: (json['applicable_products'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  String get discountLabel {
    if (discountType == 'PERCENTAGE') {
      final pct = discountValue.toStringAsFixed(0);
      if (maxDiscount != null) {
        return '$pct% OFF (up to ₹${maxDiscount!.toStringAsFixed(0)})';
      }
      return '$pct% OFF';
    }
    return '₹${discountValue.toStringAsFixed(0)} OFF';
  }

  bool get isForAllProducts => applicableProductIds.isEmpty;

  bool appliesToProduct(String productId) {
    return isForAllProducts || applicableProductIds.contains(productId);
  }
}

/// Fetches all available coupons for the current user.
final availableCouponsProvider =
    FutureProvider.autoDispose<List<AvailableCoupon>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(ApiEndpoints.availableCoupons);
  final body = response.data as Map<String, dynamic>;
  final data = body['data'] as Map<String, dynamic>? ?? body;
  final results = data['results'] as List? ?? [];
  return results
      .map((e) => AvailableCoupon.fromJson(e as Map<String, dynamic>))
      .toList();
});

/// Fetches available coupons for a specific product.
final productCouponsProvider = FutureProvider.autoDispose
    .family<List<AvailableCoupon>, String>((ref, productId) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(
    ApiEndpoints.availableCoupons,
    queryParameters: {'product_id': productId},
  );
  final body = response.data as Map<String, dynamic>;
  final data = body['data'] as Map<String, dynamic>? ?? body;
  final results = data['results'] as List? ?? [];
  return results
      .map((e) => AvailableCoupon.fromJson(e as Map<String, dynamic>))
      .toList();
});
