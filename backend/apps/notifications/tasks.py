from celery import shared_task


@shared_task(name='notifications.send_order_status_notification')
def send_order_status_notification(order_id, new_status):
    """Async task: create notification for order status change."""
    from apps.orders.models import Order
    from apps.notifications.services import notify_order_status_change

    try:
        order = Order.objects.select_related('user').get(id=order_id)
    except Order.DoesNotExist:
        return

    notify_order_status_change(order, new_status)


@shared_task(name='notifications.send_custom_notification')
def send_custom_notification(user_id, notification_type, title, message, action_url=''):
    """Async task: send a custom notification to a user."""
    from apps.users.models import User
    from apps.notifications.services import create_notification

    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return

    create_notification(
        user=user,
        notification_type=notification_type,
        title=title,
        message=message,
        action_url=action_url,
    )
