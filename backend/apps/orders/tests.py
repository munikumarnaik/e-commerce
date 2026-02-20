from datetime import timedelta
from decimal import Decimal

from django.test import TestCase
from django.utils import timezone
from rest_framework import status
from rest_framework.exceptions import ValidationError
from rest_framework.test import APIClient

from apps.cart.services import add_to_cart, get_or_create_cart
from apps.orders.models import Coupon, Order, OrderItem, OrderStatusHistory
from apps.orders.services import (
    apply_coupon_to_cart,
    cancel_order,
    create_order,
    remove_coupon_from_cart,
    reorder,
    update_order_status,
    validate_coupon,
)
from apps.products.models import Category, Product, ProductVariant
from apps.users.models import Address, User


class OrderTestMixin:
    """Shared setup for order tests."""

    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            email='customer@test.com',
            username='customer',
            password='TestPass123!',
            first_name='Test',
            last_name='Customer',
            role='CUSTOMER',
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
            name='T-Shirts',
            slug='tshirts',
            category_type='CLOTHING',
        )

        self.product = Product.objects.create(
            name='Cotton T-Shirt',
            slug='cotton-tshirt',
            sku='CLO-TSH-001',
            product_type='CLOTHING',
            category=self.category,
            vendor=self.vendor,
            description='A comfortable cotton t-shirt',
            price=Decimal('999.00'),
            stock_quantity=50,
            thumbnail='https://example.com/img.jpg',
        )

        self.product2 = Product.objects.create(
            name='Silk Shirt',
            slug='silk-shirt',
            sku='CLO-SLK-001',
            product_type='CLOTHING',
            category=self.category,
            vendor=self.vendor,
            description='A luxurious silk shirt',
            price=Decimal('2499.00'),
            stock_quantity=20,
            thumbnail='https://example.com/img2.jpg',
        )

        self.variant = ProductVariant.objects.create(
            product=self.product,
            sku='CLO-TSH-001-RED-M',
            size='M',
            color='Red',
            color_hex='#FF0000',
            price=Decimal('999.00'),
            stock_quantity=10,
        )

        # Address
        self.address = Address.objects.create(
            user=self.user,
            full_name='Test Customer',
            phone='+919876543210',
            address_line1='123 Test Street',
            city='Mumbai',
            state='Maharashtra',
            postal_code='400001',
            is_default=True,
        )

    def _create_coupon(self, **overrides):
        defaults = {
            'code': 'SAVE10',
            'discount_type': 'PERCENTAGE',
            'discount_value': Decimal('10'),
            'min_order_value': Decimal('500'),
            'valid_from': timezone.now() - timedelta(days=1),
            'valid_until': timezone.now() + timedelta(days=30),
            'is_active': True,
        }
        defaults.update(overrides)
        return Coupon.objects.create(**defaults)

    def _add_items_to_cart(self):
        """Add items to cart and return the cart."""
        add_to_cart(self.user, self.product.id, self.variant.id, 2)
        add_to_cart(self.user, self.product2.id, quantity=1)
        return get_or_create_cart(self.user)


