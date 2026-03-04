import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notification_repository.dart';
import '../../domain/models/notification_model.dart';

class NotificationListState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationListState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationListState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationListState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationListNotifier extends StateNotifier<NotificationListState> {
  final NotificationRepository _repository;
  final Ref _ref;

  NotificationListNotifier(this._repository, this._ref)
      : super(const NotificationListState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.getNotifications();
      state = state.copyWith(
        notifications: result.notifications,
        unreadCount: result.unreadCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notifications.',
      );
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      final updated = state.notifications.map((n) {
        if (n.id == id && !n.isRead) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }
        return n;
      }).toList();
      final newUnread = updated.where((n) => !n.isRead).length;
      state = state.copyWith(notifications: updated, unreadCount: newUnread);
      _ref.invalidate(unreadNotificationCountProvider);
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      final updated = state.notifications
          .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
          .toList();
      state = state.copyWith(notifications: updated, unreadCount: 0);
      _ref.invalidate(unreadNotificationCountProvider);
    } catch (_) {}
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _repository.deleteNotification(id);
      final updated =
          state.notifications.where((n) => n.id != id).toList();
      final newUnread = updated.where((n) => !n.isRead).length;
      state = state.copyWith(notifications: updated, unreadCount: newUnread);
      _ref.invalidate(unreadNotificationCountProvider);
    } catch (_) {}
  }
}

final notificationListProvider = StateNotifierProvider.autoDispose<
    NotificationListNotifier, NotificationListState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationListNotifier(repository, ref);
});

final unreadNotificationCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getUnreadCount();
});
