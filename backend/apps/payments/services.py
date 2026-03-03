import hashlib
import hmac
import logging
from decimal import Decimal

from django.conf import settings
from django.db import transaction
from rest_framework.exceptions import ValidationError

from apps.orders.models import Order
from apps.orders.services import cancel_order, update_order_status
from apps.payments.models import Payment

logger = logging.getLogger(__name__)


def _get_razorpay_client():
    """Return a Razorpay client instance."""
    import razorpay
    return razorpay.Client(
        auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET)
    )


@transaction.atomic
def initiate_payment(user, order_number):
    """
    Create a Razorpay order for a given Order.
    Returns (payment, razorpay_order) where razorpay_order is the
    dict returned by the Razorpay API (or None for COD).
    """
    try:
        order = Order.objects.get(order_number=order_number, user=user)
    except Order.DoesNotExist:
        raise ValidationError({'order': 'Order not found.'})

    if order.payment_status == Order.PaymentStatus.PAID:
        raise ValidationError({'order': 'This order has already been paid.'})

    if order.payment_method == 'cod':
        # COD — record a completed payment immediately
        payment = Payment.objects.create(
            order=order,
            user=user,
            gateway=Payment.Gateway.COD,
            status=Payment.Status.COMPLETED,
            amount=order.total,
            currency='INR',
        )
        _mark_order_paid(order, payment)
        return payment, None

    # Razorpay — create order on gateway
    if not settings.RAZORPAY_KEY_ID:
        raise ValidationError({'payment': 'Payment gateway is not configured.'})

    client = _get_razorpay_client()
    # Razorpay amount is in paise (1 INR = 100 paise)
    amount_paise = int(order.total * 100)
    razorpay_order = client.order.create({
        'amount': amount_paise,
        'currency': 'INR',
        'receipt': order.order_number,
        'notes': {
            'order_number': order.order_number,
            'user_id': str(user.id),
        },
    })

    payment = Payment.objects.create(
        order=order,
        user=user,
        gateway=Payment.Gateway.RAZORPAY,
        status=Payment.Status.PENDING,
        amount=order.total,
        currency='INR',
        gateway_order_id=razorpay_order['id'],
    )

    return payment, razorpay_order


def verify_razorpay_payment(user, razorpay_order_id, razorpay_payment_id, razorpay_signature):
    """
    Verify a Razorpay payment using HMAC-SHA256 signature.
    Updates the payment and order status on success.
    """
    try:
        payment = Payment.objects.select_related('order').get(
            gateway_order_id=razorpay_order_id,
            user=user,
            gateway=Payment.Gateway.RAZORPAY,
        )
    except Payment.DoesNotExist:
        raise ValidationError({'payment': 'Payment record not found.'})

    if payment.status == Payment.Status.COMPLETED:
        raise ValidationError({'payment': 'Payment already verified.'})

    # Verify HMAC-SHA256 signature
    expected_signature = hmac.new(
        settings.RAZORPAY_KEY_SECRET.encode(),
        f'{razorpay_order_id}|{razorpay_payment_id}'.encode(),
        hashlib.sha256,
    ).hexdigest()

    if not hmac.compare_digest(expected_signature, razorpay_signature):
        payment.status = Payment.Status.FAILED
        payment.failure_code = 'SIGNATURE_MISMATCH'
        payment.failure_description = 'Payment signature verification failed.'
        payment.save(update_fields=['status', 'failure_code', 'failure_description', 'updated_at'])
        raise ValidationError({'signature': 'Invalid payment signature.'})

    # Mark payment as completed and order as paid (atomically)
    with transaction.atomic():
        payment.status = Payment.Status.COMPLETED
        payment.gateway_payment_id = razorpay_payment_id
        payment.gateway_signature = razorpay_signature
        payment.save(update_fields=[
            'status', 'gateway_payment_id', 'gateway_signature', 'updated_at',
        ])
        _mark_order_paid(payment.order, payment)

    return payment


def _mark_order_paid(order, payment):
    """Update order payment fields and transition to CONFIRMED."""
    order.payment_status = Order.PaymentStatus.PAID
    order.payment_id = payment.gateway_payment_id
    order.transaction_id = payment.gateway_payment_id or str(payment.id)
    order.save(update_fields=['payment_status', 'payment_id', 'transaction_id', 'updated_at'])

    # Auto-confirm order on successful payment
    if order.can_transition_to('CONFIRMED'):
        update_order_status(order, 'CONFIRMED', notes='Payment received.')

    # Clear the cart now that payment is confirmed
    from apps.cart.services import get_or_create_cart
    try:
        cart = get_or_create_cart(order.user)
        cart.clear_items()
    except Exception:
        pass


