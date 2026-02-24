import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/admin_product_repository.dart';
import '../../domain/models/coupon_model.dart';

class CouponListState {
  final List<CouponModel> coupons;
  final bool isLoading;
  final String? error;

  const CouponListState({
    this.coupons = const [],
    this.isLoading = false,
    this.error,
  });

  CouponListState copyWith({
    List<CouponModel>? coupons,
    bool? isLoading,
    String? error,
  }) =>
      CouponListState(
        coupons: coupons ?? this.coupons,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class CouponNotifier extends StateNotifier<CouponListState> {
  final AdminProductRepository _repository;

  CouponNotifier(this._repository) : super(const CouponListState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.getCoupons();
      final list = (data['results'] as List<dynamic>? ?? [])
          .map((e) => CouponModel.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(coupons: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggle(String id) async {
    try {
      final data = await _repository.toggleCoupon(id);
      final updated = CouponModel.fromJson(data);
      state = state.copyWith(
        coupons: state.coupons.map((c) => c.id == id ? updated : c).toList(),
      );
    } catch (_) {}
  }

  Future<void> delete(String id) async {
    try {
      await _repository.deleteCoupon(id);
      state = state.copyWith(
        coupons: state.coupons.where((c) => c.id != id).toList(),
      );
    } catch (_) {}
  }

  void addLocally(CouponModel coupon) {
    state = state.copyWith(coupons: [coupon, ...state.coupons]);
  }

  void updateLocally(CouponModel updated) {
    state = state.copyWith(
      coupons:
          state.coupons.map((c) => c.id == updated.id ? updated : c).toList(),
    );
  }
}

final couponProvider =
    StateNotifierProvider.autoDispose<CouponNotifier, CouponListState>((ref) {
  return CouponNotifier(ref.read(adminProductRepositoryProvider));
});
