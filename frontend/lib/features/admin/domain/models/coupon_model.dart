class CouponProduct {
  final String id;
  final String name;
  final String slug;

  const CouponProduct({required this.id, required this.name, required this.slug});

  factory CouponProduct.fromJson(Map<String, dynamic> json) => CouponProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
      );
}

class CouponModel {
  final String id;
  final String code;
  final String discountType;
  final double discountValue;
  final double? maxDiscount;
  final double minOrderValue;
  final int? maxUsage;
  final int usagePerUser;
  final int usageCount;
  final String validFrom;
  final String validUntil;
  final bool isActive;
  final bool isValid;
  final List<CouponProduct> applicableProducts;

  const CouponModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    required this.minOrderValue,
    this.maxUsage,
    required this.usagePerUser,
    required this.usageCount,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.isValid,
    this.applicableProducts = const [],
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json['id'] as String,
        code: json['code'] as String,
        discountType: json['discount_type'] as String,
        discountValue: double.parse(json['discount_value'].toString()),
        maxDiscount: json['max_discount'] != null
            ? double.parse(json['max_discount'].toString())
            : null,
        minOrderValue: double.parse(json['min_order_value'].toString()),
        maxUsage: json['max_usage'] as int?,
        usagePerUser: (json['usage_per_user'] as num).toInt(),
        usageCount: (json['usage_count'] as num).toInt(),
        validFrom: json['valid_from'] as String,
        validUntil: json['valid_until'] as String,
        isActive: json['is_active'] as bool,
        isValid: json['is_valid'] as bool,
        applicableProducts: (json['applicable_products'] as List?)
                ?.map((e) => CouponProduct.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  String get discountLabel {
    if (discountType == 'PERCENTAGE') {
      return '${discountValue.toStringAsFixed(0)}% OFF';
    }
    return '₹${discountValue.toStringAsFixed(0)} OFF';
  }

  String get statusLabel {
    if (isActive && isValid) return 'Active';
    if (isActive) return 'Expired';
    return 'Inactive';
  }
}
