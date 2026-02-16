from datetime import timedelta

from django.test import TestCase
from django.urls import reverse
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APIClient

from apps.users.models import EmailVerificationToken, PasswordResetToken, User
from apps.users.services import (
    create_email_verification_token,
    create_password_reset_token,
    verify_email,
    reset_password,
)


class UserModelTest(TestCase):
    def test_create_user(self):
        user = User.objects.create_user(
            email='test@example.com',
            username='testuser',
            password='TestPass123!',
            first_name='Test',
            last_name='User',
        )
        self.assertEqual(user.email, 'test@example.com')
        self.assertEqual(user.username, 'testuser')
        self.assertEqual(user.role, 'CUSTOMER')
        self.assertTrue(user.is_active)
        self.assertFalse(user.is_staff)
        self.assertFalse(user.is_verified)
        self.assertTrue(user.check_password('TestPass123!'))

    def test_create_user_no_email_raises(self):
        with self.assertRaises(ValueError):
            User.objects.create_user(email='', username='testuser', password='TestPass123!')

    def test_create_user_no_username_raises(self):
        with self.assertRaises(ValueError):
            User.objects.create_user(email='test@example.com', username='', password='TestPass123!')

    def test_create_superuser(self):
        admin = User.objects.create_superuser(
            email='admin@example.com',
            username='admin',
            password='AdminPass123!',
            first_name='Admin',
            last_name='User',
        )
        self.assertEqual(admin.role, 'ADMIN')
        self.assertTrue(admin.is_staff)
        self.assertTrue(admin.is_superuser)
        self.assertTrue(admin.is_verified)

    def test_full_name(self):
        user = User.objects.create_user(
            email='test@example.com',
            username='testuser',
            password='TestPass123!',
            first_name='John',
            last_name='Doe',
        )
        self.assertEqual(user.full_name, 'John Doe')

    def test_role_properties(self):
        customer = User.objects.create_user(
            email='customer@example.com', username='customer',
            password='TestPass123!', first_name='C', last_name='U',
        )
        self.assertTrue(customer.is_customer)
        self.assertFalse(customer.is_vendor)
        self.assertFalse(customer.is_admin)

    def test_email_normalization(self):
        user = User.objects.create_user(
            email='TEST@EXAMPLE.COM',
            username='testuser',
            password='TestPass123!',
            first_name='Test',
            last_name='User',
        )
        self.assertEqual(user.email, 'TEST@example.com')

    def test_str_representation(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        self.assertEqual(str(user), 'test@example.com')


class EmailVerificationServiceTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )

    def test_create_verification_token(self):
        token = create_email_verification_token(self.user)
        self.assertFalse(token.is_used)
        self.assertFalse(token.is_expired)
        self.assertEqual(token.user, self.user)

    def test_verify_email_success(self):
        token = create_email_verification_token(self.user)
        success, message = verify_email(token.token)
        self.assertTrue(success)
        self.user.refresh_from_db()
        self.assertTrue(self.user.is_verified)

    def test_verify_email_invalid_token(self):
        success, message = verify_email('invalid-token')
        self.assertFalse(success)

    def test_verify_email_expired_token(self):
        token = create_email_verification_token(self.user)
        token.expires_at = timezone.now() - timedelta(hours=1)
        token.save()
        success, message = verify_email(token.token)
        self.assertFalse(success)

    def test_old_tokens_invalidated(self):
        token1 = create_email_verification_token(self.user)
        token2 = create_email_verification_token(self.user)
        token1.refresh_from_db()
        self.assertTrue(token1.is_used)
        self.assertFalse(token2.is_used)


class PasswordResetServiceTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )

    def test_create_reset_token(self):
        token = create_password_reset_token(self.user)
        self.assertFalse(token.is_used)
        self.assertFalse(token.is_expired)

    def test_reset_password_success(self):
        token = create_password_reset_token(self.user)
        success, message = reset_password(token.token, 'NewPass456!')
        self.assertTrue(success)
        self.user.refresh_from_db()
        self.assertTrue(self.user.check_password('NewPass456!'))

    def test_reset_password_invalid_token(self):
        success, message = reset_password('invalid-token', 'NewPass456!')
        self.assertFalse(success)

    def test_reset_password_expired_token(self):
        token = create_password_reset_token(self.user)
        token.expires_at = timezone.now() - timedelta(hours=1)
        token.save()
        success, message = reset_password(token.token, 'NewPass456!')
        self.assertFalse(success)


class AuthAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.register_url = '/api/v1/auth/register/'
        self.login_url = '/api/v1/auth/login/'
        self.profile_url = '/api/v1/users/me/'

        self.user_data = {
            'email': 'test@example.com',
            'username': 'testuser',
            'password': 'TestPass123!',
            'password_confirm': 'TestPass123!',
            'first_name': 'Test',
            'last_name': 'User',
            'phone': '+919876543210',
        }

    def test_register_success(self):
        response = self.client.post(self.register_url, self.user_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(response.data['success'])
        self.assertIn('tokens', response.data['data'])
        self.assertIn('user', response.data['data'])
        self.assertEqual(response.data['data']['user']['email'], 'test@example.com')
        self.assertEqual(response.data['data']['user']['role'], 'CUSTOMER')

    def test_register_duplicate_email(self):
        self.client.post(self.register_url, self.user_data, format='json')
        response = self.client.post(self.register_url, self.user_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_register_password_mismatch(self):
        data = self.user_data.copy()
        data['password_confirm'] = 'DifferentPass123!'
        response = self.client.post(self.register_url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_login_success(self):
        User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        response = self.client.post(self.login_url, {
            'email': 'test@example.com',
            'password': 'TestPass123!',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])
        self.assertIn('tokens', response.data['data'])

    def test_login_wrong_password(self):
        User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        response = self.client.post(self.login_url, {
            'email': 'test@example.com',
            'password': 'WrongPass123!',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_profile_unauthenticated(self):
        response = self.client.get(self.profile_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_profile_authenticated(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        self.client.force_authenticate(user=user)
        response = self.client.get(self.profile_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['data']['email'], 'test@example.com')

    def test_profile_update(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        self.client.force_authenticate(user=user)
        response = self.client.patch(self.profile_url, {
            'first_name': 'Updated',
            'last_name': 'Name',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['data']['first_name'], 'Updated')

    def test_logout(self):
        # Register to get tokens
        response = self.client.post(self.register_url, self.user_data, format='json')
        tokens = response.data['data']['tokens']

        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {tokens['access']}")
        response = self.client.post('/api/v1/auth/logout/', {
            'refresh': tokens['refresh'],
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_email_verification_endpoint(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        token = create_email_verification_token(user)
        response = self.client.post('/api/v1/auth/verify-email/', {
            'token': token.token,
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['success'])

    def test_password_reset_flow(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )

        # Request reset
        response = self.client.post('/api/v1/auth/password/reset/', {
            'email': 'test@example.com',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Get the token from DB
        reset_token = PasswordResetToken.objects.filter(user=user, is_used=False).first()
        self.assertIsNotNone(reset_token)

        # Confirm reset
        response = self.client.post('/api/v1/auth/password/reset/confirm/', {
            'token': reset_token.token,
            'password': 'NewSecurePass123!',
            'password_confirm': 'NewSecurePass123!',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Login with new password
        response = self.client.post(self.login_url, {
            'email': 'test@example.com',
            'password': 'NewSecurePass123!',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_change_password(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        self.client.force_authenticate(user=user)
        response = self.client.post('/api/v1/users/me/change-password/', {
            'old_password': 'TestPass123!',
            'new_password': 'NewPass456!@#',
            'new_password_confirm': 'NewPass456!@#',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Verify new password works
        user.refresh_from_db()
        self.assertTrue(user.check_password('NewPass456!@#'))

    def test_change_password_wrong_old(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        self.client.force_authenticate(user=user)
        response = self.client.post('/api/v1/users/me/change-password/', {
            'old_password': 'WrongOldPass!',
            'new_password': 'NewPass456!@#',
            'new_password_confirm': 'NewPass456!@#',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_fcm_token_update(self):
        user = User.objects.create_user(
            email='test@example.com', username='testuser',
            password='TestPass123!', first_name='Test', last_name='User',
        )
        self.client.force_authenticate(user=user)
        response = self.client.post('/api/v1/users/me/fcm-token/', {
            'fcm_token': 'test-fcm-token-123',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user.refresh_from_db()
        self.assertEqual(user.fcm_token, 'test-fcm-token-123')
