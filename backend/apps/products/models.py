import uuid

from django.conf import settings
from django.contrib.postgres.indexes import GinIndex
from django.contrib.postgres.search import SearchVector, SearchVectorField
from django.db import models
from django.utils import timezone
from django.utils.text import slugify


# ──────────────────────────────────────────────
# Category
# ──────────────────────────────────────────────
class Category(models.Model):
    class CategoryType(models.TextChoices):
        FOOD = 'FOOD', 'Food'
        CLOTHING = 'CLOTHING', 'Clothing'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100)
    slug = models.SlugField(max_length=100, unique=True)
    category_type = models.CharField(max_length=20, choices=CategoryType.choices)
    parent = models.ForeignKey(
        'self', null=True, blank=True, on_delete=models.CASCADE, related_name='subcategories',
    )
    image = models.URLField(blank=True, null=True)
    icon = models.URLField(blank=True, null=True)
    description = models.TextField(blank=True)
    display_order = models.IntegerField(default=0)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'categories'
        verbose_name_plural = 'categories'
        ordering = ['display_order', 'name']
        indexes = [
            models.Index(fields=['category_type', 'is_active'], name='idx_categories_type_active'),
            models.Index(fields=['display_order'], name='idx_categories_display_order'),
        ]

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    @property
    def product_count(self):
        return self.products.filter(is_active=True).count()


# ──────────────────────────────────────────────
# Brand
# ──────────────────────────────────────────────
class Brand(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(max_length=100, unique=True)
    logo = models.URLField(blank=True, null=True)
    description = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'brands'
        ordering = ['name']
        indexes = [
            models.Index(fields=['is_active'], name='idx_brands_active'),
        ]

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)


# ──────────────────────────────────────────────
# Product (Base)
# ──────────────────────────────────────────────
class Product(models.Model):
    class ProductType(models.TextChoices):
        FOOD = 'FOOD', 'Food'
        CLOTHING = 'CLOTHING', 'Clothing'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255, unique=True)
    sku = models.CharField(max_length=100, unique=True)
    product_type = models.CharField(max_length=20, choices=ProductType.choices)

    # Relations
    category = models.ForeignKey(Category, on_delete=models.PROTECT, related_name='products')
    brand = models.ForeignKey(Brand, on_delete=models.SET_NULL, null=True, blank=True, related_name='products')
    vendor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='products')

    # Description
    description = models.TextField()
    short_description = models.CharField(max_length=500, blank=True)

    # Pricing
    price = models.DecimalField(max_digits=10, decimal_places=2)
    compare_at_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    cost_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    discount_percentage = models.DecimalField(max_digits=5, decimal_places=2, default=0)

    # Inventory
    stock_quantity = models.IntegerField(default=0)
    low_stock_threshold = models.IntegerField(default=10)
    track_inventory = models.BooleanField(default=True)

    # Media
    thumbnail = models.URLField()

    # SEO
    meta_title = models.CharField(max_length=255, blank=True)
    meta_description = models.TextField(blank=True)

    # Ratings (denormalized for performance)
    average_rating = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    total_reviews = models.IntegerField(default=0)

    # Stats
    view_count = models.IntegerField(default=0)
    order_count = models.IntegerField(default=0)

    # Flags
    is_active = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=False)
    is_available = models.BooleanField(default=True)

    # Full-text search
    search_vector = SearchVectorField(null=True, blank=True)

    # Audit
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'products'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['product_type', 'is_active'], name='idx_products_type_active'),
            models.Index(fields=['-created_at'], name='idx_products_created_desc'),
            models.Index(fields=['-average_rating'], name='idx_products_rating_desc'),
            models.Index(fields=['price'], name='idx_products_price'),
            GinIndex(fields=['search_vector'], name='idx_products_search_gin'),
        ]

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        # Auto-compute discount percentage
        if self.compare_at_price and self.compare_at_price > self.price:
            self.discount_percentage = round(
                ((self.compare_at_price - self.price) / self.compare_at_price) * 100, 2,
            )
        super().save(*args, **kwargs)
        # Update search vector (post-save to ensure PK exists)
        Product.objects.filter(pk=self.pk).update(
            search_vector=(
                SearchVector('name', weight='A')
                + SearchVector('short_description', weight='B')
                + SearchVector('description', weight='C')
                + SearchVector('sku', weight='D')
            )
        )

    @property
    def has_variants(self):
        return self.variants.filter(is_active=True).exists()


