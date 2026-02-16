from decimal import Decimal

from django.test import TestCase
from rest_framework import status
from rest_framework.test import APIClient

from apps.products.models import (
    Brand,
    Category,
    ClothingProduct,
    FoodProduct,
    Product,
    ProductImage,
    ProductVariant,
)
from apps.users.models import User


class CategoryModelTest(TestCase):
    def test_create_category(self):
        cat = Category.objects.create(
            name='Beverages', slug='beverages',
            category_type='FOOD',
        )
        self.assertEqual(cat.name, 'Beverages')
        self.assertEqual(cat.category_type, 'FOOD')
        self.assertTrue(cat.is_active)

    def test_auto_slug(self):
        cat = Category.objects.create(name='Hot Beverages', category_type='FOOD')
        self.assertEqual(cat.slug, 'hot-beverages')

    def test_hierarchical_categories(self):
        parent = Category.objects.create(name='Clothing', slug='clothing', category_type='CLOTHING')
        child = Category.objects.create(
            name='Men', slug='men', category_type='CLOTHING', parent=parent,
        )
        self.assertEqual(child.parent, parent)
        self.assertIn(child, parent.subcategories.all())

    def test_product_count(self):
        cat = Category.objects.create(name='Test', slug='test', category_type='FOOD')
        self.assertEqual(cat.product_count, 0)


class BrandModelTest(TestCase):
    def test_create_brand(self):
        brand = Brand.objects.create(name='Nike', slug='nike')
        self.assertEqual(brand.name, 'Nike')
        self.assertTrue(brand.is_active)

    def test_auto_slug(self):
        brand = Brand.objects.create(name='Adidas Sport')
        self.assertEqual(brand.slug, 'adidas-sport')


class ProductModelTest(TestCase):
    def setUp(self):
        self.vendor = User.objects.create_user(
            email='vendor@example.com', username='vendor',
            password='TestPass123!', first_name='Vendor', last_name='User',
            role='VENDOR',
        )
        self.category = Category.objects.create(
            name='T-Shirts', slug='tshirts', category_type='CLOTHING',
        )
        self.brand = Brand.objects.create(name='Nike', slug='nike')

    def test_create_product(self):
        product = Product.objects.create(
            name='Cotton T-Shirt', slug='cotton-tshirt', sku='CLO-001',
            product_type='CLOTHING', category=self.category, brand=self.brand,
            vendor=self.vendor, description='A nice cotton t-shirt',
            price=Decimal('999.00'), thumbnail='https://example.com/img.jpg',
        )
        self.assertEqual(product.name, 'Cotton T-Shirt')
        self.assertEqual(product.product_type, 'CLOTHING')
        self.assertTrue(product.is_active)
        self.assertFalse(product.is_featured)

    def test_auto_slug(self):
        product = Product.objects.create(
            name='Classic Blue Jeans', sku='CLO-002',
            product_type='CLOTHING', category=self.category,
            vendor=self.vendor, description='Blue jeans',
            price=Decimal('1500.00'), thumbnail='https://example.com/img.jpg',
        )
        self.assertEqual(product.slug, 'classic-blue-jeans')

    def test_discount_percentage_auto_computed(self):
        product = Product.objects.create(
            name='Sale Shirt', slug='sale-shirt', sku='CLO-003',
            product_type='CLOTHING', category=self.category,
            vendor=self.vendor, description='On sale',
            price=Decimal('750.00'), compare_at_price=Decimal('1000.00'),
            thumbnail='https://example.com/img.jpg',
        )
        self.assertEqual(product.discount_percentage, Decimal('25.00'))

    def test_has_variants_false(self):
        product = Product.objects.create(
            name='No Variant', slug='no-variant', sku='CLO-004',
            product_type='CLOTHING', category=self.category,
            vendor=self.vendor, description='No variants',
            price=Decimal('500.00'), thumbnail='https://example.com/img.jpg',
        )
        self.assertFalse(product.has_variants)

    def test_has_variants_true(self):
        product = Product.objects.create(
            name='With Variant', slug='with-variant', sku='CLO-005',
            product_type='CLOTHING', category=self.category,
            vendor=self.vendor, description='Has variants',
            price=Decimal('500.00'), thumbnail='https://example.com/img.jpg',
        )
        ProductVariant.objects.create(
            product=product, sku='CLO-005-RED-M', size='M',
            color='Red', stock_quantity=10,
        )
        self.assertTrue(product.has_variants)


