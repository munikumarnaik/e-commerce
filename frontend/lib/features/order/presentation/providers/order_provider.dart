import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/order_repository.dart';
import '../../domain/models/order_model.dart';

enum OrderListStatus { initial, loading, loaded, error }

class OrderListState {
  final OrderListStatus status;
  final List<Order> orders;
  final String? error;
  final String? selectedStatus; // null = All

  const OrderListState({
    this.status = OrderListStatus.initial,
    this.orders = const [],
    this.error,
    this.selectedStatus,
  });

  OrderListState copyWith({
    OrderListStatus? status,
    List<Order>? orders,
    String? error,
    String? selectedStatus,
    bool clearSelectedStatus = false,
  }) {
    return OrderListState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error,
      selectedStatus: clearSelectedStatus
          ? null
          : (selectedStatus ?? this.selectedStatus),
    );
  }
}

class OrderListNotifier extends StateNotifier<OrderListState> {
  final OrderRepository _repository;

  OrderListNotifier(this._repository) : super(const OrderListState());

  Future<void> loadOrders() async {
    state = state.copyWith(status: OrderListStatus.loading);
    try {
      final orders = await _repository.getOrdersByStatus(state.selectedStatus);
      state = state.copyWith(
        status: OrderListStatus.loaded,
        orders: orders,
      );
    } catch (e) {
      state = state.copyWith(
        status: OrderListStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> filterByStatus(String? status) async {
    if (status == null) {
      state = state.copyWith(clearSelectedStatus: true);
    } else {
      state = state.copyWith(selectedStatus: status);
    }
    await loadOrders();
  }

  Future<bool> cancelOrder(String orderNumber) async {
    try {
      await _repository.cancelOrder(orderNumber);
      await loadOrders();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> reorder(String orderNumber) async {
    try {
      return await _repository.reorder(orderNumber);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}

final orderListProvider =
    StateNotifierProvider<OrderListNotifier, OrderListState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderListNotifier(repository);
});

final orderDetailProvider =
    FutureProvider.autoDispose.family<Order, String>((ref, orderNumber) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrderDetail(orderNumber);
});

final orderTrackProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>(
        (ref, orderNumber) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.trackOrder(orderNumber);
});
