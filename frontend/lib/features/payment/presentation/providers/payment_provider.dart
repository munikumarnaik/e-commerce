import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/payment_repository.dart';
import '../../domain/models/payment_model.dart';

enum PaymentFlowStatus {
  idle,
  initiating,
  awaitingPayment, // Razorpay data ready → SDK about to open
  processing,      // User paid → verifying with backend
  success,
  failed,
}

class PaymentState {
  final PaymentFlowStatus status;
  final String? error;
  final String? transactionId;
  final PaymentInitiateResult? initiateResult;

  const PaymentState({
    this.status = PaymentFlowStatus.idle,
    this.error,
    this.transactionId,
    this.initiateResult,
  });

  PaymentState copyWith({
    PaymentFlowStatus? status,
    String? error,
    String? transactionId,
    PaymentInitiateResult? initiateResult,
  }) {
    return PaymentState(
      status: status ?? this.status,
      error: error,
      transactionId: transactionId ?? this.transactionId,
      initiateResult: initiateResult ?? this.initiateResult,
    );
  }

  bool get isLoading =>
      status == PaymentFlowStatus.initiating ||
      status == PaymentFlowStatus.processing;
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository) : super(const PaymentState());

  /// Calls the backend to create a Razorpay order (or confirm COD).
  Future<void> initiatePayment(String orderNumber) async {
    state = state.copyWith(status: PaymentFlowStatus.initiating, error: null);
    try {
      final result = await _repository.initiatePayment(orderNumber);
      state = state.copyWith(
        status: PaymentFlowStatus.awaitingPayment,
        initiateResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        status: PaymentFlowStatus.failed,
        error: _sanitizeError(e.toString()),
      );
    }
  }

  /// Called after Razorpay SDK reports success — verifies signature with backend.
  Future<void> verifyAndComplete({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    state = state.copyWith(status: PaymentFlowStatus.processing, error: null);
    try {
      final result = await _repository.verifyPayment(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );
      state = state.copyWith(
        status: PaymentFlowStatus.success,
        transactionId: result.transactionId,
      );
    } catch (e) {
      state = state.copyWith(
        status: PaymentFlowStatus.failed,
        error: _sanitizeError(e.toString()),
      );
    }
  }

  /// Called when Razorpay SDK reports failure or user cancels.
  void setFailed(String error) {
    state = state.copyWith(
      status: PaymentFlowStatus.failed,
      error: error,
    );
  }

  /// Reset state for retry.
  void reset() {
    state = const PaymentState();
  }

  String _sanitizeError(String raw) =>
      raw.replaceAll(RegExp(r'Exception:|AppException:'), '').trim();
}

final paymentProvider =
    StateNotifierProvider.autoDispose<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref.watch(paymentRepositoryProvider));
});