class FoodProductModelTest(TestCase):
    def setUp(self):
        self.vendor = User.objects.create_user(
            email='vendor@example.com', username='vendor',
            password='TestPass123!', first_name='V', last_name='U', role='VENDOR',
        )
        self.category = Category.objects.create(
            name='Pizzas', slug='pizzas', category_type='FOOD',
        )

    def test_create_food_product(self):
        product = Product.objects.create(
            name='Margherita Pizza', slug='margherita-pizza', sku='FOOD-001',
            product_type='FOOD', category=self.category, vendor=self.vendor,
            description='Classic pizza', price=Decimal('299.00'),
            thumbnail='https://example.com/img.jpg',
        )
        food = FoodProduct.objects.create(
            product=product, food_type='VEG', cuisine_type='Italian',
            spice_level=1, calories=250, preparation_time=20,
        )
        self.assertEqual(food.food_type, 'VEG')
        self.assertEqual(food.cuisine_type, 'Italian')
        self.assertEqual(product.food_details, food)


class ClothingProductModelTest(TestCase):
    def setUp(self):
        self.vendor = User.objects.create_user(
            email='vendor@example.com', username='vendor',
            password='TestPass123!', first_name='V', last_name='U', role='VENDOR',
        )
        self.category = Category.objects.create(
            name='T-Shirts', slug='tshirts', category_type='CLOTHING',
        )

    def test_create_clothing_product(self):
        product = Product.objects.create(
            name='Cotton Tee', slug='cotton-tee', sku='CLO-010',
            product_type='CLOTHING', category=self.category, vendor=self.vendor,
            description='Comfy tee', price=Decimal('799.00'),
            thumbnail='https://example.com/img.jpg',
        )
        clothing = ClothingProduct.objects.create(
            product=product, gender='MEN', clothing_type='TOPWEAR',
            material='100% Cotton', fit_type='Regular',
        )
        self.assertEqual(clothing.gender, 'MEN')
        self.assertEqual(product.clothing_details, clothing)


