import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/notification_endpoints.dart';
import 'package:library_management_sys/model/notification_model.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:logger/logger.dart';

class NotificationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  final Logger _logger = Logger();

  Future<Map<String, dynamic>> getNotification(
      BuildContext context, int page, int limit) async {
    String url =
        '${NotificationEndpoints.notification}?page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d("Fetch notifications URL: $url");
      }
      final dynamic response = await _apiServices.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage(
            "No notifications received from server", context);
        return {"notifications": [], "next": null};
      }
      if (response['error'] != null && response['error'] == true) {
        _logger.w(
            "Error fetching notifications: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return {"notifications": [], "next": null};
      }

      List<NotificationModel> notifications = (response['data'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';

      return {"notifications": notifications, "next": next};
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for fetching notifications");
      Utils.flushBarErrorMessage(
          "No internet connection. Please try again later.", context);
      return {"notifications": [], "next": null};
    } catch (error) {
      _logger.e("Error fetching notifications: $error");
      Utils.flushBarErrorMessage(
          "Error fetching notifications: $error", context);
      return {"notifications": [], "next": null};
    }
  }

  Future<bool> markNotification(BuildContext context) async {
    final timestamp = DateTime.now().toUtc().toIso8601String();
    String url = "${NotificationEndpoints.markNotifications}$timestamp";
    try {
      if (kDebugMode) {
        _logger.d("Mark notifications URL: $url");
      }
      final dynamic response = await _apiServices.putUrlResponse(url);
      _logger.w(
          "Error marking notifications: ${response['errorMessage'] ?? 'Unknown error'}");
      _logger.d("Response from marking notifications: $response");
      if (response['error'] != null && response['error'] == true) {
        _logger.w(
            "Error marking notifications: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for marking notifications");
      Utils.flushBarErrorMessage(
          "No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error marking notifications: $error");
      Utils.flushBarErrorMessage(
          "Error marking notifications: $error", context);
      return false;
    }
  }
}
