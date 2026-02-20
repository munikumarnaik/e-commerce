import hashlib
import hmac
import json
from decimal import Decimal
from unittest.mock import MagicMock, patch

from django.conf import settings
from django.test import TestCase
from rest_framework import status
from rest_framework.exceptions import ValidationError
from rest_framework.test import APIClient

from apps.cart.services import add_to_cart
from apps.orders.models import Order
from apps.orders.services import create_order
from apps.payments.models import Payment
from apps.payments.services import (
    get_payment_status,
    initiate_payment,
    process_webhook,
    verify_razorpay_payment,
)
from apps.products.models import Category, Product, ProductVariant
from apps.users.models import Address, User


class PaymentTestMixin:
    """Shared setup for payment tests."""

    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            email='customer@test.com',
            username='customer',
            password='TestPass123!',
            first_name='Test',
            last_name='Customer',
        )
        self.vendor = User.objects.create_user(
            email='vendor@test.com',
            username='vendor',
            password='TestPass123!',
            first_name='Test',
            last_name='Vendor',
            role='VENDOR',
        )
        self.category = Category.objects.create(
            name='Shirts', slug='shirts', category_type='CLOTHING',
        )
        self.product = Product.objects.create(
            name='T-Shirt',
            slug='t-shirt',
            sku='TSH-001',
            product_type='CLOTHING',
            category=self.category,
            vendor=self.vendor,
            description='A t-shirt',
            price=Decimal('999.00'),
            stock_quantity=50,
            thumbnail='https://example.com/img.jpg',
        )
        self.variant = ProductVariant.objects.create(
            product=self.product,
            sku='TSH-001-M',
            size='M',
            color='Blue',
            color_hex='#0000FF',
            price=Decimal('999.00'),
            stock_quantity=10,
        )
        self.address = Address.objects.create(
            user=self.user,
            full_name='Test Customer',
            phone='+919876543210',
            address_line1='123 Street',
            city='Mumbai',
            state='Maharashtra',
            postal_code='400001',
        )

    def _create_cod_order(self):
        add_to_cart(self.user, self.product.id, self.variant.id, 1)
        return create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            payment_method='cod',
        )

    def _create_razorpay_order(self):
        add_to_cart(self.user, self.product.id, self.variant.id, 1)
        return create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            payment_method='razorpay',
        )


# ──────────────────────────────────────────────
# Payment Model Tests
# ──────────────────────────────────────────────
class PaymentModelTest(PaymentTestMixin, TestCase):
    def test_payment_str(self):
        order = self._create_cod_order()
        payment, _ = initiate_payment(self.user, order.order_number)
        self.assertIn(order.order_number, str(payment))
        self.assertIn('COD', str(payment))

    def test_cod_payment_is_successful(self):
        order = self._create_cod_order()
        payment, _ = initiate_payment(self.user, order.order_number)
        self.assertTrue(payment.is_successful)

    def test_pending_payment_not_successful(self):
        order = self._create_razorpay_order()
        payment = Payment.objects.create(
            order=order, user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
        )
        self.assertFalse(payment.is_successful)

    def test_razorpay_completed_is_refundable(self):
        order = self._create_razorpay_order()
        payment = Payment.objects.create(
            order=order, user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.COMPLETED,
            amount=order.total,
        )
        self.assertTrue(payment.is_refundable)

    def test_cod_not_refundable(self):
        order = self._create_cod_order()
        payment, _ = initiate_payment(self.user, order.order_number)
        self.assertFalse(payment.is_refundable)

    def test_refundable_amount(self):
        order = self._create_razorpay_order()
        payment = Payment.objects.create(
            order=order, user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.COMPLETED,
            amount=order.total,
            amount_refunded=Decimal('200.00'),
        )
        self.assertEqual(payment.refundable_amount, payment.amount - Decimal('200.00'))


