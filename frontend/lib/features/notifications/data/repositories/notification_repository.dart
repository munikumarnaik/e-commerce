import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/notification_model.dart';

class NotificationRepository {
  final Dio _dio;

  NotificationRepository(this._dio);

  Future<({List<AppNotification> notifications, int unreadCount})>
      getNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final data = response.data as Map<String, dynamic>;
    final results = (data['results'] as List?) ?? [];
    final notifications =
        results.map((e) => AppNotification.fromJson(e)).toList();
    final unreadCount = data['unread_count'] as int? ?? 0;
    return (notifications: notifications, unreadCount: unreadCount);
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(ApiEndpoints.notificationUnreadCount);
    return response.data['unread_count'] as int? ?? 0;
  }

  Future<void> markAsRead(String notificationId) async {
    await _dio.patch(ApiEndpoints.notificationMarkRead(notificationId));
  }

  Future<void> markAllAsRead() async {
    await _dio.post(ApiEndpoints.notificationMarkAllRead);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _dio.delete(ApiEndpoints.notificationDelete(notificationId));
  }

  Future<void> updateFcmToken(String token) async {
    await _dio.post(ApiEndpoints.fcmToken, data: {'fcm_token': token});
  }
}

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepository(dio);
});
