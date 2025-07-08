import 'package:flutter/foundation.dart';
import '../domain/entities/notification.dart';
import '../domain/usecases/get_notifications_use_case.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationProvider with ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationStatus _status = NotificationStatus.initial;
  List<Notification> _notifications = [];
  String? _error;

  NotificationProvider({required GetNotificationsUseCase getNotificationsUseCase})
      : _getNotificationsUseCase = getNotificationsUseCase;

  NotificationStatus get status => _status;
  List<Notification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.read).length;
  String? get error => _error;

  Future<void> getNotifications() async {
    _status = NotificationStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _getNotificationsUseCase.execute();

    result.fold(
          (failure) {
        _status = NotificationStatus.error;
        _error = failure.message;
        notifyListeners();
      },
          (notifications) {
        _status = NotificationStatus.loaded;
        _notifications = notifications;
        notifyListeners();
      },
    );
  }
}