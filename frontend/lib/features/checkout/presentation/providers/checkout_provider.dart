import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../order/data/repositories/order_repository.dart';

enum CheckoutStatus {
  idle,
  processing,
  success,          // COD order confirmed — go to order success
  pendingPayment,   // ONLINE order created — go to payment screen
  error,
}

class CheckoutState {
  final CheckoutStatus status;
  final String? selectedAddressId;
  final String paymentMethod;
  final String customerNote;
  final String? error;
  final String? orderNumber;
  final String? orderId;
  final double orderTotal; // captured for routing to payment screen

  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.selectedAddressId,
    this.paymentMethod = 'COD',
    this.customerNote = '',
    this.error,
    this.orderNumber,
    this.orderId,
    this.orderTotal = 0.0,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? selectedAddressId,
    String? paymentMethod,
    String? customerNote,
    String? error,
    String? orderNumber,
    String? orderId,
    double? orderTotal,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerNote: customerNote ?? this.customerNote,
      error: error,
      orderNumber: orderNumber ?? this.orderNumber,
      orderId: orderId ?? this.orderId,
      orderTotal: orderTotal ?? this.orderTotal,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final OrderRepository _orderRepository;
  final Ref _ref;

  CheckoutNotifier(this._orderRepository, this._ref)
      : super(const CheckoutState());

  void selectAddress(String addressId) {
    state = state.copyWith(selectedAddressId: addressId);
  }

  void updatePaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void updateNote(String note) {
    state = state.copyWith(customerNote: note);
  }

  Future<bool> placeOrder({String? couponCode, double? cartTotal}) async {
    if (state.selectedAddressId == null) {
      state = state.copyWith(
        status: CheckoutStatus.error,
        error: 'Please select a delivery address',
      );
      return false;
    }

    state = state.copyWith(status: CheckoutStatus.processing);
    try {
      final result = await _orderRepository.createOrder(
        shippingAddressId: state.selectedAddressId!,
        paymentMethod: state.paymentMethod,
        customerNote:
            state.customerNote.isNotEmpty ? state.customerNote : null,
        couponCode: couponCode,
      );

      final orderNumber = result['order_number'] as String?;
      final orderId = result['order_id']?.toString();
      final total = cartTotal ??
          double.tryParse(result['total']?.toString() ?? '0') ??
          0.0;

      if (state.paymentMethod == 'ONLINE') {
        // Order created — send user to payment gateway
        state = state.copyWith(
          status: CheckoutStatus.pendingPayment,
          orderNumber: orderNumber,
          orderId: orderId,
          orderTotal: total,
        );
      } else {
        // COD — order fully confirmed
        state = state.copyWith(
          status: CheckoutStatus.success,
          orderNumber: orderNumber,
          orderId: orderId,
        );
        // Refresh cart
        _ref.read(cartProvider.notifier).loadCart();
      }

      return true;
    } catch (e) {
      state = state.copyWith(
        status: CheckoutStatus.error,
        error: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const CheckoutState();
  }
}

final checkoutProvider =
    StateNotifierProvider.autoDispose<CheckoutNotifier, CheckoutState>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return CheckoutNotifier(orderRepository, ref);
});