@transaction.atomic
def process_webhook(payload, razorpay_signature):
    """
    Process Razorpay webhook events.
    Verifies the webhook signature and handles the event.
    """
    if not settings.RAZORPAY_KEY_SECRET:
        return False

    # Verify webhook signature
    import json
    body = json.dumps(payload, separators=(',', ':'))
    expected = hmac.new(
        settings.RAZORPAY_KEY_SECRET.encode(),
        body.encode(),
        hashlib.sha256,
    ).hexdigest()

    if not hmac.compare_digest(expected, razorpay_signature):
        logger.warning('Razorpay webhook signature mismatch')
        return False

    event = payload.get('event', '')
    entity = payload.get('payload', {}).get('payment', {}).get('entity', {})

    razorpay_payment_id = entity.get('id', '')
    razorpay_order_id = entity.get('order_id', '')

    if not razorpay_payment_id or not razorpay_order_id:
        return True  # Unknown event, acknowledge

    try:
        payment = Payment.objects.select_related('order').get(
            gateway_order_id=razorpay_order_id,
            gateway=Payment.Gateway.RAZORPAY,
        )
    except Payment.DoesNotExist:
        logger.warning('Webhook: payment not found for order_id=%s', razorpay_order_id)
        return True  # Acknowledge even if not found

    # Store raw webhook data
    payment.webhook_data = payload

    if event == 'payment.captured':
        if payment.status != Payment.Status.COMPLETED:
            payment.status = Payment.Status.COMPLETED
            payment.gateway_payment_id = razorpay_payment_id
            payment.save(update_fields=['status', 'gateway_payment_id', 'webhook_data', 'updated_at'])
            _mark_order_paid(payment.order, payment)

    elif event == 'payment.failed':
        payment.status = Payment.Status.FAILED
        payment.failure_code = entity.get('error_code', '')
        payment.failure_description = entity.get('error_description', '')
        payment.save(update_fields=[
            'status', 'failure_code', 'failure_description', 'webhook_data', 'updated_at',
        ])
        # Cancel the order and restore stock
        if payment.order.is_cancellable:
            try:
                cancel_order(
                    user=payment.order.user,
                    order_number=payment.order.order_number,
                    reason='Payment failed — order auto-cancelled.',
                )
            except Exception:
                # Fallback: at least mark payment status as FAILED
                payment.order.payment_status = Order.PaymentStatus.FAILED
                payment.order.save(update_fields=['payment_status', 'updated_at'])
        else:
            payment.order.payment_status = Order.PaymentStatus.FAILED
            payment.order.save(update_fields=['payment_status', 'updated_at'])

    elif event in ('refund.created', 'refund.processed'):
        refund_entity = payload.get('payload', {}).get('refund', {}).get('entity', {})
        refund_amount = Decimal(str(refund_entity.get('amount', 0))) / 100  # paise to INR
        payment.amount_refunded += refund_amount
        payment.refund_id = refund_entity.get('id', '')
        if payment.amount_refunded >= payment.amount:
            payment.status = Payment.Status.REFUNDED
            payment.order.payment_status = Order.PaymentStatus.REFUNDED
            payment.order.save(update_fields=['payment_status', 'updated_at'])
        else:
            payment.status = Payment.Status.PARTIALLY_REFUNDED
        payment.save(update_fields=[
            'status', 'amount_refunded', 'refund_id', 'webhook_data', 'updated_at',
        ])

    else:
        payment.save(update_fields=['webhook_data', 'updated_at'])

    return True


@transaction.atomic
def initiate_refund(user, order_number, amount=None, reason=''):
    """
    Initiate a refund for a completed Razorpay payment.
    `amount` in INR — if None, full refund.
    """
    try:
        order = Order.objects.get(order_number=order_number, user=user)
    except Order.DoesNotExist:
        raise ValidationError({'order': 'Order not found.'})

    try:
        payment = Payment.objects.get(
            order=order,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.COMPLETED,
        )
    except Payment.DoesNotExist:
        raise ValidationError({'payment': 'No completed Razorpay payment found for this order.'})

    if not payment.is_refundable:
        raise ValidationError({'payment': 'This payment cannot be refunded.'})

    refund_amount = amount or payment.refundable_amount
    if refund_amount <= 0:
        raise ValidationError({'amount': 'Refund amount must be greater than zero.'})
    if refund_amount > payment.refundable_amount:
        raise ValidationError({
            'amount': f'Refund amount cannot exceed {payment.refundable_amount} INR.',
        })

    client = _get_razorpay_client()
    refund_paise = int(refund_amount * 100)

    refund = client.payment.refund(payment.gateway_payment_id, {
        'amount': refund_paise,
        'notes': {'reason': reason or 'Customer refund'},
    })

    payment.amount_refunded += refund_amount
    payment.refund_id = refund['id']
    if payment.amount_refunded >= payment.amount:
        payment.status = Payment.Status.REFUNDED
        order.payment_status = Order.PaymentStatus.REFUNDED
        order.save(update_fields=['payment_status', 'updated_at'])
    else:
        payment.status = Payment.Status.PARTIALLY_REFUNDED

    payment.save(update_fields=['status', 'amount_refunded', 'refund_id', 'updated_at'])

    return payment, refund


def get_payment_status(user, order_number):
    """Get the latest payment for an order."""
    try:
        order = Order.objects.get(order_number=order_number, user=user)
    except Order.DoesNotExist:
        raise ValidationError({'order': 'Order not found.'})

    payment = Payment.objects.filter(order=order).order_by('-created_at').first()
    return payment
