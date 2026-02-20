from rest_framework import serializers

from apps.payments.models import Payment


class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = [
            'id', 'gateway', 'status',
            'amount', 'currency', 'amount_refunded',
            'gateway_order_id', 'gateway_payment_id',
            'failure_code', 'failure_description',
            'created_at', 'updated_at',
        ]
        read_only_fields = fields


class InitiatePaymentSerializer(serializers.Serializer):
    order_number = serializers.CharField(max_length=20)


class VerifyPaymentSerializer(serializers.Serializer):
    razorpay_order_id = serializers.CharField(max_length=255)
    razorpay_payment_id = serializers.CharField(max_length=255)
    razorpay_signature = serializers.CharField(max_length=512)


class RefundSerializer(serializers.Serializer):
    order_number = serializers.CharField(max_length=20)
    amount = serializers.DecimalField(
        max_digits=10, decimal_places=2,
        required=False, allow_null=True,
    )
    reason = serializers.CharField(max_length=255, required=False, allow_blank=True, default='')
