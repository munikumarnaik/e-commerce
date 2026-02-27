from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.notifications import services
from .serializers import NotificationSerializer


class NotificationListView(APIView):
    """GET /notifications/ — List user's notifications with unread count."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        notifications = services.get_user_notifications(
            user=request.user, filters=request.query_params,
        )
        unread_count = services.get_unread_count(request.user)
        serializer = NotificationSerializer(notifications[:50], many=True)
        return Response({
            'success': True,
            'data': {
                'count': notifications.count(),
                'unread_count': unread_count,
                'results': serializer.data,
            },
        })


class UnreadCountView(APIView):
    """GET /notifications/unread-count/ — Get unread count only (lightweight)."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        count = services.get_unread_count(request.user)
        return Response({
            'success': True,
            'data': {'unread_count': count},
        })


class NotificationMarkReadView(APIView):
    """PATCH /notifications/{id}/read/ — Mark single as read."""
    permission_classes = [IsAuthenticated]

    def patch(self, request, *args, **kwargs):
        notification_id = kwargs.get('notification_id')
        notification = services.mark_as_read(request.user, notification_id)
        return Response({
            'success': True,
            'data': NotificationSerializer(notification).data,
            'message': 'Notification marked as read.',
        })


class NotificationMarkAllReadView(APIView):
    """POST /notifications/mark-all-read/ — Mark all as read."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        count = services.mark_all_as_read(request.user)
        return Response({
            'success': True,
            'data': {'marked_count': count},
            'message': f'{count} notifications marked as read.',
        })


class NotificationDeleteView(APIView):
    """DELETE /notifications/{id}/ — Delete a notification."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, *args, **kwargs):
        notification_id = kwargs.get('notification_id')
        services.delete_notification(request.user, notification_id)
        return Response(status=status.HTTP_204_NO_CONTENT)