# ──────────────────────────────────────────────
# Coupon Model Tests
# ──────────────────────────────────────────────
class CouponModelTest(OrderTestMixin, TestCase):
    def test_create_coupon(self):
        coupon = self._create_coupon()
        self.assertEqual(coupon.code, 'SAVE10')
        self.assertTrue(coupon.is_valid)
        self.assertTrue(coupon.is_active)

    def test_coupon_str(self):
        coupon = self._create_coupon()
        self.assertIn('SAVE10', str(coupon))

    def test_coupon_expired(self):
        coupon = self._create_coupon(
            valid_from=timezone.now() - timedelta(days=30),
            valid_until=timezone.now() - timedelta(days=1),
        )
        self.assertFalse(coupon.is_valid)

    def test_coupon_not_yet_valid(self):
        coupon = self._create_coupon(
            valid_from=timezone.now() + timedelta(days=1),
            valid_until=timezone.now() + timedelta(days=30),
        )
        self.assertFalse(coupon.is_valid)

    def test_coupon_inactive(self):
        coupon = self._create_coupon(is_active=False)
        self.assertFalse(coupon.is_valid)

    def test_coupon_max_usage_reached(self):
        coupon = self._create_coupon(max_usage=5, usage_count=5)
        self.assertFalse(coupon.is_valid)

    def test_percentage_discount(self):
        coupon = self._create_coupon(
            discount_type='PERCENTAGE',
            discount_value=Decimal('10'),
        )
        discount = coupon.calculate_discount(Decimal('1000.00'))
        self.assertEqual(discount, Decimal('100.00'))

    def test_percentage_discount_with_max(self):
        coupon = self._create_coupon(
            discount_type='PERCENTAGE',
            discount_value=Decimal('20'),
            max_discount=Decimal('150.00'),
        )
        discount = coupon.calculate_discount(Decimal('1000.00'))
        self.assertEqual(discount, Decimal('150.00'))

    def test_fixed_discount(self):
        coupon = self._create_coupon(
            discount_type='FIXED',
            discount_value=Decimal('200.00'),
        )
        discount = coupon.calculate_discount(Decimal('1000.00'))
        self.assertEqual(discount, Decimal('200.00'))

    def test_fixed_discount_capped_at_subtotal(self):
        coupon = self._create_coupon(
            discount_type='FIXED',
            discount_value=Decimal('5000.00'),
        )
        discount = coupon.calculate_discount(Decimal('1000.00'))
        self.assertEqual(discount, Decimal('1000.00'))

    def test_discount_below_min_order(self):
        coupon = self._create_coupon(min_order_value=Decimal('2000'))
        discount = coupon.calculate_discount(Decimal('500.00'))
        self.assertEqual(discount, Decimal('0.00'))


# ──────────────────────────────────────────────
# Coupon Validation Service Tests
# ──────────────────────────────────────────────
class CouponValidationTest(OrderTestMixin, TestCase):
    def test_validate_valid_coupon(self):
        coupon = self._create_coupon()
        validated, discount = validate_coupon('SAVE10', self.user, Decimal('1000'))
        self.assertEqual(validated.id, coupon.id)
        self.assertEqual(discount, Decimal('100.00'))

    def test_validate_case_insensitive(self):
        self._create_coupon()
        validated, discount = validate_coupon('save10', self.user, Decimal('1000'))
        self.assertIsNotNone(validated)

    def test_validate_invalid_code(self):
        with self.assertRaises(ValidationError):
            validate_coupon('INVALID', self.user, Decimal('1000'))

    def test_validate_expired_coupon(self):
        self._create_coupon(
            valid_from=timezone.now() - timedelta(days=30),
            valid_until=timezone.now() - timedelta(days=1),
        )
        with self.assertRaises(ValidationError):
            validate_coupon('SAVE10', self.user, Decimal('1000'))

    def test_validate_inactive_coupon(self):
        self._create_coupon(is_active=False)
        with self.assertRaises(ValidationError):
            validate_coupon('SAVE10', self.user, Decimal('1000'))

    def test_validate_below_min_order(self):
        self._create_coupon(min_order_value=Decimal('2000'))
        with self.assertRaises(ValidationError):
            validate_coupon('SAVE10', self.user, Decimal('500'))

    def test_validate_per_user_limit(self):
        coupon = self._create_coupon(usage_per_user=1)
        # Create a non-cancelled order with this coupon
        Order.objects.create(
            order_number='ORD-2026-000001',
            user=self.user,
            shipping_address={'full_name': 'Test'},
            subtotal=Decimal('1000'),
            total=Decimal('900'),
            coupon=coupon,
        )
        with self.assertRaises(ValidationError):
            validate_coupon('SAVE10', self.user, Decimal('1000'))


