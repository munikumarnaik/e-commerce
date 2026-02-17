from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/<str:version>/', include('apps.users.api.urls')),
    path('api/<str:version>/', include('apps.products.api.urls')),
    path('api/<str:version>/', include('apps.cart.api.urls')),
    path('api/<str:version>/', include('apps.orders.api.urls')),
]