# ──────────────────────────────────────────────
# API Tests
# ──────────────────────────────────────────────
class CategoryAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.food = Category.objects.create(
            name='Food', slug='food', category_type='FOOD',
        )
        self.beverages = Category.objects.create(
            name='Beverages', slug='beverages', category_type='FOOD', parent=self.food,
        )
        self.clothing = Category.objects.create(
            name='Clothing', slug='clothing', category_type='CLOTHING',
        )

    def test_list_categories(self):
        response = self.client.get('/api/v1/categories/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])

    def test_list_categories_filter_type(self):
        response = self.client.get('/api/v1/categories/', {'category_type': 'FOOD'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Only root FOOD categories
        data = response.data['data'] if 'data' in response.data else response.data
        results = data.get('results', data) if isinstance(data, dict) else data
        for cat in results:
            self.assertEqual(cat['category_type'], 'FOOD')

    def test_category_detail(self):
        response = self.client.get(f'/api/v1/categories/{self.food.slug}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_category_tree(self):
        response = self.client.get('/api/v1/categories/tree/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('FOOD', response.data['data'])
        self.assertIn('CLOTHING', response.data['data'])

    def test_category_tree_filtered(self):
        response = self.client.get('/api/v1/categories/tree/', {'category_type': 'FOOD'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_category_unauthenticated(self):
        response = self.client.post('/api/v1/categories/create/', {
            'name': 'New Cat', 'category_type': 'FOOD',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_create_category_as_admin(self):
        admin = User.objects.create_user(
            email='admin@example.com', username='admin',
            password='TestPass123!', first_name='Admin', last_name='User',
            role='ADMIN',
        )
        self.client.force_authenticate(user=admin)
        response = self.client.post('/api/v1/categories/create/', {
            'name': 'New Category', 'category_type': 'FOOD',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])


class ProductAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.vendor = User.objects.create_user(
            email='vendor@example.com', username='vendor',
            password='TestPass123!', first_name='Vendor', last_name='User',
            role='VENDOR',
        )
        self.admin = User.objects.create_user(
            email='admin@example.com', username='admin',
            password='TestPass123!', first_name='Admin', last_name='User',
            role='ADMIN',
        )
        self.category = Category.objects.create(
            name='T-Shirts', slug='tshirts', category_type='CLOTHING',
        )
        self.brand = Brand.objects.create(name='Nike', slug='nike')
        self.product = Product.objects.create(
            name='Cotton T-Shirt', slug='cotton-tshirt', sku='CLO-001',
            product_type='CLOTHING', category=self.category, brand=self.brand,
            vendor=self.vendor, description='A nice cotton t-shirt',
            price=Decimal('999.00'), compare_at_price=Decimal('1499.00'),
            thumbnail='https://example.com/img.jpg', is_featured=True,
        )
        ClothingProduct.objects.create(
            product=self.product, gender='MEN', clothing_type='TOPWEAR',
            material='100% Cotton', fit_type='Regular',
        )
        ProductVariant.objects.create(
            product=self.product, sku='CLO-001-RED-M', size='M',
            color='Red', color_hex='#FF0000', stock_quantity=25,
        )
        ProductImage.objects.create(
            product=self.product, image_url='https://example.com/img1.jpg',
            alt_text='Front view', is_primary=True,
        )

    def test_product_list(self):
        response = self.client.get('/api/v1/products/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_list_with_search(self):
        response = self.client.get('/api/v1/products/', {'search': 'cotton'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_list_filter_by_type(self):
        response = self.client.get('/api/v1/products/', {'product_type': 'CLOTHING'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_list_filter_price_range(self):
        response = self.client.get('/api/v1/products/', {'min_price': 500, 'max_price': 1500})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_list_filter_gender(self):
        response = self.client.get('/api/v1/products/', {'gender': 'MEN'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_list_filter_size(self):
        response = self.client.get('/api/v1/products/', {'size': 'M'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_detail(self):
        response = self.client.get(f'/api/v1/products/{self.product.slug}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.data['data'] if 'data' in response.data else response.data
        self.assertEqual(data['name'], 'Cotton T-Shirt')
        self.assertIn('clothing_details', data)
        self.assertEqual(data['clothing_details']['gender'], 'MEN')

    def test_product_featured(self):
        response = self.client.get('/api/v1/products/featured/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_product_variants(self):
        response = self.client.get(f'/api/v1/products/{self.product.slug}/variants/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_product_as_vendor(self):
        self.client.force_authenticate(user=self.vendor)
        response = self.client.post('/api/v1/products/create/', {
            'name': 'New Shirt',
            'sku': 'CLO-100',
            'product_type': 'CLOTHING',
            'category': str(self.category.id),
            'description': 'A new shirt',
            'price': '799.00',
            'thumbnail': 'https://example.com/new.jpg',
            'clothing_details': {
                'gender': 'MEN',
                'clothing_type': 'TOPWEAR',
                'material': 'Polyester',
            },
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])

    def test_create_product_unauthenticated(self):
        response = self.client.post('/api/v1/products/create/', {
            'name': 'Fail', 'sku': 'X', 'product_type': 'FOOD',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_create_product_customer_forbidden(self):
        customer = User.objects.create_user(
            email='customer@example.com', username='customer',
            password='TestPass123!', first_name='C', last_name='U',
        )
        self.client.force_authenticate(user=customer)
        response = self.client.post('/api/v1/products/create/', {
            'name': 'Fail', 'sku': 'X', 'product_type': 'FOOD',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_create_food_product(self):
        food_cat = Category.objects.create(
            name='Pizzas', slug='pizzas', category_type='FOOD',
        )
        self.client.force_authenticate(user=self.vendor)
        response = self.client.post('/api/v1/products/create/', {
            'name': 'Margherita Pizza',
            'sku': 'FOOD-001',
            'product_type': 'FOOD',
            'category': str(food_cat.id),
            'description': 'Classic margherita',
            'price': '299.00',
            'thumbnail': 'https://example.com/pizza.jpg',
            'track_inventory': False,
            'food_details': {
                'food_type': 'VEG',
                'cuisine_type': 'Italian',
                'spice_level': 1,
                'calories': 250,
                'preparation_time': 20,
            },
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(
            response.data['data']['food_details']['food_type'], 'VEG',
        )

    def test_create_food_product_missing_food_details(self):
        food_cat = Category.objects.create(
            name='Snacks', slug='snacks', category_type='FOOD',
        )
        self.client.force_authenticate(user=self.vendor)
        response = self.client.post('/api/v1/products/create/', {
            'name': 'Bad Food',
            'sku': 'FOOD-BAD',
            'product_type': 'FOOD',
            'category': str(food_cat.id),
            'description': 'Missing food details',
            'price': '199.00',
            'thumbnail': 'https://example.com/img.jpg',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_update_product(self):
        self.client.force_authenticate(user=self.vendor)
        response = self.client.patch(
            f'/api/v1/products/{self.product.slug}/update/',
            {'price': '899.00'}, format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.product.refresh_from_db()
        self.assertEqual(self.product.price, Decimal('899.00'))

    def test_soft_delete_product(self):
        self.client.force_authenticate(user=self.vendor)
        response = self.client.delete(f'/api/v1/products/{self.product.slug}/delete/')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.product.refresh_from_db()
        self.assertFalse(self.product.is_active)

    def test_add_variant(self):
        self.client.force_authenticate(user=self.vendor)
        response = self.client.post(
            f'/api/v1/products/{self.product.slug}/variants/create/',
            {
                'sku': 'CLO-001-BLU-L',
                'size': 'L',
                'color': 'Blue',
                'color_hex': '#0000FF',
                'stock_quantity': 30,
            }, format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_product_view_track(self):
        initial = self.product.view_count
        response = self.client.post(f'/api/v1/products/{self.product.slug}/view/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.product.refresh_from_db()
        self.assertEqual(self.product.view_count, initial + 1)


class SearchAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.vendor = User.objects.create_user(
            email='vendor@example.com', username='vendor',
            password='TestPass123!', first_name='V', last_name='U', role='VENDOR',
        )
        self.category = Category.objects.create(
            name='T-Shirts', slug='tshirts', category_type='CLOTHING',
        )
        Product.objects.create(
            name='Cotton T-Shirt', slug='cotton-tshirt', sku='S-001',
            product_type='CLOTHING', category=self.category,
            vendor=self.vendor, description='Soft cotton tee',
            price=Decimal('999.00'), thumbnail='https://example.com/img.jpg',
        )

    def test_search(self):
        response = self.client.get('/api/v1/search/', {'q': 'cotton'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('products', response.data['data'])

    def test_search_too_short(self):
        response = self.client.get('/api/v1/search/', {'q': 'c'})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_search_suggestions(self):
        response = self.client.get('/api/v1/search/suggestions/', {'q': 'cotton'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('suggestions', response.data['data'])

    def test_search_by_type(self):
        response = self.client.get('/api/v1/search/', {'q': 'cotton', 'type': 'products'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('products', response.data['data'])
        self.assertNotIn('categories', response.data['data'])


class BrandAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        Brand.objects.create(name='Nike', slug='nike')
        Brand.objects.create(name='Adidas', slug='adidas')

    def test_list_brands(self):
        response = self.client.get('/api/v1/brands/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_brand_as_admin(self):
        admin = User.objects.create_user(
            email='admin@example.com', username='admin',
            password='TestPass123!', first_name='A', last_name='U', role='ADMIN',
        )
        self.client.force_authenticate(user=admin)
        response = self.client.post('/api/v1/brands/create/', {
            'name': 'Puma',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
