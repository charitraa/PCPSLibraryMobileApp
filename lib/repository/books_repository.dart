import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/book_endpoints.dart';
import 'package:library_management_sys/model/book_info_model.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/model/reservation_model.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:logger/logger.dart';

class BooksRepository {
  final BaseApiServices _apiService = NetworkApiService();
  final logger = Logger();

  Future<Map<String, dynamic>> recommended(
      String seed,
      String bookAuthor,
      String publisher,
      String bookGenres,
      int page,
      int limit,
      BuildContext context) async {
    String url = '';
    if (bookAuthor.isNotEmpty) {
      url =
      '${BookEndPoints.bookUrl}?seed=$seed&bookAuthor=$bookAuthor&page=$page&pageSize=$limit';
    } else if (publisher.isNotEmpty) {
      url =
      '${BookEndPoints.bookUrl}?seed=$seed&publisher=$publisher&page=$page&pageSize=$limit';
    } else if (bookGenres.isNotEmpty) {
      url =
      '${BookEndPoints.bookUrl}?seed=$seed&bookGenres=$bookGenres&page=$page&pageSize=$limit';
    } else {
      url = '${BookEndPoints.bookUrl}?seed=$seed&page=$page&pageSize=$limit';
    }

    try {
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No data received from server", context);
        return {"booksList": [], "next": null};
      }

      List<BooksModel> booksList = (response['data'] as List)
          .map((e) => BooksModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        logger.d("Recommended books URL: $url");
      }

      final next = response['info']?['next'] ?? '';

      return {"booksList": booksList, "next": next};
    } on TimeoutException {
      logger.e("Timeout: No internet connection for recommended books");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"booksList": [], "next": null};
    } catch (error) {
      logger.e("Error fetching recommended books: $error");
      Utils.flushBarErrorMessage("Error: $error", context);
      return {"booksList": [], "next": null};
    }
  }

  Future<Map<String, dynamic>> fetchBooks(
      String seed,
      String bookAuthor,
      String publisher,
      String bookGenres,
      int page,
      int limit,
      BuildContext context) async {
    String url = '';
    if (bookAuthor.isNotEmpty) {
      url =
      '${BookEndPoints.bookUrl}?seed=$seed&author=$bookAuthor&page=$page&pageSize=$limit';
    } else if (publisher.isNotEmpty) {
      url =
      '${BookEndPoints.bookUrl}?seed=$seed&publisher=$publisher&page=$page&pageSize=$limit';
    } else if (bookGenres.isNotEmpty) {
      url =
      '${BookEndPoints.bookUrl}?seed=$seed&genre=$bookGenres&page=$page&pageSize=$limit';
    } else {
      url = '${BookEndPoints.bookUrl}?seed=$seed&page=$page&pageSize=$limit';
    }

    try {
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No data received from server", context);
        return {"booksList": [], "next": null};
      }

      List<BooksModel> booksList = (response['data'] as List)
          .map((e) => BooksModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        logger.d("Fetch books URL: $url");
        logger.d("Books fetched: $booksList");
      }

      final next = response['info']?['next'] ?? '';

      return {"booksList": booksList, "next": next};
    } on TimeoutException {
      logger.e("Timeout: No internet connection for fetching books");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"booksList": [], "next": null};
    } catch (error) {
      logger.e("Error fetching books: $error");
      Utils.flushBarErrorMessage("Error: $error", context);
      return {"booksList": [], "next": null};
    }
  }

  Future<BookInfoModel> getIndividualBooks(
      String uid, BuildContext context) async {
    try {
      final dynamic response =
      await _apiService.getApiResponse("${BookEndPoints.bookUrl}/$uid");
      if (response == null) {
        logger.w("No data received for book UID: $uid");
        Utils.flushBarErrorMessage("No data received from server", context);
        throw Exception("No data received");
      }
      if (response['error'] != null && response['error'] == true) {
        final errorMessage = response['errorMessage'] ?? "Unknown error";
        logger.e("API error for book UID $uid: $errorMessage");
        Utils.flushBarErrorMessage(errorMessage, context);
        throw Exception(errorMessage);
      }
      return BookInfoModel.fromJson(response);
    } on TimeoutException {
      logger.e("Timeout: No internet connection for fetching individual book");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      throw Exception("No internet connection");
    } catch (e) {
      logger.e("Error getting individual book: $e");
      Utils.flushBarErrorMessage(e.toString(), context);
      throw e;
    }
  }

  Future<bool> reserveBook(String uid, BuildContext context) async {
    try {
      if (kDebugMode) {
        logger.d("Reserving book with URL: ${BookEndPoints.renewalUrl}/$uid");
      }
      final dynamic response =
      await _apiService.postUrlResponse("${BookEndPoints.renewalUrl}/$uid");

      if (response == null) {
        logger.w("Server did not respond for reservation UID: $uid");
        Utils.flushBarErrorMessage("Server did not respond", context);
        return false;
      }

      if (response['error'] != null) {
        logger.e("API error for reservation: ${response['error']}");
        Utils.flushBarErrorMessage(
            response['error'] ?? "Unknown error", context);
        return false;
      }
      if (kDebugMode) {
        logger.d("Reservation response: $response");
      }
      return true;
    } on TimeoutException {
      logger.e("Timeout: No internet connection for reserving book");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (e) {
      logger.e("Error reserving book: $e");
      Utils.flushBarErrorMessage("Failed to reserve book: $e", context);
      return false;
    }
  }

  Future<bool> rateBook(String uid, String rate, BuildContext context) async {
    try {
      if (kDebugMode) {
        logger.d("Rating book with URL: ${BookEndPoints.rateUrl}/$uid/$rate");
      }
      final dynamic response = await _apiService
          .postUrlResponse("${BookEndPoints.rateUrl}/$uid/$rate");

      if (response == null) {
        logger.w("Server did not respond for rating UID: $uid");
        Utils.flushBarErrorMessage("Server did not respond", context);
        return false;
      }

      if (response['error'] != null) {
        logger.e("API error for rating: ${response['error']}");
        Utils.flushBarErrorMessage(
            response['error'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      logger.e("Timeout: No internet connection for rating book");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (e) {
      logger.e("Error rating book: $e");
      Utils.flushBarErrorMessage("Failed to rate the book: $e", context);
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchReservation(String filter, String seed,
      int page, int limit, BuildContext context) async {
    String url =
        '${BookEndPoints.reserveUrl}?status=$filter&seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        logger.d("Fetch reservation URL: $url");
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        logger.w("No data received for reservation URL: $url");
        Utils.flushBarErrorMessage("No data received from server", context);
        return {"reservations": [], "next": null};
      }

      List<ReservationModel> reservations = (response['data'] as List)
          .map((e) => ReservationModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        logger.d("Reservations fetched: $reservations");
      }

      final next = response['info']?['next'] ?? '';
      return {"reservations": reservations, "next": next};
    } on TimeoutException {
      logger.e("Timeout: No internet connection for fetching reservations");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"reservations": [], "next": null};
    } catch (error) {
      logger.e("Error fetching reservations: $error");
      Utils.flushBarErrorMessage("Failed to get reservations: $error", context);
      return {"reservations": [], "next": null};
    }
  }

  Future<bool> cancelReservation(String uid, BuildContext context) async {
    try {
      if (kDebugMode) {
        logger.d("Canceling reservation with URL: ${BookEndPoints.cancelReservation}/$uid");
      }
      final dynamic response = await _apiService
          .getDeleteApiResponse("${BookEndPoints.cancelReservation}/$uid");

      if (response == null) {
        logger.w("Server did not respond for cancel reservation UID: $uid");
        Utils.flushBarErrorMessage("Server did not respond", context);
        return false;
      }

      if (response['error'] != null) {
        logger.e("API error for cancel reservation: ${response['error']}");
        Utils.flushBarErrorMessage(
            response['error'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      logger.e("Timeout: No internet connection for canceling reservation");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (e) {
      logger.e("Error canceling reservation: $e");
      Utils.flushBarErrorMessage("Failed to cancel reservation: $e", context);
      return false;
    }
  }
}