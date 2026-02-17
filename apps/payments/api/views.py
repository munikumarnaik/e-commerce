import logging

from django.conf import settings
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.payments import services
from apps.payments.api.serializers import (
    InitiatePaymentSerializer,
    PaymentSerializer,
    RefundSerializer,
    VerifyPaymentSerializer,
)

logger = logging.getLogger(__name__)


class PaymentInitiateView(APIView):
    """POST /payments/initiate/ — Create a payment intent for an order."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = InitiatePaymentSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        payment, razorpay_order = services.initiate_payment(
            user=request.user,
            order_number=serializer.validated_data['order_number'],
        )

        data = {
            'payment': PaymentSerializer(payment).data,
        }
        if razorpay_order:
            data['razorpay'] = {
                'order_id': razorpay_order['id'],
                'amount': razorpay_order['amount'],
                'currency': razorpay_order['currency'],
                'key_id': settings.RAZORPAY_KEY_ID,
            }

        return Response({
            'success': True,
            'data': data,
            'message': 'Payment initiated.' if razorpay_order else 'COD order confirmed.',
        }, status=status.HTTP_201_CREATED)


class PaymentVerifyView(APIView):
    """POST /payments/verify/ — Verify a Razorpay payment."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = VerifyPaymentSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        payment = services.verify_razorpay_payment(
            user=request.user,
            razorpay_order_id=data['razorpay_order_id'],
            razorpay_payment_id=data['razorpay_payment_id'],
            razorpay_signature=data['razorpay_signature'],
        )

        return Response({
            'success': True,
            'data': {
                'order_number': payment.order.order_number,
                'payment_status': payment.order.payment_status,
                'transaction_id': payment.gateway_payment_id,
            },
            'message': 'Payment verified successfully.',
        })


class PaymentWebhookView(APIView):
    """POST /payments/webhook/ — Receive Razorpay webhook events."""
    permission_classes = [AllowAny]
    authentication_classes = []  # No JWT for webhooks

    def post(self, request, *args, **kwargs):
        razorpay_signature = request.headers.get('X-Razorpay-Signature', '')

        if not razorpay_signature:
            return Response({'success': False}, status=status.HTTP_400_BAD_REQUEST)

        try:
            success = services.process_webhook(
                payload=request.data,
                razorpay_signature=razorpay_signature,
            )
        except Exception as exc:
            logger.exception('Webhook processing error: %s', exc)
            return Response({'success': False}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        if success:
            return Response({'success': True})
        return Response({'success': False}, status=status.HTTP_400_BAD_REQUEST)


class PaymentStatusView(APIView):
    """GET /payments/{order_number}/ — Get payment status for an order."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        order_number = kwargs.get('order_number')
        payment = services.get_payment_status(
            user=request.user,
            order_number=order_number,
        )

        if not payment:
            return Response({
                'success': True,
                'data': {'payment': None},
                'message': 'No payment found for this order.',
            })

        return Response({
            'success': True,
            'data': {'payment': PaymentSerializer(payment).data},
        })


class PaymentRefundView(APIView):
    """POST /payments/refund/ — Initiate a refund (admin/internal)."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = RefundSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        payment, refund = services.initiate_refund(
            user=request.user,
            order_number=data['order_number'],
            amount=data.get('amount'),
            reason=data.get('reason', ''),
        )

        return Response({
            'success': True,
            'data': {
                'payment': PaymentSerializer(payment).data,
                'refund_id': refund['id'],
                'amount_refunded': str(data.get('amount') or payment.refundable_amount),
            },
            'message': 'Refund initiated successfully.',
        })