# ──────────────────────────────────────────────
# COD Payment Service Tests
# ──────────────────────────────────────────────
class CODPaymentServiceTest(PaymentTestMixin, TestCase):
    def test_initiate_cod_payment(self):
        order = self._create_cod_order()
        payment, razorpay_order = initiate_payment(self.user, order.order_number)
        self.assertIsNone(razorpay_order)
        self.assertEqual(payment.gateway, Payment.Gateway.COD)
        self.assertEqual(payment.status, Payment.Status.COMPLETED)

    def test_cod_order_marked_paid(self):
        order = self._create_cod_order()
        initiate_payment(self.user, order.order_number)
        order.refresh_from_db()
        self.assertEqual(order.payment_status, Order.PaymentStatus.PAID)

    def test_cod_order_confirmed(self):
        order = self._create_cod_order()
        initiate_payment(self.user, order.order_number)
        order.refresh_from_db()
        self.assertEqual(order.status, Order.Status.CONFIRMED)

    def test_initiate_already_paid_fails(self):
        order = self._create_cod_order()
        initiate_payment(self.user, order.order_number)
        with self.assertRaises(ValidationError):
            initiate_payment(self.user, order.order_number)

    def test_initiate_nonexistent_order_fails(self):
        with self.assertRaises(ValidationError):
            initiate_payment(self.user, 'ORD-FAKE-000000')


# ──────────────────────────────────────────────
# Razorpay Payment Service Tests (mocked)
# ──────────────────────────────────────────────
class RazorpayPaymentServiceTest(PaymentTestMixin, TestCase):
    RZP_ORDER_ID = 'order_test123'
    RZP_PAYMENT_ID = 'pay_test456'

    def _make_signature(self, order_id, payment_id, secret='placeholder_secret'):
        return hmac.new(
            secret.encode(),
            f'{order_id}|{payment_id}'.encode(),
            hashlib.sha256,
        ).hexdigest()

    @patch('apps.payments.services._get_razorpay_client')
    def test_initiate_razorpay_payment(self, mock_client):
        mock_rp = MagicMock()
        mock_rp.order.create.return_value = {
            'id': self.RZP_ORDER_ID,
            'amount': 99900,
            'currency': 'INR',
        }
        mock_client.return_value = mock_rp

        order = self._create_razorpay_order()
        payment, rp_order = initiate_payment(self.user, order.order_number)

        self.assertEqual(payment.gateway, Payment.Gateway.RAZORPAY)
        self.assertEqual(payment.status, Payment.Status.PENDING)
        self.assertEqual(payment.gateway_order_id, self.RZP_ORDER_ID)
        self.assertIsNotNone(rp_order)

    def test_verify_valid_signature(self):
        order = self._create_razorpay_order()
        Payment.objects.create(
            order=order,
            user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
            gateway_order_id=self.RZP_ORDER_ID,
        )
        signature = self._make_signature(self.RZP_ORDER_ID, self.RZP_PAYMENT_ID)

        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            result = verify_razorpay_payment(
                self.user, self.RZP_ORDER_ID, self.RZP_PAYMENT_ID, signature,
            )

        result.refresh_from_db()
        self.assertEqual(result.status, Payment.Status.COMPLETED)
        order.refresh_from_db()
        self.assertEqual(order.payment_status, Order.PaymentStatus.PAID)
        self.assertEqual(order.status, Order.Status.CONFIRMED)

    def test_verify_invalid_signature_fails(self):
        order = self._create_razorpay_order()
        Payment.objects.create(
            order=order,
            user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
            gateway_order_id=self.RZP_ORDER_ID,
        )
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            with self.assertRaises(ValidationError):
                verify_razorpay_payment(
                    self.user, self.RZP_ORDER_ID, self.RZP_PAYMENT_ID, 'wrong_sig',
                )
        # Payment should be marked as FAILED
        p = Payment.objects.get(gateway_order_id=self.RZP_ORDER_ID)
        self.assertEqual(p.status, Payment.Status.FAILED)
        self.assertEqual(p.failure_code, 'SIGNATURE_MISMATCH')

    def test_verify_nonexistent_payment_fails(self):
        with self.assertRaises(ValidationError):
            verify_razorpay_payment(self.user, 'fake_order', 'fake_pay', 'fake_sig')

    def test_get_payment_status_with_payment(self):
        order = self._create_cod_order()
        initiate_payment(self.user, order.order_number)
        p = get_payment_status(self.user, order.order_number)
        self.assertIsNotNone(p)
        self.assertEqual(p.order, order)

    def test_get_payment_status_no_payment(self):
        order = self._create_razorpay_order()
        p = get_payment_status(self.user, order.order_number)
        self.assertIsNone(p)


