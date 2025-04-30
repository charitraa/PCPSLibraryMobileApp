import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:library_management_sys/endpoints/notification_endpoints.dart';
import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../model/notification_model.dart';
import '../utils/utils.dart';

class NotificationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<Map<String,dynamic>> getNotification(BuildContext context, int page, int limit) async {
    try {
      String url='${NotificationEndpoints.notification}?page=$page&pageSize=$limit';
      print(url);
      dynamic response =
      await _apiServices.getApiResponse(url);
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
      List<NotificationModel> notifications = [];
      if (response['data'] != null && response['data'] is List) {
        notifications = (response['data'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      }

      final next= response['info']?['next'];

      return {"notifications":notifications,"next":next};
    }on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    }  catch (e) {
      print('Error: $e');
      Utils.flushBarErrorMessage(e.toString(), context);
      rethrow;
    }
  }

  Future<void> marktNotification(BuildContext context) async {
    try {
      final date = DateTime.now();
      final timestamp = date.millisecondsSinceEpoch.toString();

      print(NotificationEndpoints.markNotifications + timestamp);

      dynamic response = await _apiServices
          .putUrlResponse(NotificationEndpoints.markNotifications + timestamp);

      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
    } on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    } catch (e) {
      print('Error: $e');
      Utils.flushBarErrorMessage(e.toString(), context);
      rethrow; // Ensure the error propagates
    }
  }

}

