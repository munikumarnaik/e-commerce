import logging

from django.conf import settings
from django.utils import timezone
from rest_framework.exceptions import ValidationError

from apps.notifications.models import Notification

try:
    import firebase_admin
    from firebase_admin import credentials, messaging
    _firebase_available = True
except ImportError:
    _firebase_available = False

logger = logging.getLogger(__name__)

# ──────────────────────────────────────────────
# Firebase Initialization
# ──────────────────────────────────────────────
_firebase_app = None


def _get_firebase_app():
    """Lazily initialize Firebase Admin SDK."""
    global _firebase_app
    if _firebase_app is not None:
        return _firebase_app

    if not _firebase_available:
        logger.warning('firebase-admin not installed. Push notifications disabled.')
        return None

    try:
        # Prefer JSON content from env var (for Render / cloud deployments)
        cred_json = getattr(settings, 'FIREBASE_CREDENTIALS_JSON', '')
        if cred_json:
            import json
            cred_dict = json.loads(cred_json)
            cred = credentials.Certificate(cred_dict)
        else:
            # Fall back to file path (for local development)
            cred_path = getattr(settings, 'FIREBASE_CREDENTIALS_PATH', '')
            if not cred_path:
                logger.warning('Firebase credentials not configured. Push notifications disabled.')
                return None
            cred = credentials.Certificate(cred_path)

        _firebase_app = firebase_admin.initialize_app(cred)
        return _firebase_app
    except Exception:
        logger.exception('Failed to initialize Firebase Admin SDK.')
        return None


# ──────────────────────────────────────────────
# Send FCM Push
# ──────────────────────────────────────────────
def send_fcm_push(fcm_token, title, body, data=None):
    """Send a single FCM push notification. Returns True on success."""
    app = _get_firebase_app()
    if not app:
        return False

    try:
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data=data or {},
            token=fcm_token,
        )
        messaging.send(message)
        return True
    except messaging.UnregisteredError:
        logger.info('FCM token is unregistered: %s...', fcm_token[:20])
        return False
    except Exception:
        logger.exception('Failed to send FCM push.')
        return False


# ──────────────────────────────────────────────
# Notification CRUD
# ──────────────────────────────────────────────
def create_notification(user, notification_type, title, message, action_url='', order=None):
    """Create a Notification record and attempt FCM push."""
    notification = Notification.objects.create(
        user=user,
        notification_type=notification_type,
        title=title,
        message=message,
        action_url=action_url,
        order=order,
    )

    if user.notification_enabled and user.fcm_token:
        data = {
            'notification_id': str(notification.id),
            'type': notification_type,
        }
        if action_url:
            data['action_url'] = action_url
        if order:
            data['order_number'] = order.order_number

        sent = send_fcm_push(
            fcm_token=user.fcm_token,
            title=title,
            body=message,
            data=data,
        )
        if sent:
            notification.fcm_sent = True
            notification.fcm_sent_at = timezone.now()
            notification.save(update_fields=['fcm_sent', 'fcm_sent_at'])

    return notification


def get_user_notifications(user, filters=None):
    """Get notifications for a user with optional filtering."""
    qs = Notification.objects.filter(user=user)

    if filters:
        is_read = filters.get('is_read')
        if is_read is not None:
            qs = qs.filter(is_read=is_read.lower() == 'true')

        notification_type = filters.get('notification_type')
        if notification_type:
            qs = qs.filter(notification_type=notification_type.upper())

    return qs


def get_unread_count(user):
    """Return the count of unread notifications."""
    return Notification.objects.filter(user=user, is_read=False).count()


def mark_as_read(user, notification_id):
    """Mark a single notification as read."""
    try:
        notification = Notification.objects.get(id=notification_id, user=user)
    except Notification.DoesNotExist:
        raise ValidationError({'notification': 'Notification not found.'})

    if not notification.is_read:
        notification.is_read = True
        notification.read_at = timezone.now()
        notification.save(update_fields=['is_read', 'read_at'])

    return notification


def mark_all_as_read(user):
    """Mark all unread notifications as read for a user."""
    return Notification.objects.filter(user=user, is_read=False).update(
        is_read=True, read_at=timezone.now(),
    )


def delete_notification(user, notification_id):
    """Delete a notification."""
    try:
        notification = Notification.objects.get(id=notification_id, user=user)
    except Notification.DoesNotExist:
        raise ValidationError({'notification': 'Notification not found.'})

    notification.delete()


# ──────────────────────────────────────────────
# Order Status → Notification Mapping
# ──────────────────────────────────────────────
ORDER_STATUS_NOTIFICATION_MAP = {
    'PENDING': (
        'ORDER_PLACED',
        'Order Placed',
        'Your order {order_number} has been placed successfully.',
    ),
    'CONFIRMED': (
        'ORDER_CONFIRMED',
        'Order Confirmed',
        'Your order {order_number} has been confirmed.',
    ),
    'PROCESSING': (
        'ORDER_CONFIRMED',
        'Order Processing',
        'Your order {order_number} is being processed.',
    ),
    'SHIPPED': (
        'ORDER_SHIPPED',
        'Order Shipped!',
        'Your order {order_number} has been shipped.',
    ),
    'OUT_FOR_DELIVERY': (
        'ORDER_SHIPPED',
        'Out for Delivery',
        'Your order {order_number} is out for delivery.',
    ),
    'DELIVERED': (
        'ORDER_DELIVERED',
        'Order Delivered',
        'Your order {order_number} has been delivered. Enjoy!',
    ),
    'CANCELLED': (
        'ORDER_CANCELLED',
        'Order Cancelled',
        'Your order {order_number} has been cancelled.',
    ),
    'REFUNDED': (
        'ORDER_CANCELLED',
        'Order Refunded',
        'Your order {order_number} has been refunded.',
    ),
}


def notify_payment_failed(order):
    """Create a Payment Failed notification with no navigation URL."""
    return create_notification(
        user=order.user,
        notification_type='PAYMENT_FAILED',
        title='Payment Failed',
        message=f'Payment for order {order.order_number} failed. Your cart has been restored — please try again.',
        action_url='',
        order=order,
    )


def notify_order_status_change(order, new_status):
    """Create a notification for an order status change."""
    mapping = ORDER_STATUS_NOTIFICATION_MAP.get(new_status)
    if not mapping:
        return None

    notification_type, title, message_template = mapping
    message = message_template.format(order_number=order.order_number)
    action_url = f'/orders/{order.order_number}'

    return create_notification(
        user=order.user,
        notification_type=notification_type,
        title=title,
        message=message,
        action_url=action_url,
        order=order,
    )
