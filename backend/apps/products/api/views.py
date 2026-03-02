from datetime import timedelta

from django.contrib.postgres.search import SearchQuery as PgSearchQuery, SearchRank, TrigramSimilarity
from django.db.models import Count, F, Q
from django.utils import timezone
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from rest_framework import generics, status
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.core.permissions import IsAdmin, IsAdminOrVendor
from apps.products.filters import ProductFilter
from apps.products.models import (
    Brand,
    Category,
    Product,
    ProductImage,
    ProductVariant,
    SearchQueryLog,
)
from apps.products.services import delete_file_from_r2, upload_file_to_r2

from .serializers import (
    BrandCreateSerializer,
    BrandSerializer,
    CategoryCreateSerializer,
    CategoryDetailSerializer,
    CategoryListSerializer,
    CategoryTreeSerializer,
    ImageUploadSerializer,
    ProductCreateSerializer,
    ProductDetailSerializer,
    ProductImageSerializer,
    ProductListSerializer,
    ProductVariantCreateSerializer,
    ProductVariantSerializer,
)


# ──────────────────────────────────────────────
# Category Views
# ──────────────────────────────────────────────
class CategoryListView(generics.ListAPIView):
    """List all active categories. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = CategoryListSerializer

    def get_queryset(self):
        qs = Category.objects.filter(is_active=True, parent__isnull=True)
        category_type = self.request.query_params.get('category_type')
        if category_type:
            qs = qs.filter(category_type=category_type)
        return qs.prefetch_related('subcategories').order_by('display_order', 'name')


class CategoryDetailView(generics.RetrieveAPIView):
    """Get category detail by slug. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = CategoryDetailSerializer
    lookup_field = 'slug'

    def get_queryset(self):
        return Category.objects.filter(is_active=True).prefetch_related('subcategories')


class CategoryTreeView(APIView):
    """Get hierarchical category tree. Public endpoint."""
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        category_type = request.query_params.get('category_type')
        qs = Category.objects.filter(is_active=True, parent__isnull=True)
        if category_type:
            qs = qs.filter(category_type=category_type)
        qs = qs.prefetch_related('subcategories').order_by('display_order', 'name')

        if category_type:
            data = CategoryTreeSerializer(qs, many=True).data
        else:
            food = qs.filter(category_type='FOOD')
            clothing = qs.filter(category_type='CLOTHING')
            data = {
                'FOOD': CategoryTreeSerializer(food, many=True).data,
                'CLOTHING': CategoryTreeSerializer(clothing, many=True).data,
            }

        return Response({'success': True, 'data': data})


class CategoryCreateView(generics.CreateAPIView):
    """Create a new category. Admin only."""
    permission_classes = [IsAdmin]
    serializer_class = CategoryCreateSerializer
    queryset = Category.objects.all()

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        category = serializer.save()
        return Response({
            'success': True,
            'data': CategoryListSerializer(category).data,
            'message': 'Category created successfully',
        }, status=status.HTTP_201_CREATED)


# ──────────────────────────────────────────────
# Brand Views
# ──────────────────────────────────────────────
class BrandListView(generics.ListAPIView):
    """List all active brands. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = BrandSerializer
    queryset = Brand.objects.filter(is_active=True)
    search_fields = ['name']


class BrandCreateView(generics.CreateAPIView):
    """Create a new brand. Admin only."""
    permission_classes = [IsAdmin]
    serializer_class = BrandCreateSerializer
    queryset = Brand.objects.all()

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        brand = serializer.save()
        return Response({
            'success': True,
            'data': BrandSerializer(brand).data,
            'message': 'Brand created successfully',
        }, status=status.HTTP_201_CREATED)


# ──────────────────────────────────────────────
# Product Views
# ──────────────────────────────────────────────
@method_decorator(cache_page(60 * 2), name='dispatch')
class ProductListView(generics.ListAPIView):
    """List products with advanced filtering. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = ProductListSerializer
    filterset_class = ProductFilter
    search_fields = ['name', 'description', 'sku']
    ordering_fields = ['price', 'created_at', 'average_rating', 'name']
    ordering = ['-created_at']

    def get_queryset(self):
        return (
            Product.objects
            .filter(is_active=True, is_available=True)
            .select_related('category', 'brand', 'food_details', 'clothing_details')
            .prefetch_related('images', 'variants')
        )


