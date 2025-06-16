import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/book_request_endpoints.dart';
import 'package:library_management_sys/model/book_request_model.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:logger/logger.dart';

class BooksRequestRepository {
  final BaseApiServices _apiService = NetworkApiService();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> fetchBooksRequest(
     String seed, int page, int limit, BuildContext context) async {
    String url =
        '${BookRequestEndpoints.bookRequests}?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d("Fetch book requests URL: $url");
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No book requests received from server", context);
        return {"requests": [], "next": null};
      }

      List<BookRequestModel> requestsList = (response['data'] as List)
          .map((e) => BookRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';

      return {"requests": requestsList, "next": next};
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for fetching book requests");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"requests": [], "next": null};
    } catch (error) {
      _logger.e("Error fetching book requests: $error");
      Utils.flushBarErrorMessage("Error fetching book requests: $error", context);
      return {"requests": [], "next": null};
    }
  }

  Future<bool> postRequests(dynamic body, BuildContext context) async {
    String url = "${BookRequestEndpoints.bookRequests}/";
    try {
      if (kDebugMode) {
        _logger.d("Post requests URL: $url");
      }
      final dynamic response = await _apiService.getPostApiResponse(url, body);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error posting requests: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for posting requests");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error posting requests: $error");
      Utils.flushBarErrorMessage("Error posting requests: $error", context);
      return false;
    }
  }

  Future<bool> update(String uid, dynamic body, BuildContext context) async {
    String url = "${BookRequestEndpoints.bookRequests}/$uid";
    try {
      if (kDebugMode) {
        _logger.d("Update book request URL: $url");
      }
      final dynamic response = await _apiService.getPutApiResponse(url, body);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error updating book request: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for updating book request");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error updating book request: $error");
      Utils.flushBarErrorMessage("Error updating book request: $error", context);
      return false;
    }
  }

  Future<bool> delete(String uid, BuildContext context) async {
    String url = "${BookRequestEndpoints.bookRequests}/$uid";
    try {
      if (kDebugMode) {
        _logger.d("Delete book request URL: $url");
      }
      final dynamic response = await _apiService.getDeleteApiResponse(url);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error deleting book request: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for deleting book request");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error deleting book request: $error");
      Utils.flushBarErrorMessage("Error deleting book request: $error", context);
      return false;
    }
  }
}