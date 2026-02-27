from django.urls import path

from . import views

app_name = 'notifications'

urlpatterns = [
    path(
        'notifications/',
        views.NotificationListView.as_view(),
        name='notification-list',
    ),
    path(
        'notifications/unread-count/',
        views.UnreadCountView.as_view(),
        name='notification-unread-count',
    ),
    path(
        'notifications/mark-all-read/',
        views.NotificationMarkAllReadView.as_view(),
        name='notification-mark-all-read',
    ),
    path(
        'notifications/<uuid:notification_id>/read/',
        views.NotificationMarkReadView.as_view(),
        name='notification-mark-read',
    ),
    path(
        'notifications/<uuid:notification_id>/',
        views.NotificationDeleteView.as_view(),
        name='notification-delete',
    ),
]
