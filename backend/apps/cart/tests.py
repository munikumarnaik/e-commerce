from decimal import Decimal

from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient

from apps.cart.models import Cart, CartItem, Wishlist, WishlistItem
from apps.cart.services import (
    add_to_cart,
    add_to_wishlist,
    clear_cart,
    clear_wishlist,
    get_or_create_cart,
    get_or_create_wishlist,
    move_wishlist_to_cart,
    remove_cart_item,
    remove_from_wishlist,
    update_cart_item,
)
from apps.products.models import Category, Product, ProductVariant
from apps.users.models import User


class CartWishlistTestMixin:
    """Shared setup for cart/wishlist tests."""

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

        self.product_no_stock = Product.objects.create(
            name='Rare Jacket',
            slug='rare-jacket',
            sku='CLO-JAK-001',
            product_type='CLOTHING',
            category=self.category,
            vendor=self.vendor,
            description='A very rare jacket',
            price=Decimal('5999.00'),
            stock_quantity=0,
            thumbnail='https://example.com/img3.jpg',
        )

        self.variant_red_m = ProductVariant.objects.create(
            product=self.product,
            sku='CLO-TSH-001-RED-M',
            size='M',
            color='Red',
            color_hex='#FF0000',
            price=Decimal('999.00'),
            stock_quantity=10,
        )

        self.variant_blue_l = ProductVariant.objects.create(
            product=self.product,
            sku='CLO-TSH-001-BLU-L',
            size='L',
            color='Blue',
            color_hex='#0000FF',
            price=Decimal('1099.00'),
            stock_quantity=5,
        )

    def get_url(self, name, **kwargs):
        return reverse(f'cart:{name}', kwargs={**kwargs, 'version': 'v1'})


# ──────────────────────────────────────────────
# Cart Model Tests
# ──────────────────────────────────────────────
class CartModelTest(CartWishlistTestMixin, TestCase):
    def test_create_cart(self):
        cart = get_or_create_cart(self.user)
        self.assertIsNotNone(cart)
        self.assertEqual(cart.user, self.user)
        self.assertIsNotNone(cart.expires_at)

    def test_cart_one_per_user(self):
        cart1 = get_or_create_cart(self.user)
        cart2 = get_or_create_cart(self.user)
        self.assertEqual(cart1.id, cart2.id)

    def test_cart_item_price_calculation(self):
        cart = get_or_create_cart(self.user)
        item = CartItem(
            cart=cart,
            product=self.product2,
            quantity=3,
        )
        item.save()
        self.assertEqual(item.unit_price, Decimal('2499.00'))
        self.assertEqual(item.total_price, Decimal('7497.00'))

    def test_cart_item_variant_price(self):
        cart = get_or_create_cart(self.user)
        item = CartItem(
            cart=cart,
            product=self.product,
            variant=self.variant_blue_l,
            quantity=2,
        )
        item.save()
        self.assertEqual(item.unit_price, Decimal('1099.00'))
        self.assertEqual(item.total_price, Decimal('2198.00'))

    def test_cart_recalculate(self):
        cart = get_or_create_cart(self.user)
        CartItem(cart=cart, product=self.product2, quantity=2).save()
        cart.recalculate()
        self.assertEqual(cart.subtotal, Decimal('4998.00'))
        self.assertEqual(cart.tax, Decimal('899.64'))
        self.assertEqual(cart.total, Decimal('5897.64'))

    def test_cart_clear_items(self):
        cart = get_or_create_cart(self.user)
        CartItem(cart=cart, product=self.product2, quantity=1).save()
        self.assertEqual(cart.items.count(), 1)
        cart.clear_items()
        self.assertEqual(cart.items.count(), 0)
        self.assertEqual(cart.subtotal, Decimal('0.00'))

    def test_cart_items_count(self):
        cart = get_or_create_cart(self.user)
        CartItem(cart=cart, product=self.product2, quantity=1).save()
        self.assertEqual(cart.items_count, 1)


