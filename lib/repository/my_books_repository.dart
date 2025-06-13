import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/book_endpoints.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/model/due_model.dart';
import 'package:library_management_sys/model/my_books_model.dart';
import 'package:library_management_sys/model/my_payment.dart';
import 'package:library_management_sys/utils/utils.dart';

class MyBooksRepository {
  final BaseApiServices _apiService = NetworkApiService();
  Future<Map<String, dynamic>> myBooks(BuildContext context) async {
    try {
      print(BookEndPoints.myBooks);
      dynamic response =
          await _apiService.getApiResponse(BookEndPoints.myBooks);
      List<MyBooksModel> booksList =
          (response as List).map((e) => MyBooksModel.fromJson(e)).toList();

      return {"booksList": booksList};
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (error) {
      print(error);
      return Utils.flushBarErrorMessage(" $error", context);
    }
  }

  Future<Map<String, dynamic>> getPayment(
      int page, int limit, BuildContext context) async {
    String url = '${BookEndPoints.pay}?page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        print(url);
      }
      dynamic response = await _apiService.getApiResponse(url);
      print('check for null ${response['data']}');
      List<PaymentModel> reservations = (response['data'] as List)
          .map((e) => PaymentModel.fromJson(e))
          .toList();

      final next = response['info']?['next'];
      return {"reservations": reservations, "next": next};
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (error) {
      return Utils.flushBarErrorMessage(
          "Failed to get Reservation. Please try again. ${error.toString()}",
          context);
    }
  }

  Future<Map<String, dynamic>> getDues(BuildContext context) async {
    try {
      print(BookEndPoints.due);
      dynamic response = await _apiService.getApiResponse(BookEndPoints.due);
      List<DueModel> booksList =
          (response as List).map((e) => DueModel.fromJson(e)).toList();

      return {"booksList": booksList};
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (error) {
      print(error);
      return Utils.flushBarErrorMessage(" $error", context);
    }
  }

  Future<bool> renew(String uid, BuildContext context) async {
    try {
      print("${BookEndPoints.renewalUrl}/$uid");

      dynamic response =
          await _apiService.postUrlResponse("${BookEndPoints.renewalUrl}/$uid");

      if (response == null) {
        Utils.flushBarErrorMessage("Server did not respond", context);
        return false;
      }

      if (response['error'] != null) {
        Utils.flushBarErrorMessage(
            response['error'] ?? "Unknown error", context);
        return false;
      }
      print(response);
      return true;
    } on TimeoutException {
      return Utils.noInternet(
          "No internet connection. Please try again later.");
    } catch (e) {
      print("Error reserving book: $e");
      Utils.flushBarErrorMessage(
          "Failed to reserve book. Please try again.  $e", context);
      return false;
    }
  }
}
