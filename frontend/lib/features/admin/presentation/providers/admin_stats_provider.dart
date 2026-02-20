import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_product_repository.dart';

/// Holds the parsed admin dashboard stats.
class AdminStats {
  // Overview
  final int totalUsers;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final String totalRevenue;

  // Today
  final int todayOrders;
  final int todayNewUsers;
  final String todayRevenue;

  // Product-type orders
  final int foodOrders;
  final int clothingOrders;

  // Product stats
  final int totalProducts;
  final int outOfStock;
  final int lowStock;
  final int foodProducts;
  final int clothingProducts;

  const AdminStats({
    required this.totalUsers,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.totalRevenue,
    required this.todayOrders,
    required this.todayNewUsers,
    required this.todayRevenue,
    required this.foodOrders,
    required this.clothingOrders,
    required this.totalProducts,
    required this.outOfStock,
    required this.lowStock,
    required this.foodProducts,
    required this.clothingProducts,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    final overview = json['overview'] as Map<String, dynamic>? ?? {};
    final today = json['today'] as Map<String, dynamic>? ?? {};
    final typeOrders = json['product_type_orders'] as Map<String, dynamic>? ?? {};
    final products = json['product_stats'] as Map<String, dynamic>? ?? {};

    return AdminStats(
      totalUsers: (overview['total_users'] as num?)?.toInt() ?? 0,
      totalOrders: (overview['total_orders'] as num?)?.toInt() ?? 0,
      pendingOrders: (overview['pending_orders'] as num?)?.toInt() ?? 0,
      completedOrders: (overview['completed_orders'] as num?)?.toInt() ?? 0,
      totalRevenue: overview['total_revenue']?.toString() ?? '0.00',
      todayOrders: (today['orders'] as num?)?.toInt() ?? 0,
      todayNewUsers: (today['new_users'] as num?)?.toInt() ?? 0,
      todayRevenue: today['revenue']?.toString() ?? '0.00',
      foodOrders: (typeOrders['food_orders'] as num?)?.toInt() ?? 0,
      clothingOrders: (typeOrders['clothing_orders'] as num?)?.toInt() ?? 0,
      totalProducts: (products['total_products'] as num?)?.toInt() ?? 0,
      outOfStock: (products['out_of_stock'] as num?)?.toInt() ?? 0,
      lowStock: (products['low_stock'] as num?)?.toInt() ?? 0,
      foodProducts: (products['food_products'] as num?)?.toInt() ?? 0,
      clothingProducts: (products['clothing_products'] as num?)?.toInt() ?? 0,
    );
  }
}

final adminStatsProvider =
    FutureProvider.autoDispose<AdminStats>((ref) async {
  final repository = ref.watch(adminProductRepositoryProvider);
  final data = await repository.getDashboardStats();
  return AdminStats.fromJson(data);
});