# ──────────────────────────────────────────────
# Cart Coupon Service Tests
# ──────────────────────────────────────────────
class CartCouponServiceTest(OrderTestMixin, TestCase):
    def test_apply_coupon_to_cart(self):
        self._add_items_to_cart()
        coupon = self._create_coupon()
        returned_coupon, discount, cart = apply_coupon_to_cart(self.user, 'SAVE10')
        self.assertEqual(returned_coupon.id, coupon.id)
        self.assertGreater(discount, Decimal('0'))
        self.assertEqual(cart.discount, discount)

    def test_apply_coupon_empty_cart(self):
        self._create_coupon()
        with self.assertRaises(ValidationError):
            apply_coupon_to_cart(self.user, 'SAVE10')

    def test_remove_coupon_from_cart(self):
        self._add_items_to_cart()
        self._create_coupon()
        apply_coupon_to_cart(self.user, 'SAVE10')
        cart = remove_coupon_from_cart(self.user)
        self.assertEqual(cart.discount, Decimal('0.00'))


# ──────────────────────────────────────────────
# Order Model Tests
# ──────────────────────────────────────────────
class OrderModelTest(OrderTestMixin, TestCase):
    def test_generate_order_number(self):
        number = Order.generate_order_number()
        self.assertTrue(number.startswith('ORD-'))
        self.assertEqual(len(number), 15)

    def test_order_number_unique(self):
        numbers = {Order.generate_order_number() for _ in range(10)}
        self.assertEqual(len(numbers), 10)

    def test_valid_transitions(self):
        order = Order(status='PENDING')
        self.assertTrue(order.can_transition_to('CONFIRMED'))
        self.assertTrue(order.can_transition_to('CANCELLED'))
        self.assertFalse(order.can_transition_to('DELIVERED'))
        self.assertFalse(order.can_transition_to('SHIPPED'))

    def test_is_cancellable(self):
        self.assertTrue(Order(status='PENDING').is_cancellable)
        self.assertTrue(Order(status='CONFIRMED').is_cancellable)
        self.assertTrue(Order(status='PROCESSING').is_cancellable)
        self.assertFalse(Order(status='SHIPPED').is_cancellable)
        self.assertFalse(Order(status='DELIVERED').is_cancellable)

    def test_order_str(self):
        order = Order(order_number='ORD-2026-123456')
        self.assertEqual(str(order), 'ORD-2026-123456')


# ──────────────────────────────────────────────
# Order Creation Service Tests
# ──────────────────────────────────────────────
class OrderCreateServiceTest(OrderTestMixin, TestCase):
    def test_create_order_from_cart(self):
        self._add_items_to_cart()
        order = create_order(
            user=self.user,
            shipping_address_id=self.address.id,
        )
        self.assertIsNotNone(order.order_number)
        self.assertEqual(order.status, 'PENDING')
        self.assertEqual(order.payment_status, 'PENDING')
        self.assertEqual(order.payment_method, 'cod')
        self.assertEqual(order.items.count(), 2)
        self.assertIn('full_name', order.shipping_address)

    def test_create_order_clears_cart(self):
        self._add_items_to_cart()
        create_order(user=self.user, shipping_address_id=self.address.id)
        cart = get_or_create_cart(self.user)
        self.assertEqual(cart.items.count(), 0)

    def test_create_order_deducts_stock(self):
        self._add_items_to_cart()
        create_order(user=self.user, shipping_address_id=self.address.id)
        self.variant.refresh_from_db()
        self.product2.refresh_from_db()
        self.assertEqual(self.variant.stock_quantity, 8)  # 10 - 2
        self.assertEqual(self.product2.stock_quantity, 19)  # 20 - 1

    def test_create_order_records_status_history(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        history = order.status_history.all()
        self.assertEqual(history.count(), 1)
        self.assertEqual(history.first().status, 'PENDING')

    def test_create_order_with_coupon(self):
        self._add_items_to_cart()
        self._create_coupon()
        order = create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            coupon_code='SAVE10',
        )
        self.assertIsNotNone(order.coupon)
        self.assertGreater(order.discount, Decimal('0'))

    def test_create_order_with_billing_address(self):
        billing = Address.objects.create(
            user=self.user,
            address_type='WORK',
            full_name='Office',
            phone='+919876543211',
            address_line1='456 Work Street',
            city='Mumbai',
            state='Maharashtra',
            postal_code='400002',
        )
        self._add_items_to_cart()
        order = create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            billing_address_id=billing.id,
        )
        self.assertIsNotNone(order.billing_address)
        self.assertEqual(order.billing_address['full_name'], 'Office')

    def test_create_order_with_customer_note(self):
        self._add_items_to_cart()
        order = create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            customer_note='Leave at door',
        )
        self.assertEqual(order.customer_note, 'Leave at door')

    def test_create_order_empty_cart_fails(self):
        with self.assertRaises(ValidationError):
            create_order(user=self.user, shipping_address_id=self.address.id)

    def test_create_order_invalid_address_fails(self):
        import uuid
        self._add_items_to_cart()
        with self.assertRaises(ValidationError):
            create_order(user=self.user, shipping_address_id=uuid.uuid4())

    def test_create_order_inactive_address_fails(self):
        self.address.is_active = False
        self.address.save()
        self._add_items_to_cart()
        with self.assertRaises(ValidationError):
            create_order(user=self.user, shipping_address_id=self.address.id)

    def test_create_order_increments_order_count(self):
        self._add_items_to_cart()
        old_count = self.product.order_count
        create_order(user=self.user, shipping_address_id=self.address.id)
        self.product.refresh_from_db()
        self.assertEqual(self.product.order_count, old_count + 2)  # qty=2

    def test_create_order_coupon_usage_incremented(self):
        self._add_items_to_cart()
        coupon = self._create_coupon()
        create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            coupon_code='SAVE10',
        )
        coupon.refresh_from_db()
        self.assertEqual(coupon.usage_count, 1)