# ──────────────────────────────────────────────
# Cart Service Tests
# ──────────────────────────────────────────────
class CartServiceTest(CartWishlistTestMixin, TestCase):
    def test_add_to_cart_with_variant(self):
        cart_item = add_to_cart(
            self.user,
            product_id=self.product.id,
            variant_id=self.variant_red_m.id,
            quantity=2,
        )
        self.assertEqual(cart_item.quantity, 2)
        self.assertEqual(cart_item.variant, self.variant_red_m)

    def test_add_to_cart_increments_quantity(self):
        add_to_cart(self.user, self.product.id, self.variant_red_m.id, 2)
        cart_item = add_to_cart(self.user, self.product.id, self.variant_red_m.id, 3)
        self.assertEqual(cart_item.quantity, 5)

    def test_add_to_cart_out_of_stock(self):
        from rest_framework.exceptions import ValidationError
        with self.assertRaises(ValidationError):
            add_to_cart(self.user, self.product_no_stock.id, quantity=1)

    def test_add_to_cart_exceeds_stock(self):
        from rest_framework.exceptions import ValidationError
        with self.assertRaises(ValidationError):
            add_to_cart(self.user, self.product.id, self.variant_red_m.id, 999)

    def test_add_to_cart_requires_variant(self):
        """Product with active variants should require variant selection."""
        from rest_framework.exceptions import ValidationError
        with self.assertRaises(ValidationError):
            add_to_cart(self.user, self.product.id, quantity=1)

    def test_add_to_cart_no_variant_needed(self):
        """Product without variants should not require variant."""
        cart_item = add_to_cart(self.user, self.product2.id, quantity=1)
        self.assertEqual(cart_item.product, self.product2)
        self.assertIsNone(cart_item.variant)

    def test_update_cart_item(self):
        cart_item = add_to_cart(self.user, self.product2.id, quantity=1)
        updated = update_cart_item(self.user, cart_item.id, 5)
        self.assertEqual(updated.quantity, 5)

    def test_update_cart_item_to_zero_deletes(self):
        cart_item = add_to_cart(self.user, self.product2.id, quantity=1)
        result = update_cart_item(self.user, cart_item.id, 0)
        self.assertIsNone(result)
        self.assertEqual(CartItem.objects.filter(id=cart_item.id).count(), 0)

    def test_remove_cart_item(self):
        cart_item = add_to_cart(self.user, self.product2.id, quantity=1)
        remove_cart_item(self.user, cart_item.id)
        self.assertEqual(CartItem.objects.filter(id=cart_item.id).count(), 0)

    def test_clear_cart(self):
        add_to_cart(self.user, self.product2.id, quantity=1)
        add_to_cart(self.user, self.product.id, self.variant_red_m.id, 2)
        clear_cart(self.user)
        cart = get_or_create_cart(self.user)
        self.assertEqual(cart.items.count(), 0)


