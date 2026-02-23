import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/payment_model.dart';

class PaymentRepository {
  final Dio _dio;

  PaymentRepository(this._dio);

  /// POST /payments/initiate/ — creates a payment record and Razorpay order.
  Future<PaymentInitiateResult> initiatePayment(String orderNumber) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.paymentInitiate,
        data: {'order_number': orderNumber},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final paymentJson = data['payment'] as Map<String, dynamic>;
      final razorpayJson = data['razorpay'] as Map<String, dynamic>?;

      RazorpayOrderData? razorpayData;
      if (razorpayJson != null) {
        razorpayData = RazorpayOrderData(
          orderId: razorpayJson['order_id']?.toString() ?? '',
          amount: (razorpayJson['amount'] as num?)?.toInt() ?? 0,
          currency: razorpayJson['currency']?.toString() ?? 'INR',
          keyId: razorpayJson['key_id']?.toString() ?? '',
        );
      }

      return PaymentInitiateResult(
        payment: PaymentRecord.fromJson(paymentJson),
        razorpay: razorpayData,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /payments/verify/ — verifies the Razorpay payment signature.
  Future<PaymentVerifyResult> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.paymentVerify,
        data: {
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
      );
      return PaymentVerifyResult.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GET /payments/{order_number}/ — polls payment status.
  Future<PaymentRecord?> getPaymentStatus(String orderNumber) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.paymentStatus(orderNumber));
      final payment = response.data['data']['payment'];
      if (payment == null) return null;
      return PaymentRecord.fromJson(payment as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) return e.error as AppException;
    final msg = e.response?.data?['message']?.toString() ??
        e.message ??
        'Payment error. Please try again.';
    return NetworkException(msg);
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(dioProvider));
});