# ──────────────────────────────────────────────
# Order Cancel Service Tests
# ──────────────────────────────────────────────
class OrderCancelServiceTest(OrderTestMixin, TestCase):
    def test_cancel_pending_order(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        cancel_order(self.user, order.order_number, 'Changed mind')
        order.refresh_from_db()
        self.assertEqual(order.status, 'CANCELLED')

    def test_cancel_order_restores_stock(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        # Stock after order: variant 8, product2 19
        cancel_order(self.user, order.order_number)
        self.variant.refresh_from_db()
        self.product2.refresh_from_db()
        self.assertEqual(self.variant.stock_quantity, 10)  # restored
        self.assertEqual(self.product2.stock_quantity, 20)  # restored

    def test_cancel_order_records_history(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        cancel_order(self.user, order.order_number, 'Changed mind')
        history = order.status_history.filter(status='CANCELLED')
        self.assertEqual(history.count(), 1)
        self.assertEqual(history.first().notes, 'Changed mind')

    def test_cancel_shipped_order_fails(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        order.status = 'SHIPPED'
        order.save(update_fields=['status'])
        with self.assertRaises(ValidationError):
            cancel_order(self.user, order.order_number)

    def test_cancel_nonexistent_order_fails(self):
        with self.assertRaises(ValidationError):
            cancel_order(self.user, 'ORD-FAKE-000000')


# ──────────────────────────────────────────────
# Reorder Service Tests
# ──────────────────────────────────────────────
class ReorderServiceTest(OrderTestMixin, TestCase):
    def test_reorder_adds_items_to_cart(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        added, skipped = reorder(self.user, order.order_number)
        self.assertEqual(len(added), 2)
        self.assertEqual(len(skipped), 0)
        cart = get_or_create_cart(self.user)
        self.assertEqual(cart.items.count(), 2)

    def test_reorder_skips_unavailable(self):
        self._add_items_to_cart()
        order = create_order(user=self.user, shipping_address_id=self.address.id)
        # Make product2 unavailable
        self.product2.is_active = False
        self.product2.save()
        added, skipped = reorder(self.user, order.order_number)
        self.assertEqual(len(added), 1)
        self.assertEqual(len(skipped), 1)

    def test_reorder_nonexistent_order_fails(self):
        with self.assertRaises(ValidationError):
            reorder(self.user, 'ORD-FAKE-000000')


# ──────────────────────────────────────────────
# Order Status Transition Tests
# ──────────────────────────────────────────────
class OrderStatusTransitionTest(OrderTestMixin, TestCase):
    def _create_test_order(self):
        self._add_items_to_cart()
        return create_order(user=self.user, shipping_address_id=self.address.id)

    def test_transition_pending_to_confirmed(self):
        order = self._create_test_order()
        update_order_status(order, 'CONFIRMED', self.user, 'Payment received')
        self.assertEqual(order.status, 'CONFIRMED')

    def test_full_status_flow(self):
        order = self._create_test_order()
        update_order_status(order, 'CONFIRMED')
        update_order_status(order, 'PROCESSING')
        update_order_status(order, 'SHIPPED')
        update_order_status(order, 'OUT_FOR_DELIVERY')
        update_order_status(order, 'DELIVERED')
        self.assertEqual(order.status, 'DELIVERED')
        self.assertIsNotNone(order.delivered_at)

    def test_invalid_transition_fails(self):
        order = self._create_test_order()
        with self.assertRaises(ValidationError):
            update_order_status(order, 'DELIVERED')

    def test_transition_records_history(self):
        order = self._create_test_order()
        update_order_status(order, 'CONFIRMED', self.user, 'Verified')
        history = order.status_history.filter(status='CONFIRMED')
        self.assertEqual(history.count(), 1)
        self.assertEqual(history.first().notes, 'Verified')


# ──────────────────────────────────────────────
# Order API Tests
# ──────────────────────────────────────────────
class OrderAPITest(OrderTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.client.force_authenticate(user=self.user)

    def _create_order_via_service(self):
        self._add_items_to_cart()
        return create_order(user=self.user, shipping_address_id=self.address.id)

    def test_order_list(self):
        self._create_order_via_service()
        # Need to re-add items for second order
        self._add_items_to_cart()
        create_order(user=self.user, shipping_address_id=self.address.id)
        response = self.client.get('/api/v1/orders/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(response.data['data']['count'], 2)

    def test_order_list_filter_by_status(self):
        order = self._create_order_via_service()
        response = self.client.get('/api/v1/orders/?status=pending')
        self.assertEqual(response.data['data']['count'], 1)
        order.status = 'CONFIRMED'
        order.save()
        response = self.client.get('/api/v1/orders/?status=pending')
        self.assertEqual(response.data['data']['count'], 0)

    def test_order_list_ordering(self):
        self._create_order_via_service()
        response = self.client.get('/api/v1/orders/?ordering=-created_at')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_order_detail(self):
        order = self._create_order_via_service()
        response = self.client.get(f'/api/v1/orders/{order.order_number}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(response.data['data']['order_number'], order.order_number)
        self.assertIn('items', response.data['data'])
        self.assertIn('status_history', response.data['data'])

    def test_order_detail_not_found(self):
        response = self.client.get('/api/v1/orders/ORD-FAKE-000000/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_order_create_api(self):
        self._add_items_to_cart()
        response = self.client.post('/api/v1/orders/create/', {
            'shipping_address_id': str(self.address.id),
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])
        self.assertIn('order_number', response.data['data'])

    def test_order_create_api_with_coupon(self):
        self._add_items_to_cart()
        self._create_coupon()
        response = self.client.post('/api/v1/orders/create/', {
            'shipping_address_id': str(self.address.id),
            'coupon_code': 'SAVE10',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_order_create_api_empty_cart(self):
        response = self.client.post('/api/v1/orders/create/', {
            'shipping_address_id': str(self.address.id),
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_order_cancel_api(self):
        order = self._create_order_via_service()
        response = self.client.post(
            f'/api/v1/orders/{order.order_number}/cancel/',
            {'reason': 'Changed mind'},
            format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        order.refresh_from_db()
        self.assertEqual(order.status, 'CANCELLED')

    def test_order_cancel_non_cancellable(self):
        order = self._create_order_via_service()
        order.status = 'DELIVERED'
        order.save()
        response = self.client.post(
            f'/api/v1/orders/{order.order_number}/cancel/',
            {'reason': 'Too late'},
            format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_order_reorder_api(self):
        order = self._create_order_via_service()
        response = self.client.post(f'/api/v1/orders/{order.order_number}/reorder/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('added', response.data['data'])

    def test_order_track_api(self):
        order = self._create_order_via_service()
        response = self.client.get(f'/api/v1/orders/{order.order_number}/track/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('timeline', response.data['data'])

    def test_order_track_not_found(self):
        response = self.client.get('/api/v1/orders/ORD-FAKE-000000/track/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_order_isolation(self):
        """User cannot see another user's orders."""
        order = self._create_order_via_service()
        other_user = User.objects.create_user(
            email='other@test.com', username='other',
            password='TestPass123!', first_name='Other', last_name='User',
        )
        self.client.force_authenticate(user=other_user)
        response = self.client.get(f'/api/v1/orders/{order.order_number}/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_order_unauthenticated(self):
        self.client.force_authenticate(user=None)
        response = self.client.get('/api/v1/orders/')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


# ──────────────────────────────────────────────
# Cart Coupon API Tests
# ──────────────────────────────────────────────
class CartCouponAPITest(OrderTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.client.force_authenticate(user=self.user)

    def test_apply_coupon_api(self):
        self._add_items_to_cart()
        self._create_coupon()
        response = self.client.post('/api/v1/cart/apply-coupon/', {
            'coupon_code': 'SAVE10',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('discount', response.data['data'])

    def test_apply_invalid_coupon_api(self):
        self._add_items_to_cart()
        response = self.client.post('/api/v1/cart/apply-coupon/', {
            'coupon_code': 'INVALID',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_remove_coupon_api(self):
        self._add_items_to_cart()
        self._create_coupon()
        self.client.post('/api/v1/cart/apply-coupon/', {
            'coupon_code': 'SAVE10',
        }, format='json')
        response = self.client.delete('/api/v1/cart/remove-coupon/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['data']['total'], str(get_or_create_cart(self.user).total))


# ──────────────────────────────────────────────
# Admin Order Management Service Tests
# ──────────────────────────────────────────────
class AdminOrderServiceTest(OrderTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.admin = User.objects.create_user(
            email='admin@test.com',
            username='admin',
            password='TestPass123!',
            first_name='Admin',
            last_name='User',
            role='ADMIN',
        )

    def _create_order(self):
        self._add_items_to_cart()
        return create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            payment_method='cod',
        )

    def test_admin_update_order_status(self):
        from apps.orders.services import admin_update_order_status
        order = self._create_order()
        updated = admin_update_order_status(
            order_id=order.id,
            new_status='CONFIRMED',
            changed_by=self.admin,
            notes='Admin confirmed.',
        )
        self.assertEqual(updated.status, 'CONFIRMED')
        self.assertEqual(OrderStatusHistory.objects.filter(order=order).count(), 2)

    def test_admin_update_status_with_tracking(self):
        from apps.orders.services import admin_update_order_status
        order = self._create_order()
        admin_update_order_status(order.id, 'CONFIRMED', self.admin)
        admin_update_order_status(order.id, 'PROCESSING', self.admin)
        updated = admin_update_order_status(
            order_id=order.id,
            new_status='SHIPPED',
            changed_by=self.admin,
            tracking_number='TRK123456789',
            notes='Shipped via FedEx',
        )
        self.assertEqual(updated.status, 'SHIPPED')
        self.assertEqual(updated.tracking_number, 'TRK123456789')
        self.assertIsNotNone(updated.estimated_delivery)

    def test_admin_update_invalid_transition(self):
        from apps.orders.services import admin_update_order_status
        order = self._create_order()
        with self.assertRaises(ValidationError):
            admin_update_order_status(order.id, 'DELIVERED', self.admin)

    def test_admin_update_nonexistent_order(self):
        from apps.orders.services import admin_update_order_status
        import uuid
        with self.assertRaises(ValidationError):
            admin_update_order_status(uuid.uuid4(), 'CONFIRMED', self.admin)

    def test_admin_delivered_sets_delivered_at(self):
        from apps.orders.services import admin_update_order_status
        order = self._create_order()
        admin_update_order_status(order.id, 'CONFIRMED', self.admin)
        admin_update_order_status(order.id, 'PROCESSING', self.admin)
        admin_update_order_status(order.id, 'SHIPPED', self.admin)
        admin_update_order_status(order.id, 'OUT_FOR_DELIVERY', self.admin)
        updated = admin_update_order_status(order.id, 'DELIVERED', self.admin)
        self.assertIsNotNone(updated.delivered_at)

    def test_get_admin_dashboard_stats(self):
        from apps.orders.services import get_admin_dashboard_stats
        self._create_order()
        stats = get_admin_dashboard_stats()
        self.assertIn('overview', stats)
        self.assertIn('today', stats)
        self.assertIn('status_breakdown', stats)
        self.assertIn('top_products', stats)
        self.assertIn('recent_orders', stats)
        self.assertEqual(stats['overview']['total_orders'], 1)
        self.assertEqual(stats['overview']['pending_orders'], 1)

    def test_dashboard_stats_revenue(self):
        from apps.orders.services import get_admin_dashboard_stats
        order = self._create_order()
        order.payment_status = 'PAID'
        order.save(update_fields=['payment_status'])
        stats = get_admin_dashboard_stats()
        self.assertGreater(Decimal(stats['overview']['total_revenue']), Decimal('0'))


# ──────────────────────────────────────────────
# Vendor Order Management Service Tests
# ──────────────────────────────────────────────
class VendorOrderServiceTest(OrderTestMixin, TestCase):
    def _create_order(self):
        self._add_items_to_cart()
        return create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            payment_method='cod',
        )

    def test_get_vendor_orders(self):
        from apps.orders.services import get_vendor_orders
        self._create_order()
        items = get_vendor_orders(self.vendor)
        self.assertEqual(items.count(), 2)  # product + product2, both from same vendor

    def test_get_vendor_orders_isolation(self):
        from apps.orders.services import get_vendor_orders
        other_vendor = User.objects.create_user(
            email='vendor2@test.com', username='vendor2',
            password='TestPass123!', first_name='Other', last_name='Vendor',
            role='VENDOR',
        )
        self._create_order()
        items = get_vendor_orders(other_vendor)
        self.assertEqual(items.count(), 0)

    def test_get_vendor_dashboard_stats(self):
        from apps.orders.services import get_vendor_dashboard_stats
        self._create_order()
        stats = get_vendor_dashboard_stats(self.vendor)
        self.assertIn('total_orders', stats)
        self.assertIn('total_revenue', stats)
        self.assertIn('pending_orders', stats)
        self.assertIn('this_month_revenue', stats)
        self.assertIn('top_products', stats)
        self.assertEqual(stats['total_orders'], 1)

    def test_vendor_dashboard_revenue_paid(self):
        from apps.orders.services import get_vendor_dashboard_stats
        order = self._create_order()
        order.payment_status = 'PAID'
        order.save(update_fields=['payment_status'])
        stats = get_vendor_dashboard_stats(self.vendor)
        self.assertGreater(Decimal(stats['total_revenue']), Decimal('0'))


# ──────────────────────────────────────────────
# Admin Order API Tests
# ──────────────────────────────────────────────
class AdminOrderAPITest(OrderTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.admin = User.objects.create_user(
            email='admin@test.com',
            username='admin',
            password='TestPass123!',
            first_name='Admin',
            last_name='User',
            role='ADMIN',
        )
        self.client.force_authenticate(user=self.admin)

    def _create_order(self):
        self._add_items_to_cart()
        return create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            payment_method='cod',
        )

    def test_admin_order_list(self):
        self._create_order()
        response = self.client.get('/api/v1/admin/orders/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(response.data['data']['count'], 1)
        self.assertIn('customer', response.data['data']['results'][0])

    def test_admin_order_list_filter_status(self):
        self._create_order()
        response = self.client.get('/api/v1/admin/orders/?status=PENDING')
        self.assertEqual(response.data['data']['count'], 1)
        response = self.client.get('/api/v1/admin/orders/?status=DELIVERED')
        self.assertEqual(response.data['data']['count'], 0)

    def test_admin_order_detail(self):
        order = self._create_order()
        response = self.client.get(f'/api/v1/admin/orders/{order.id}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['data']['order_number'], order.order_number)

    def test_admin_order_detail_not_found(self):
        import uuid
        response = self.client.get(f'/api/v1/admin/orders/{uuid.uuid4()}/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_admin_update_status(self):
        order = self._create_order()
        response = self.client.patch(
            f'/api/v1/admin/orders/{order.id}/status/',
            {'status': 'CONFIRMED', 'notes': 'Confirmed by admin'},
            format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        order.refresh_from_db()
        self.assertEqual(order.status, 'CONFIRMED')

    def test_admin_update_status_with_tracking(self):
        order = self._create_order()
        # Progress through states
        order.status = 'PROCESSING'
        order.save()
        OrderStatusHistory.objects.create(order=order, status='PROCESSING', changed_by=self.admin)

        response = self.client.patch(
            f'/api/v1/admin/orders/{order.id}/status/',
            {
                'status': 'SHIPPED',
                'tracking_number': 'TRK999',
                'notes': 'Shipped via courier',
            },
            format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['data']['tracking_number'], 'TRK999')

    def test_admin_update_invalid_transition(self):
        order = self._create_order()
        response = self.client.patch(
            f'/api/v1/admin/orders/{order.id}/status/',
            {'status': 'DELIVERED'},
            format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_admin_dashboard_stats(self):
        self._create_order()
        response = self.client.get('/api/v1/admin/dashboard/stats/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('overview', response.data['data'])
        self.assertIn('today', response.data['data'])

    def test_admin_endpoints_forbidden_for_customer(self):
        self.client.force_authenticate(user=self.user)
        response = self.client.get('/api/v1/admin/orders/')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_admin_endpoints_forbidden_for_vendor(self):
        self.client.force_authenticate(user=self.vendor)
        response = self.client.get('/api/v1/admin/orders/')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)


# ──────────────────────────────────────────────
# Vendor Order API Tests
# ──────────────────────────────────────────────
class VendorOrderAPITest(OrderTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.client.force_authenticate(user=self.vendor)

    def _create_order(self):
        self._add_items_to_cart()
        return create_order(
            user=self.user,
            shipping_address_id=self.address.id,
            payment_method='cod',
        )

    def test_vendor_order_list(self):
        self._create_order()
        response = self.client.get('/api/v1/vendor/orders/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertEqual(response.data['data']['count'], 2)  # 2 items

    def test_vendor_order_list_filter_status(self):
        self._create_order()
        response = self.client.get('/api/v1/vendor/orders/?status=PENDING')
        self.assertEqual(response.data['data']['count'], 2)
        response = self.client.get('/api/v1/vendor/orders/?status=DELIVERED')
        self.assertEqual(response.data['data']['count'], 0)

    def test_vendor_order_item_details(self):
        self._create_order()
        response = self.client.get('/api/v1/vendor/orders/')
        item = response.data['data']['results'][0]
        self.assertIn('order_number', item)
        self.assertIn('order_status', item)
        self.assertIn('customer_name', item)
        self.assertIn('shipping_address', item)
        self.assertIn('product_name', item)

    def test_vendor_dashboard(self):
        self._create_order()
        response = self.client.get('/api/v1/vendor/dashboard/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('total_orders', response.data['data'])
        self.assertIn('total_revenue', response.data['data'])
        self.assertIn('pending_orders', response.data['data'])

    def test_vendor_endpoints_forbidden_for_customer(self):
        self.client.force_authenticate(user=self.user)
        response = self.client.get('/api/v1/vendor/orders/')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_vendor_order_isolation(self):
        """Vendor only sees their own order items."""
        other_vendor = User.objects.create_user(
            email='vendor2@test.com', username='vendor2',
            password='TestPass123!', first_name='Other', last_name='Vendor',
            role='VENDOR',
        )
        self._create_order()
        self.client.force_authenticate(user=other_vendor)
        response = self.client.get('/api/v1/vendor/orders/')
        self.assertEqual(response.data['data']['count'], 0)
