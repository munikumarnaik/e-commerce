from django.utils import timezone
from rest_framework import generics, status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from apps.users.models import Address, User
from apps.users.services import (
    create_email_verification_token,
    create_password_reset_token,
    reset_password,
    send_password_reset_email,
    send_verification_email,
    verify_email,
)

from .serializers import (
    AddressCreateSerializer,
    AddressSerializer,
    ChangePasswordSerializer,
    EmailVerifySerializer,
    FCMTokenSerializer,
    LoginSerializer,
    LogoutSerializer,
    PasswordResetConfirmSerializer,
    PasswordResetRequestSerializer,
    ProfileUpdateSerializer,
    RegisterSerializer,
    UserSerializer,
)


def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'access': str(refresh.access_token),
        'refresh': str(refresh),
    }


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        # Create and send verification email
        verification_token = create_email_verification_token(user)
        send_verification_email(user, verification_token.token)

        tokens = get_tokens_for_user(user)

        return Response({
            'success': True,
            'status': status.HTTP_201_CREATED,
            'data': {
                'user': UserSerializer(user).data,
                'tokens': tokens,
            },
            'message': 'Registration successful. Please verify your email.',
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']

        # Update last login
        user.last_login = timezone.now()
        user.save(update_fields=['last_login'])

        tokens = get_tokens_for_user(user)

        return Response({
            'success': True,
            'status': status.HTTP_200_OK,
            'data': {
                'user': UserSerializer(user).data,
                'tokens': tokens,
            },
            'message': 'Login successful',
        })


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = LogoutSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        try:
            token = RefreshToken(serializer.validated_data['refresh'])
            token.blacklist()
        except Exception:
            return Response({
                'success': False,
                'status': status.HTTP_400_BAD_REQUEST,
                'message': 'Invalid refresh token.',
            }, status=status.HTTP_400_BAD_REQUEST)

        return Response(status=status.HTTP_204_NO_CONTENT)


class TokenRefreshView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        refresh_token = request.data.get('refresh')
        if not refresh_token:
            return Response({
                'success': False,
                'message': 'Refresh token is required.',
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            token = RefreshToken(refresh_token)
            new_access = str(token.access_token)

            # Rotate refresh token
            token.blacklist()
            new_refresh = RefreshToken.for_user(token.payload.get('user_id'))

            return Response({
                'success': True,
                'data': {
                    'access': new_access,
                    'refresh': str(new_refresh),
                },
            })
        except Exception:
            return Response({
                'success': False,
                'message': 'Invalid or expired refresh token.',
            }, status=status.HTTP_401_UNAUTHORIZED)


class EmailVerifyView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = EmailVerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        success, message = verify_email(serializer.validated_data['token'])

        if success:
            return Response({'success': True, 'message': message})
        return Response({'success': False, 'message': message}, status=status.HTTP_400_BAD_REQUEST)


class PasswordResetRequestView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = PasswordResetRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data['email'].lower()

        try:
            user = User.objects.get(email=email, is_active=True)
            reset_token = create_password_reset_token(user)
            send_password_reset_email(user, reset_token.token)
        except User.DoesNotExist:
            pass  # Don't reveal whether the email exists

        return Response({
            'success': True,
            'message': 'Password reset email sent successfully',
        })


class PasswordResetConfirmView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = PasswordResetConfirmSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        success, message = reset_password(
            serializer.validated_data['token'],
            serializer.validated_data['password'],
        )

        if success:
            return Response({'success': True, 'message': message})
        return Response({'success': False, 'message': message}, status=status.HTTP_400_BAD_REQUEST)


class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        serializer = UserSerializer(request.user)
        return Response({
            'success': True,
            'data': serializer.data,
        })

    def patch(self, request, *args, **kwargs):
        serializer = ProfileUpdateSerializer(request.user, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response({
            'success': True,
            'data': UserSerializer(request.user).data,
            'message': 'Profile updated successfully',
        })


class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = ChangePasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        if not request.user.check_password(serializer.validated_data['old_password']):
            return Response({
                'success': False,
                'message': 'Current password is incorrect.',
            }, status=status.HTTP_400_BAD_REQUEST)

        request.user.set_password(serializer.validated_data['new_password'])
        request.user.save(update_fields=['password'])

        return Response({
            'success': True,
            'message': 'Password changed successfully.',
        })


class FCMTokenView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = FCMTokenSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        request.user.fcm_token = serializer.validated_data['fcm_token']
        request.user.save(update_fields=['fcm_token'])

        return Response({
            'success': True,
            'message': 'FCM token updated successfully',
        })


# ──────────────────────────────────────────────
# Address Views
# ──────────────────────────────────────────────
class AddressListCreateView(APIView):
    """GET /addresses/ — List addresses. POST /addresses/ — Create address."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        addresses = Address.objects.filter(user=request.user, is_active=True)
        is_default = request.query_params.get('is_default')
        if is_default is not None:
            addresses = addresses.filter(is_default=is_default.lower() == 'true')
        serializer = AddressSerializer(addresses, many=True)
        return Response({
            'success': True,
            'data': {'count': addresses.count(), 'results': serializer.data},
        })

    def post(self, request, *args, **kwargs):
        serializer = AddressCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        address = serializer.save(user=request.user)
        return Response({
            'success': True,
            'data': AddressSerializer(address).data,
            'message': 'Address created successfully.',
        }, status=status.HTTP_201_CREATED)


class AddressDetailView(APIView):
    """PATCH /addresses/{id}/ — Update. DELETE /addresses/{id}/ — Soft delete."""
    permission_classes = [IsAuthenticated]

    def _get_address(self, request, address_id):
        try:
            return Address.objects.get(id=address_id, user=request.user, is_active=True)
        except Address.DoesNotExist:
            return None

    def patch(self, request, *args, **kwargs):
        address = self._get_address(request, kwargs.get('address_id'))
        if not address:
            return Response({'success': False, 'message': 'Address not found.'}, status=status.HTTP_404_NOT_FOUND)

        serializer = AddressCreateSerializer(address, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({
            'success': True,
            'data': AddressSerializer(address).data,
            'message': 'Address updated successfully.',
        })

    def delete(self, request, *args, **kwargs):
        address = self._get_address(request, kwargs.get('address_id'))
        if not address:
            return Response({'success': False, 'message': 'Address not found.'}, status=status.HTTP_404_NOT_FOUND)

        address.is_active = False
        address.save(update_fields=['is_active', 'updated_at'])
        return Response(status=status.HTTP_204_NO_CONTENT)


class AddressSetDefaultView(APIView):
    """POST /addresses/{id}/set-default/ — Set as default address."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        try:
            address = Address.objects.get(
                id=kwargs.get('address_id'), user=request.user, is_active=True,
            )
        except Address.DoesNotExist:
            return Response({'success': False, 'message': 'Address not found.'}, status=status.HTTP_404_NOT_FOUND)

        address.is_default = True
        address.save()
        return Response({
            'success': True,
            'message': 'Default address updated successfully.',
        })
