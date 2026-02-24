import django_filters
from django.db.models import Q

from .models import Product


class ProductFilter(django_filters.FilterSet):
    # Common filters
    search = django_filters.CharFilter(method='filter_search')
    category = django_filters.UUIDFilter(field_name='category__id')
    category_type = django_filters.ChoiceFilter(
        field_name='category__category_type',
        choices=[('FOOD', 'Food'), ('CLOTHING', 'Clothing')],
    )
    product_type = django_filters.ChoiceFilter(choices=Product.ProductType.choices)
    min_price = django_filters.NumberFilter(field_name='price', lookup_expr='gte')
    max_price = django_filters.NumberFilter(field_name='price', lookup_expr='lte')
    is_featured = django_filters.BooleanFilter()
    brand = django_filters.UUIDFilter(field_name='brand__id')

    # Food-specific filters
    food_type = django_filters.CharFilter(field_name='food_details__food_type')
    cuisine_type = django_filters.CharFilter(field_name='food_details__cuisine_type', lookup_expr='icontains')
    spice_level = django_filters.NumberFilter(field_name='food_details__spice_level')

    # Rating filter
    min_rating = django_filters.NumberFilter(field_name='average_rating', lookup_expr='gte')

    # Clothing-specific filters
    gender = django_filters.CharFilter(field_name='clothing_details__gender')
    size = django_filters.CharFilter(method='filter_by_size')
    color = django_filters.CharFilter(method='filter_by_color')
    material = django_filters.CharFilter(field_name='clothing_details__material', lookup_expr='icontains')
    clothing_type = django_filters.CharFilter(field_name='clothing_details__clothing_type')

    class Meta:
        model = Product
        fields = []

    def filter_search(self, queryset, name, value):
        return queryset.filter(
            Q(name__icontains=value)
            | Q(description__icontains=value)
            | Q(short_description__icontains=value)
            | Q(sku__icontains=value)
        )

    def filter_by_size(self, queryset, name, value):
        return queryset.filter(variants__size__iexact=value, variants__is_active=True).distinct()

    def filter_by_color(self, queryset, name, value):
        return queryset.filter(variants__color__iexact=value, variants__is_active=True).distinct()
