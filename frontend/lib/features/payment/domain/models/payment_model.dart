/// Razorpay order data returned by the backend after initiating a payment.
class RazorpayOrderData {
  final String orderId;
  final int amount; // in paise (₹1 = 100 paise)
  final String currency;
  final String keyId;

  const RazorpayOrderData({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.keyId,
  });
}

/// A payment record as stored in the backend.
class PaymentRecord {
  final String id;
  final String gateway;
  final String status;
  final String amount;
  final String currency;
  final String? gatewayPaymentId;
  final String? failureCode;
  final String? failureDescription;

  const PaymentRecord({
    required this.id,
    required this.gateway,
    required this.status,
    required this.amount,
    required this.currency,
    this.gatewayPaymentId,
    this.failureCode,
    this.failureDescription,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id']?.toString() ?? '',
      gateway: json['gateway']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      amount: json['amount']?.toString() ?? '0.00',
      currency: json['currency']?.toString() ?? 'INR',
      gatewayPaymentId: json['gateway_payment_id']?.toString(),
      failureCode: json['failure_code']?.toString(),
      failureDescription: json['failure_description']?.toString(),
    );
  }

  bool get isSuccessful => status == 'COMPLETED';
  bool get isFailed => status == 'FAILED';
  bool get isPending => status == 'PENDING' || status == 'PROCESSING';
}

/// Full result returned from /payments/initiate/.
class PaymentInitiateResult {
  final PaymentRecord payment;
  final RazorpayOrderData? razorpay; // null for COD

  const PaymentInitiateResult({
    required this.payment,
    this.razorpay,
  });

  bool get isOnlinePayment => razorpay != null;
}

/// Result returned after successful payment verification.
class PaymentVerifyResult {
  final String orderNumber;
  final String paymentStatus;
  final String? transactionId;

  const PaymentVerifyResult({
    required this.orderNumber,
    required this.paymentStatus,
    this.transactionId,
  });

  factory PaymentVerifyResult.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyResult(
      orderNumber: json['order_number']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      transactionId: json['transaction_id']?.toString(),
    );
  }
}
