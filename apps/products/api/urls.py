from django.urls import path

from . import views

app_name = 'products'

urlpatterns = [
    # Categories
    path('categories/', views.CategoryListView.as_view(), name='category-list'),
    path('categories/tree/', views.CategoryTreeView.as_view(), name='category-tree'),
    path('categories/create/', views.CategoryCreateView.as_view(), name='category-create'),
    path('categories/<slug:slug>/', views.CategoryDetailView.as_view(), name='category-detail'),

    # Brands
    path('brands/', views.BrandListView.as_view(), name='brand-list'),
    path('brands/create/', views.BrandCreateView.as_view(), name='brand-create'),

    # Products
    path('products/', views.ProductListView.as_view(), name='product-list'),
    path('products/featured/', views.ProductFeaturedView.as_view(), name='product-featured'),
    path('products/create/', views.ProductCreateView.as_view(), name='product-create'),
    path('products/<slug:slug>/', views.ProductDetailView.as_view(), name='product-detail'),
    path('products/<slug:slug>/update/', views.ProductUpdateView.as_view(), name='product-update'),
    path('products/<slug:slug>/delete/', views.ProductDeleteView.as_view(), name='product-delete'),
    path('products/<slug:slug>/view/', views.ProductViewTrackView.as_view(), name='product-view-track'),

    # Product Variants
    path('products/<slug:slug>/variants/', views.ProductVariantListView.as_view(), name='product-variant-list'),
    path('products/<slug:slug>/variants/create/', views.ProductVariantCreateView.as_view(), name='product-variant-create'),

    # Product Images
    path('products/<slug:slug>/images/upload/', views.ProductImageUploadView.as_view(), name='product-image-upload'),
    path('products/images/<uuid:image_id>/delete/', views.ProductImageDeleteView.as_view(), name='product-image-delete'),

    # Search
    path('search/', views.SearchView.as_view(), name='search'),
    path('search/suggestions/', views.SearchSuggestionsView.as_view(), name='search-suggestions'),
]
