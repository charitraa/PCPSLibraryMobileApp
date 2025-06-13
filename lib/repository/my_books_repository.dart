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
import 'package:logger/logger.dart';

class MyBooksRepository {
  final BaseApiServices _apiService = NetworkApiService();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> myBooks(BuildContext context) async {
    try {
      if (kDebugMode) {
        _logger.d('Fetching my books from ${BookEndPoints.myBooks}');
      }
      final dynamic response = await _apiService.getApiResponse(BookEndPoints.myBooks);
      if (response == null || (response is! List && response['data'] == null)) {
        _logger.w('No data received from myBooks API');
        Utils.flushBarErrorMessage('No books received from server', context);
        return {'booksList': []};
      }
      List<MyBooksModel> booksList = (response is List ? response : response['data'] as List)
          .map((e) => MyBooksModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return {'booksList': booksList};
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for fetching my books');
      Utils.flushBarErrorMessage('No internet connection. Please try again later.', context);
      return {'booksList': []};
    } catch (error) {
      _logger.e('Error fetching my books: $error');
      Utils.flushBarErrorMessage('Error fetching books: $error', context);
      return {'booksList': []};
    }
  }

  Future<Map<String, dynamic>> getPayment(int page, int limit, BuildContext context) async {
    String url = '${BookEndPoints.pay}?page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d('Fetching payments from $url');
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w('No data received from payments API for URL: $url');
        Utils.flushBarErrorMessage('No payments received from server', context);
        return {'reservations': [], 'next': null};
      }
      List<PaymentModel> reservations = (response['data'] as List)
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';
      if (kDebugMode) {
        _logger.d('Payments fetched: $reservations');
      }
      return {'reservations': reservations, 'next': next};
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for fetching payments');
      Utils.flushBarErrorMessage('No internet connection. Please try again later.', context);
      return {'reservations': [], 'next': null};
    } catch (error) {
      _logger.e('Error fetching payments: $error');
      Utils.flushBarErrorMessage('Error fetching payments: $error', context);
      return {'reservations': [], 'next': null};
    }
  }

  Future<Map<String, dynamic>> getDues(BuildContext context) async {
    try {
      if (kDebugMode) {
        _logger.d('Fetching dues from ${BookEndPoints.due}');
      }
      final dynamic response = await _apiService.getApiResponse(BookEndPoints.due);
      if (response == null || (response is! List && response['data'] == null)) {
        _logger.w('No data received from dues API');
        Utils.flushBarErrorMessage('No dues received from server', context);
        return {'booksList': []};
      }
      List<DueModel> booksList = (response is List ? response : response['data'] as List)
          .map((e) => DueModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (kDebugMode) {
        _logger.d('Dues fetched: $booksList');
      }
      return {'booksList': booksList};
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for fetching dues');
      Utils.flushBarErrorMessage('No internet connection. Please try again later.', context);
      return {'booksList': []};
    } catch (error) {
      _logger.e('Error fetching dues: $error');
      Utils.flushBarErrorMessage('Error fetching dues: $error', context);
      return {'booksList': []};
    }
  }

  Future<bool> renew(String uid, BuildContext context) async {
    try {
      if (kDebugMode) {
        _logger.d('Renewing book with URL: ${BookEndPoints.renewalUrl}/$uid');
      }
      final dynamic response =
      await _apiService.postUrlResponse('${BookEndPoints.renewalUrl}/$uid');
      if (response == null) {
        _logger.w('No response from renew API for UID: $uid');
        Utils.flushBarErrorMessage('Server did not respond', context);
        return false;
      }
      if (response['error'] != null) {
        _logger.e('API error for renew: ${response['error']}');
        Utils.flushBarErrorMessage(response['error'] ?? 'Unknown error', context);
        return false;
      }
      if (kDebugMode) {
        _logger.d('Renew response: $response');
      }
      return true;
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for renewing book');
      Utils.flushBarErrorMessage('No internet connection. Please try again later.', context);
      return false;
    } catch (e) {
      _logger.e('Error renewing book: $e');
      Utils.flushBarErrorMessage('Failed to renew book: $e', context);
      return false;
    }
  }
}