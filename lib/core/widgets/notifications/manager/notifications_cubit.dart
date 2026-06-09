import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/helper/in_app_notification_helper.dart';
import 'package:school_system/core/widgets/notifications/notification_model.dart';
import 'package:school_system/core/widgets/notifications/data/notifications_repo.dart';
import 'package:school_system/core/widgets/notifications/manager/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  Timer? _pollingTimer;

  NotificationsCubit(this.notificationsRepo) : super(NotificationsInitial()) {
    startPolling();
  }

  Future<void> fetchNotifications({bool isSilent = false}) async {
    final token = SharedPrefsHelper.token;
    if (token == null || token.isEmpty) {
      return;
    }
    if (!isSilent) {
      emit(NotificationsLoading());
    }
    try {
      final notifications = await notificationsRepo.fetchNotificationsSummary();

      // Check for new notifications/alerts here and show overlay
      if (state is NotificationsSuccess && isSilent) {
        final previousNotifications = (state as NotificationsSuccess).notifications;
        _checkForNewNotifications(previousNotifications, notifications);
      }

      emit(NotificationsSuccess(notifications));
    } catch (e) {
      if (!isSilent || state is! NotificationsSuccess) {
        String errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.substring('Exception: '.length);
        }
        emit(NotificationsFailure(errorMsg));
      }
    }
  }

  void _checkForNewNotifications(
      List<NotificationModel> oldList, List<NotificationModel> newList) {
    final oldOids = oldList.map((n) => n.oid).toSet();
    for (final newNotif in newList) {
      if (!newNotif.isRead && !oldOids.contains(newNotif.oid)) {
        InAppNotificationHelper.showNotification(
          title: newNotif.title,
          body: newNotif.message,
          isMessage: false,
          payload: newNotif,
        );
      }
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchNotifications(isSilent: true);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> deleteNotification(String oid) async {
    final currentState = state;
    if (currentState is! NotificationsSuccess) return;

    try {
      // Optimistic update
      final currentList = currentState.notifications.toList();
      currentList.removeWhere((n) => n.oid == oid);
      emit(NotificationsSuccess(currentList));

      // Attempt backend delete
      await notificationsRepo.deleteNotification(oid);
    } catch (e) {
      // Revert if it fails
      emit(currentState);
      // Fetching fresh ensures we are completely synced.
      await fetchNotifications();
    }
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
