import secrets
from datetime import timedelta

from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils import timezone

from .models import EmailVerificationToken, PasswordResetToken


def generate_token():
    return secrets.token_urlsafe(48)


def create_email_verification_token(user):
    """Create a new email verification token for the user."""
    # Invalidate any existing unused tokens
    EmailVerificationToken.objects.filter(user=user, is_used=False).update(is_used=True)

    token = generate_token()
    expiry_hours = getattr(settings, 'EMAIL_VERIFICATION_TOKEN_EXPIRY', 24)
    verification_token = EmailVerificationToken.objects.create(
        user=user,
        token=token,
        expires_at=timezone.now() + timedelta(hours=expiry_hours),
    )
    return verification_token


def send_verification_email(user, token):
    """Send email verification link to the user."""
    subject = 'Verify your email address'
    message = (
        f'Hello {user.first_name},\n\n'
        f'Please verify your email address using the following token:\n\n'
        f'{token}\n\n'
        f'This token will expire in {settings.EMAIL_VERIFICATION_TOKEN_EXPIRY} hours.\n\n'
        f'If you did not create an account, please ignore this email.'
    )
    send_mail(
        subject=subject,
        message=message,
        from_email=settings.DEFAULT_FROM_EMAIL,
        recipient_list=[user.email],
        fail_silently=True,
    )


def verify_email(token_str):
    """Verify the email using the token. Returns (success, message)."""
    try:
        token = EmailVerificationToken.objects.get(token=token_str, is_used=False)
    except EmailVerificationToken.DoesNotExist:
        return False, 'Invalid or expired verification token.'

    if token.is_expired:
        return False, 'Verification token has expired.'

    token.is_used = True
    token.save(update_fields=['is_used'])

    user = token.user
    user.is_verified = True
    user.save(update_fields=['is_verified'])

    return True, 'Email verified successfully.'


def create_password_reset_token(user):
    """Create a password reset token for the user."""
    # Invalidate any existing unused tokens
    PasswordResetToken.objects.filter(user=user, is_used=False).update(is_used=True)

    token = generate_token()
    expiry_hours = getattr(settings, 'PASSWORD_RESET_TOKEN_EXPIRY', 1)
    reset_token = PasswordResetToken.objects.create(
        user=user,
        token=token,
        expires_at=timezone.now() + timedelta(hours=expiry_hours),
    )
    return reset_token


def send_password_reset_email(user, token):
    """Send password reset link to the user."""
    subject = 'Reset your password'
    message = (
        f'Hello {user.first_name},\n\n'
        f'You have requested to reset your password. Use the following token:\n\n'
        f'{token}\n\n'
        f'This token will expire in {settings.PASSWORD_RESET_TOKEN_EXPIRY} hour(s).\n\n'
        f'If you did not request this, please ignore this email.'
    )
    send_mail(
        subject=subject,
        message=message,
        from_email=settings.DEFAULT_FROM_EMAIL,
        recipient_list=[user.email],
        fail_silently=True,
    )


def reset_password(token_str, new_password):
    """Reset the password using the token. Returns (success, message)."""
    try:
        token = PasswordResetToken.objects.get(token=token_str, is_used=False)
    except PasswordResetToken.DoesNotExist:
        return False, 'Invalid or expired reset token.'

    if token.is_expired:
        return False, 'Reset token has expired.'

    token.is_used = True
    token.save(update_fields=['is_used'])

    user = token.user
    user.set_password(new_password)
    user.save(update_fields=['password'])

    return True, 'Password reset successful.'
