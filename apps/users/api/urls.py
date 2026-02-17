from django.urls import path

from . import views

app_name = 'users'

urlpatterns = [
    # Authentication
    path('auth/register/', views.RegisterView.as_view(), name='register'),
    path('auth/login/', views.LoginView.as_view(), name='login'),
    path('auth/logout/', views.LogoutView.as_view(), name='logout'),
    path('auth/token/refresh/', views.TokenRefreshView.as_view(), name='token-refresh'),
    path('auth/verify-email/', views.EmailVerifyView.as_view(), name='verify-email'),
    path('auth/password/reset/', views.PasswordResetRequestView.as_view(), name='password-reset'),
    path('auth/password/reset/confirm/', views.PasswordResetConfirmView.as_view(), name='password-reset-confirm'),

    # Profile
    path('users/me/', views.UserProfileView.as_view(), name='user-profile'),
    path('users/me/change-password/', views.ChangePasswordView.as_view(), name='change-password'),
    path('users/me/fcm-token/', views.FCMTokenView.as_view(), name='fcm-token'),

    # Addresses
    path('addresses/', views.AddressListCreateView.as_view(), name='address-list-create'),
    path('addresses/<uuid:address_id>/', views.AddressDetailView.as_view(), name='address-detail'),
    path('addresses/<uuid:address_id>/set-default/', views.AddressSetDefaultView.as_view(), name='address-set-default'),
]