# ──────────────────────────────────────────────
# Webhook Service Tests
# ──────────────────────────────────────────────
class WebhookServiceTest(PaymentTestMixin, TestCase):
    RZP_ORDER_ID = 'order_wh123'
    RZP_PAYMENT_ID = 'pay_wh456'

    def _make_webhook_sig(self, payload, secret='placeholder_secret'):
        body = json.dumps(payload, separators=(',', ':'))
        return hmac.new(secret.encode(), body.encode(), hashlib.sha256).hexdigest()

    def _captured_payload(self):
        return {
            'event': 'payment.captured',
            'payload': {'payment': {'entity': {
                'id': self.RZP_PAYMENT_ID,
                'order_id': self.RZP_ORDER_ID,
                'amount': 99900,
            }}}
        }

    def _failed_payload(self):
        return {
            'event': 'payment.failed',
            'payload': {'payment': {'entity': {
                'id': self.RZP_PAYMENT_ID,
                'order_id': self.RZP_ORDER_ID,
                'error_code': 'BAD_REQUEST_ERROR',
                'error_description': 'Payment failed',
            }}}
        }

    def _create_pending_payment(self, order):
        return Payment.objects.create(
            order=order,
            user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
            gateway_order_id=self.RZP_ORDER_ID,
        )

    def test_webhook_payment_captured(self):
        order = self._create_razorpay_order()
        self._create_pending_payment(order)
        payload = self._captured_payload()
        sig = self._make_webhook_sig(payload)
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            result = process_webhook(payload, sig)
        self.assertTrue(result)
        p = Payment.objects.get(gateway_order_id=self.RZP_ORDER_ID)
        self.assertEqual(p.status, Payment.Status.COMPLETED)
        order.refresh_from_db()
        self.assertEqual(order.payment_status, Order.PaymentStatus.PAID)

    def test_webhook_payment_failed(self):
        order = self._create_razorpay_order()
        self._create_pending_payment(order)
        payload = self._failed_payload()
        sig = self._make_webhook_sig(payload)
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            result = process_webhook(payload, sig)
        self.assertTrue(result)
        p = Payment.objects.get(gateway_order_id=self.RZP_ORDER_ID)
        self.assertEqual(p.status, Payment.Status.FAILED)
        order.refresh_from_db()
        self.assertEqual(order.payment_status, Order.PaymentStatus.FAILED)

    def test_webhook_invalid_signature(self):
        payload = self._captured_payload()
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            result = process_webhook(payload, 'bad_sig')
        self.assertFalse(result)

    def test_webhook_unknown_order_acknowledged(self):
        payload = self._captured_payload()
        sig = self._make_webhook_sig(payload)
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            result = process_webhook(payload, sig)
        self.assertTrue(result)  # Acknowledge even for unknown orders