# ──────────────────────────────────────────────
# FoodProduct (extends Product via OneToOne)
# ──────────────────────────────────────────────
class FoodProduct(models.Model):
    class FoodType(models.TextChoices):
        VEG = 'VEG', 'Vegetarian'
        NON_VEG = 'NON_VEG', 'Non-Vegetarian'
        VEGAN = 'VEGAN', 'Vegan'
        EGG = 'EGG', 'Egg'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.OneToOneField(Product, on_delete=models.CASCADE, related_name='food_details')

    food_type = models.CharField(max_length=20, choices=FoodType.choices)
    cuisine_type = models.CharField(max_length=100, blank=True)
    spice_level = models.IntegerField(default=0)  # 0-5

    # Nutritional Info
    calories = models.IntegerField(null=True, blank=True)
    protein = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    carbs = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    fat = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)

    # Serving
    serving_size = models.CharField(max_length=100, blank=True)
    preparation_time = models.IntegerField(null=True, blank=True)  # minutes

    # Allergens
    contains_gluten = models.BooleanField(default=False)
    contains_dairy = models.BooleanField(default=False)
    contains_nuts = models.BooleanField(default=False)

    # Packaging
    packaging_type = models.CharField(max_length=100, blank=True)
    is_perishable = models.BooleanField(default=True)
    expiry_days = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = 'food_products'
        indexes = [
            models.Index(fields=['food_type'], name='idx_food_products_food_type'),
            models.Index(fields=['cuisine_type'], name='idx_food_products_cuisine'),
        ]

    def __str__(self):
        return f'Food details for {self.product.name}'


# ──────────────────────────────────────────────
# ClothingProduct (extends Product via OneToOne)
# ──────────────────────────────────────────────
class ClothingProduct(models.Model):
    class Gender(models.TextChoices):
        MEN = 'MEN', 'Men'
        WOMEN = 'WOMEN', 'Women'
        KIDS = 'KIDS', 'Kids'
        UNISEX = 'UNISEX', 'Unisex'

    class ClothingType(models.TextChoices):
        TOPWEAR = 'TOPWEAR', 'Topwear'
        BOTTOMWEAR = 'BOTTOMWEAR', 'Bottomwear'
        FOOTWEAR = 'FOOTWEAR', 'Footwear'
        ACCESSORIES = 'ACCESSORIES', 'Accessories'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.OneToOneField(Product, on_delete=models.CASCADE, related_name='clothing_details')

    gender = models.CharField(max_length=20, choices=Gender.choices)
    clothing_type = models.CharField(max_length=20, choices=ClothingType.choices)

    # Material
    material = models.CharField(max_length=100)
    fabric = models.CharField(max_length=100, blank=True)
    care_instructions = models.TextField(blank=True)

    # Fit & Style
    fit_type = models.CharField(max_length=50, blank=True)
    pattern = models.CharField(max_length=50, blank=True)

    # Dimensions
    length = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    width = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)

    # Season
    season = models.CharField(max_length=50, blank=True)

    class Meta:
        db_table = 'clothing_products'
        indexes = [
            models.Index(fields=['gender'], name='idx_clothing_products_gender'),
            models.Index(fields=['clothing_type'], name='idx_clothing_products_type'),
        ]

    def __str__(self):
        return f'Clothing details for {self.product.name}'


# ──────────────────────────────────────────────
# ProductVariant
# ──────────────────────────────────────────────
class ProductVariant(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='variants')

    sku = models.CharField(max_length=100, unique=True)
    size = models.CharField(max_length=20, blank=True)
    color = models.CharField(max_length=50, blank=True)
    color_hex = models.CharField(max_length=7, blank=True)

    # Pricing (overrides base product price if set)
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)

    # Inventory
    stock_quantity = models.IntegerField(default=0)

    # Media
    image_url = models.URLField(blank=True, null=True)

    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'product_variants'
        unique_together = [('product', 'size', 'color')]
        indexes = [
            models.Index(fields=['product', 'is_active'], name='idx_variants_product_active'),
        ]

    def __str__(self):
        parts = [self.product.name]
        if self.size:
            parts.append(self.size)
        if self.color:
            parts.append(self.color)
        return ' - '.join(parts)


# ──────────────────────────────────────────────
# ProductImage
# ──────────────────────────────────────────────
class ProductImage(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='images')

    image_url = models.URLField()
    alt_text = models.CharField(max_length=255, blank=True)
    display_order = models.IntegerField(default=0)
    is_primary = models.BooleanField(default=False)

    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'product_images'
        ordering = ['display_order']
        indexes = [
            models.Index(fields=['product', 'display_order'], name='idx_product_images_order'),
        ]

    def __str__(self):
        return f'Image for {self.product.name} (order: {self.display_order})'


# ──────────────────────────────────────────────
# Search Query Log (for trending searches)
# ──────────────────────────────────────────────
class SearchQueryLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    query = models.CharField(max_length=255)
    query_normalized = models.CharField(max_length=255, db_index=True)
    results_count = models.IntegerField(default=0)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL,
        null=True, blank=True,
    )
    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        db_table = 'search_query_logs'
        indexes = [
            models.Index(fields=['-created_at'], name='idx_search_log_created'),
            models.Index(fields=['query_normalized', '-created_at'], name='idx_search_log_norm_date'),
        ]

    def save(self, *args, **kwargs):
        self.query_normalized = self.query.strip().lower()
        super().save(*args, **kwargs)

    def __str__(self):
        return f'Search: "{self.query}" ({self.results_count} results)'