class ProductDetailView(generics.RetrieveAPIView):
    """Get product detail by slug. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = ProductDetailSerializer
    lookup_field = 'slug'

    def get_queryset(self):
        return (
            Product.objects
            .filter(is_active=True)
            .select_related('category', 'brand', 'vendor', 'food_details', 'clothing_details')
            .prefetch_related('images', 'variants')
        )


class ProductFeaturedView(generics.ListAPIView):
    """Get featured products. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = ProductListSerializer

    def get_queryset(self):
        limit = int(self.request.query_params.get('limit', 10))
        qs = (
            Product.objects
            .filter(is_active=True, is_available=True, is_featured=True)
            .select_related('category', 'brand', 'food_details', 'clothing_details')
            .prefetch_related('images', 'variants')
        )
        category_type = self.request.query_params.get('category_type')
        if category_type:
            qs = qs.filter(product_type=category_type)
        return qs[:limit]

    pagination_class = None


class ProductCreateView(generics.CreateAPIView):
    """Create a new product. Admin/Vendor only."""
    permission_classes = [IsAdminOrVendor]
    serializer_class = ProductCreateSerializer

    def perform_create(self, serializer):
        serializer.save(vendor=self.request.user)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        product = serializer.instance
        return Response({
            'success': True,
            'data': ProductDetailSerializer(product).data,
            'message': 'Product created successfully',
        }, status=status.HTTP_201_CREATED)


class ProductUpdateView(generics.UpdateAPIView):
    """Update a product. Admin/Vendor (owner) only."""
    permission_classes = [IsAdminOrVendor]
    serializer_class = ProductCreateSerializer
    lookup_field = 'slug'

    def get_queryset(self):
        user = self.request.user
        if user.role == 'ADMIN':
            return Product.objects.all()
        return Product.objects.filter(vendor=user)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response({
            'success': True,
            'data': ProductDetailSerializer(instance).data,
            'message': 'Product updated successfully',
        })


class ProductDeleteView(generics.DestroyAPIView):
    """Soft-delete a product. Admin/Vendor (owner) only."""
    permission_classes = [IsAdminOrVendor]
    lookup_field = 'slug'

    def get_queryset(self):
        user = self.request.user
        if user.role == 'ADMIN':
            return Product.objects.all()
        return Product.objects.filter(vendor=user)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.is_active = False
        instance.save(update_fields=['is_active'])
        return Response(status=status.HTTP_204_NO_CONTENT)


# ──────────────────────────────────────────────
# Product Variant Views
# ──────────────────────────────────────────────
class ProductVariantListView(generics.ListAPIView):
    """Get variants for a product. Public endpoint."""
    permission_classes = [AllowAny]
    serializer_class = ProductVariantSerializer

    def get_queryset(self):
        slug = self.kwargs['slug']
        return ProductVariant.objects.filter(product__slug=slug, is_active=True)