# ──────────────────────────────────────────────
# Cart API Tests
# ──────────────────────────────────────────────
class CartAPITest(CartWishlistTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.client.force_authenticate(user=self.user)

    def test_get_cart(self):
        url = self.get_url('cart-detail')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('items', response.data['data'])

    def test_add_to_cart_api(self):
        url = self.get_url('cart-add')
        response = self.client.post(url, {
            'product_id': str(self.product.id),
            'variant_id': str(self.variant_red_m.id),
            'quantity': 2,
        })
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])
        self.assertIn('cart_item', response.data['data'])
        self.assertIn('cart_summary', response.data['data'])

    def test_add_to_cart_no_variant_product(self):
        url = self.get_url('cart-add')
        response = self.client.post(url, {
            'product_id': str(self.product2.id),
            'quantity': 1,
        })
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_add_to_cart_out_of_stock(self):
        url = self.get_url('cart-add')
        response = self.client.post(url, {
            'product_id': str(self.product_no_stock.id),
            'quantity': 1,
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_update_cart_item_api(self):
        cart_item = add_to_cart(self.user, self.product2.id, quantity=1)
        url = self.get_url('cart-item-update', item_id=cart_item.id)
        response = self.client.patch(url, {'quantity': 3}, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_cart_item_api(self):
        cart_item = add_to_cart(self.user, self.product2.id, quantity=1)
        url = self.get_url('cart-item-delete', item_id=cart_item.id)
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_clear_cart_api(self):
        add_to_cart(self.user, self.product2.id, quantity=1)
        url = self.get_url('cart-clear')
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        cart = get_or_create_cart(self.user)
        self.assertEqual(cart.items.count(), 0)

    def test_unauthenticated_cart_access(self):
        self.client.force_authenticate(user=None)
        url = self.get_url('cart-detail')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


# ──────────────────────────────────────────────
# Wishlist Model Tests
# ──────────────────────────────────────────────
class WishlistModelTest(CartWishlistTestMixin, TestCase):
    def test_create_wishlist(self):
        wishlist = get_or_create_wishlist(self.user)
        self.assertIsNotNone(wishlist)
        self.assertEqual(wishlist.user, self.user)

    def test_wishlist_one_per_user(self):
        wl1 = get_or_create_wishlist(self.user)
        wl2 = get_or_create_wishlist(self.user)
        self.assertEqual(wl1.id, wl2.id)


# ──────────────────────────────────────────────
# Wishlist Service Tests
# ──────────────────────────────────────────────
class WishlistServiceTest(CartWishlistTestMixin, TestCase):
    def test_add_to_wishlist(self):
        add_to_wishlist(self.user, self.product.id)
        wishlist = get_or_create_wishlist(self.user)
        self.assertEqual(wishlist.items.count(), 1)

    def test_add_duplicate_to_wishlist(self):
        from rest_framework.exceptions import ValidationError
        add_to_wishlist(self.user, self.product.id)
        with self.assertRaises(ValidationError):
            add_to_wishlist(self.user, self.product.id)

    def test_remove_from_wishlist(self):
        add_to_wishlist(self.user, self.product.id)
        remove_from_wishlist(self.user, self.product.id)
        wishlist = get_or_create_wishlist(self.user)
        self.assertEqual(wishlist.items.count(), 0)

    def test_clear_wishlist(self):
        add_to_wishlist(self.user, self.product.id)
        add_to_wishlist(self.user, self.product2.id)
        clear_wishlist(self.user)
        wishlist = get_or_create_wishlist(self.user)
        self.assertEqual(wishlist.items.count(), 0)

    def test_move_wishlist_to_cart(self):
        add_to_wishlist(self.user, self.product2.id)
        cart_item = move_wishlist_to_cart(self.user, self.product2.id, quantity=1)
        self.assertEqual(cart_item.product, self.product2)
        wishlist = get_or_create_wishlist(self.user)
        self.assertEqual(wishlist.items.count(), 0)

    def test_move_wishlist_to_cart_with_variant(self):
        add_to_wishlist(self.user, self.product.id)
        cart_item = move_wishlist_to_cart(
            self.user, self.product.id,
            variant_id=self.variant_red_m.id, quantity=2,
        )
        self.assertEqual(cart_item.variant, self.variant_red_m)
        self.assertEqual(cart_item.quantity, 2)


# ──────────────────────────────────────────────
# Wishlist API Tests
# ──────────────────────────────────────────────
class WishlistAPITest(CartWishlistTestMixin, TestCase):
    def setUp(self):
        super().setUp()
        self.client.force_authenticate(user=self.user)

    def test_get_wishlist(self):
        url = self.get_url('wishlist-detail')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])

    def test_add_to_wishlist_api(self):
        url = self.get_url('wishlist-add')
        response = self.client.post(url, {
            'product_id': str(self.product.id),
        })
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])

    def test_add_duplicate_to_wishlist_api(self):
        add_to_wishlist(self.user, self.product.id)
        url = self.get_url('wishlist-add')
        response = self.client.post(url, {
            'product_id': str(self.product.id),
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_remove_from_wishlist_api(self):
        add_to_wishlist(self.user, self.product.id)
        url = self.get_url('wishlist-remove', product_id=self.product.id)
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_move_to_cart_api(self):
        add_to_wishlist(self.user, self.product2.id)
        url = self.get_url('wishlist-move-to-cart', product_id=self.product2.id)
        response = self.client.post(url, {'quantity': 1})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Verify removed from wishlist
        wishlist = get_or_create_wishlist(self.user)
        self.assertEqual(wishlist.items.count(), 0)
        # Verify in cart
        cart = get_or_create_cart(self.user)
        self.assertEqual(cart.items.count(), 1)

    def test_clear_wishlist_api(self):
        add_to_wishlist(self.user, self.product.id)
        add_to_wishlist(self.user, self.product2.id)
        url = self.get_url('wishlist-clear')
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        wishlist = get_or_create_wishlist(self.user)
        self.assertEqual(wishlist.items.count(), 0)

    def test_unauthenticated_wishlist_access(self):
        self.client.force_authenticate(user=None)
        url = self.get_url('wishlist-detail')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