# ──────────────────────────────────────────────
# Payment API Tests
# ──────────────────────────────────────────────
class PaymentAPITest(PaymentTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.client.force_authenticate(user=self.user)

    def test_initiate_cod_payment_api(self):
        order = self._create_cod_order()
        response = self.client.post('/api/v1/payments/initiate/', {
            'order_number': order.order_number,
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])
        self.assertIn('payment', response.data['data'])
        self.assertNotIn('razorpay', response.data['data'])

    @patch('apps.payments.services._get_razorpay_client')
    def test_initiate_razorpay_payment_api(self, mock_client):
        mock_rp = MagicMock()
        mock_rp.order.create.return_value = {
            'id': 'order_api_rp',
            'amount': 99900,
            'currency': 'INR',
        }
        mock_client.return_value = mock_rp
        order = self._create_razorpay_order()
        response = self.client.post('/api/v1/payments/initiate/', {
            'order_number': order.order_number,
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('razorpay', response.data['data'])
        self.assertEqual(response.data['data']['razorpay']['order_id'], 'order_api_rp')

    def test_initiate_nonexistent_order_api(self):
        response = self.client.post('/api/v1/payments/initiate/', {
            'order_number': 'ORD-FAKE-000000',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_verify_payment_api_success(self):
        RZP_ORDER_ID = 'order_api_verify'
        RZP_PAYMENT_ID = 'pay_api_verify'
        order = self._create_razorpay_order()
        Payment.objects.create(
            order=order,
            user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
            gateway_order_id=RZP_ORDER_ID,
        )
        signature = hmac.new(
            b'placeholder_secret',
            f'{RZP_ORDER_ID}|{RZP_PAYMENT_ID}'.encode(),
            hashlib.sha256,
        ).hexdigest()
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            response = self.client.post('/api/v1/payments/verify/', {
                'razorpay_order_id': RZP_ORDER_ID,
                'razorpay_payment_id': RZP_PAYMENT_ID,
                'razorpay_signature': signature,
            }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(response.data['data']['payment_status'], 'PAID')

    def test_verify_invalid_signature_api(self):
        RZP_ORDER_ID = 'order_api_badsig'
        order = self._create_razorpay_order()
        Payment.objects.create(
            order=order, user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
            gateway_order_id=RZP_ORDER_ID,
        )
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            response = self.client.post('/api/v1/payments/verify/', {
                'razorpay_order_id': RZP_ORDER_ID,
                'razorpay_payment_id': 'pay_fake',
                'razorpay_signature': 'bad_sig',
            }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_payment_status_api_with_payment(self):
        order = self._create_cod_order()
        initiate_payment(self.user, order.order_number)
        response = self.client.get(f'/api/v1/payments/{order.order_number}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data['data']['payment'])

    def test_payment_status_api_no_payment(self):
        order = self._create_razorpay_order()
        response = self.client.get(f'/api/v1/payments/{order.order_number}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNone(response.data['data']['payment'])

    def test_webhook_api_with_valid_signature(self):
        order = self._create_razorpay_order()
        Payment.objects.create(
            order=order, user=self.user,
            gateway=Payment.Gateway.RAZORPAY,
            status=Payment.Status.PENDING,
            amount=order.total,
            gateway_order_id='order_wh_api_test',
        )
        payload = {
            'event': 'payment.captured',
            'payload': {'payment': {'entity': {
                'id': 'pay_wh_api_test',
                'order_id': 'order_wh_api_test',
                'amount': 99900,
            }}}
        }
        body = json.dumps(payload, separators=(',', ':'))
        signature = hmac.new(b'placeholder_secret', body.encode(), hashlib.sha256).hexdigest()
        with self.settings(RAZORPAY_KEY_SECRET='placeholder_secret'):
            response = self.client.post(
                '/api/v1/payments/webhook/',
                data=payload,
                format='json',
                HTTP_X_RAZORPAY_SIGNATURE=signature,
            )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_webhook_missing_signature(self):
        response = self.client.post('/api/v1/payments/webhook/', data={}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_payment_unauthenticated(self):
        self.client.force_authenticate(user=None)
        response = self.client.post('/api/v1/payments/initiate/', {
            'order_number': 'ORD-2026-000000',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