class ProductVariantCreateView(generics.CreateAPIView):
    """Add a variant to a product. Admin/Vendor only."""
    permission_classes = [IsAdminOrVendor]
    serializer_class = ProductVariantCreateSerializer

    def create(self, request, *args, **kwargs):
        slug = kwargs['slug']
        try:
            product = Product.objects.get(slug=slug)
        except Product.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Product not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        # Check ownership for vendors
        if request.user.role == 'VENDOR' and product.vendor != request.user:
            return Response(
                {'success': False, 'message': 'Permission denied.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        variant = serializer.save(product=product)
        return Response({
            'success': True,
            'data': ProductVariantSerializer(variant).data,
            'message': 'Variant added successfully',
        }, status=status.HTTP_201_CREATED)


# ──────────────────────────────────────────────
# Product Image Views
# ──────────────────────────────────────────────
class ProductImageUploadView(APIView):
    """Upload an image for a product. Admin/Vendor only."""
    permission_classes = [IsAdminOrVendor]
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request, *args, **kwargs):
        slug = kwargs['slug']
        try:
            product = Product.objects.get(slug=slug)
        except Product.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Product not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        if request.user.role == 'VENDOR' and product.vendor != request.user:
            return Response(
                {'success': False, 'message': 'Permission denied.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        serializer = ImageUploadSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        image_file = serializer.validated_data['image']
        alt_text = serializer.validated_data.get('alt_text', '')
        is_primary = serializer.validated_data.get('is_primary', False)

        # Upload to R2
        image_url = upload_file_to_r2(image_file, folder='products')

        # If this is set as primary, unmark others
        if is_primary:
            ProductImage.objects.filter(product=product, is_primary=True).update(is_primary=False)

        # Determine display order
        max_order = ProductImage.objects.filter(product=product).count()

        product_image = ProductImage.objects.create(
            product=product,
            image_url=image_url,
            alt_text=alt_text,
            display_order=max_order,
            is_primary=is_primary,
        )

        return Response({
            'success': True,
            'data': ProductImageSerializer(product_image).data,
            'message': 'Image uploaded successfully',
        }, status=status.HTTP_201_CREATED)


class ProductImageDeleteView(APIView):
    """Delete a product image. Admin/Vendor only."""
    permission_classes = [IsAdminOrVendor]

    def delete(self, request, *args, **kwargs):
        image_id = kwargs['image_id']
        try:
            image = ProductImage.objects.select_related('product').get(id=image_id)
        except ProductImage.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Image not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        if request.user.role == 'VENDOR' and image.product.vendor != request.user:
            return Response(
                {'success': False, 'message': 'Permission denied.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        # Delete from R2
        delete_file_from_r2(image.image_url)
        image.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)


# ──────────────────────────────────────────────
# Product View Tracking
# ──────────────────────────────────────────────
class ProductViewTrackView(APIView):
    """Track a product view. Public endpoint (optional auth)."""
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        slug = kwargs['slug']
        Product.objects.filter(slug=slug).update(view_count=F('view_count') + 1)
        return Response({'success': True})


# ──────────────────────────────────────────────
# Search Endpoint (global) — PostgreSQL Full-Text Search
# ──────────────────────────────────────────────
@method_decorator(cache_page(60 * 5), name='dispatch')
class SearchView(APIView):
    """Global search across products, categories, brands with full-text ranking. Public endpoint."""
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        query = request.query_params.get('q', '').strip()
        if len(query) < 2:
            return Response({
                'success': False,
                'message': 'Search query must be at least 2 characters.',
            }, status=status.HTTP_400_BAD_REQUEST)

        search_type = request.query_params.get('type')
        result = {'query': query}

        if not search_type or search_type == 'products':
            search_query = PgSearchQuery(query, search_type='websearch')
            products = list(
                Product.objects
                .filter(is_active=True, is_available=True)
                .filter(
                    Q(search_vector=search_query)
                    | Q(name__icontains=query)
                )
                .annotate(
                    rank=SearchRank('search_vector', search_query),
                    similarity=TrigramSimilarity('name', query),
                )
                .order_by('-rank', '-similarity')
                .select_related('category', 'brand', 'food_details', 'clothing_details')
                .prefetch_related('images')[:20]
            )
            result['products'] = {
                'count': len(products),
                'results': ProductListSerializer(products, many=True).data,
            }

        if not search_type or search_type == 'categories':
            categories = Category.objects.filter(
                is_active=True, name__icontains=query,
            )[:10]
            result['categories'] = {
                'count': len(categories),
                'results': CategoryListSerializer(categories, many=True).data,
            }

        if not search_type or search_type == 'brands':
            brands = Brand.objects.filter(
                is_active=True, name__icontains=query,
            )[:10]
            result['brands'] = {
                'count': len(brands),
                'results': BrandSerializer(brands, many=True).data,
            }

        # Log search query asynchronously
        product_count = result.get('products', {}).get('count', 0)
        try:
            SearchQueryLog.objects.create(
                query=query,
                results_count=product_count,
                user=request.user if request.user.is_authenticated else None,
            )
        except Exception:
            pass

        return Response({'success': True, 'data': result})


@method_decorator(cache_page(60 * 5), name='dispatch')
class SearchSuggestionsView(APIView):
    """Search autocomplete suggestions with trigram similarity. Public endpoint."""
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        query = request.query_params.get('q', '').strip()
        if len(query) < 2:
            return Response({
                'success': False,
                'message': 'Search query must be at least 2 characters.',
            }, status=status.HTTP_400_BAD_REQUEST)

        suggestions = list(
            Product.objects
            .filter(is_active=True)
            .filter(Q(name__istartswith=query) | Q(name__icontains=query))
            .annotate(similarity=TrigramSimilarity('name', query))
            .order_by('-similarity')
            .values_list('name', flat=True)
            .distinct()[:10]
        )

        return Response({
            'success': True,
            'data': {'suggestions': suggestions},
        })


@method_decorator(cache_page(60 * 15), name='dispatch')
class TrendingSearchesView(APIView):
    """Return trending/popular search queries from the last 7 days. Public endpoint."""
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        days = min(int(request.query_params.get('days', 7)), 30)
        limit = min(int(request.query_params.get('limit', 10)), 20)
        since = timezone.now() - timedelta(days=days)

        trending = (
            SearchQueryLog.objects
            .filter(created_at__gte=since, results_count__gt=0)
            .values('query_normalized')
            .annotate(count=Count('id'))
            .order_by('-count')[:limit]
        )

        results = []
        for entry in trending:
            original = (
                SearchQueryLog.objects
                .filter(query_normalized=entry['query_normalized'])
                .order_by('-created_at')
                .values_list('query', flat=True)
                .first()
            )
            results.append({
                'query': original or entry['query_normalized'],
                'count': entry['count'],
            })

        return Response({
            'success': True,
            'data': {'trending': results},
        })
