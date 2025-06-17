import 'package:flutter/material.dart';

import '../../data/response/api_response.dart';
import '../../model/notification_model.dart';
import '../../repository/notification_repository.dart';
import '../../utils/utils.dart';

class NotificationViewModel with ChangeNotifier {
  final List<NotificationModel> _notificationList = [];
  final NotificationRepository _notificationRepo = NotificationRepository();
  ApiResponse<NotificationModel> notificationData = ApiResponse.loading();

  int _limit = 1;
  bool _isLoading = false;

  int get limit => _limit;
  bool get isLoading => _isLoading;
  List<NotificationModel> get notificationList => _notificationList;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetchNotifications(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _limit = 1;
      _notificationList.clear();
      final Map<String, dynamic> response =
          await _notificationRepo.getNotification(context, _limit, 10);
      _notificationList.addAll(response['notifications']);
      if (response['next'] != null) {
        _limit++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error fetching notifications: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreNotifications(BuildContext context) async {
    try {
      final Map<String, dynamic> response =
          await _notificationRepo.getNotification(context, _limit, 10);
      if (_limit != null) {
        print("${response['next']}=$_limit");

        _notificationList.addAll(response['notifications']);
        _limit++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error fetching notifications: $error", context);
    }
  }

  Future<bool> markNotifications(BuildContext context) async {
    if (_isLoading) return false;
    setLoading(true);
    try {
      await _notificationRepo.markNotification(context);
      _notificationList.clear();
      _isLoading = false;
      await fetchNotifications(context);
      Future.microtask(() => notifyListeners());
      return true;
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error marking notifications as read: $error", context);
      return false;
    } finally {
      setLoading(false);
    }
  }
}
