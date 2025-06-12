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

class BooksRepository {
  final BaseApiServices _apiService = NetworkApiService();
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
    } else if (seed.isNotEmpty) {
      url = '${BookEndPoints.bookUrl}?seed=$seed&page=$page&pageSize=$limit';
    } else {
      url = '${BookEndPoints.bookUrl}?seed=$seed&page=$page&pageSize=$limit';
    }

    try {
      dynamic response = await _apiService.getApiResponse(url);

      List<BooksModel> booksList = (response['data'] as List)
          .map((e) => BooksModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        print(url);
      }

      final next = response['info']?['next'] ?? '';

      return {"booksList": booksList, "next": next};
    }on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    }  catch (error) {
      print(error);
      return Utils.flushBarErrorMessage(
          "Minal displaued errir $error", context);
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
    } else if (seed.isNotEmpty) {
      url = '${BookEndPoints.bookUrl}?seed=$seed&page=$page&pageSize=$limit';
    } else {
      url = '${BookEndPoints.bookUrl}?seed=$seed&page=$page&pageSize=$limit';
    }

    try {
      print(url);
      dynamic response = await _apiService.getApiResponse(url);

      List<BooksModel> booksList = (response['data'] as List)
          .map((e) => BooksModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        print(url);
        print('bbooks $booksList');
      }

      final next = response['info']?['next'] ?? '';

      return {"booksList": booksList, "next": next};
    }on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    }  catch (error) {
      print(error);
      return Utils.flushBarErrorMessage(
          "Minal displaued errir $error", context);
    }
  }

  Future<BookInfoModel> getIndividualBooks(
      String uid, BuildContext context) async {
    try {
      dynamic response =
          await _apiService.getApiResponse("${BookEndPoints.bookUrl}/$uid");
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
      return BookInfoModel.fromJson(response);
    } on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      throw e;
    }
  }

  Future<bool> reserveBook(String uid, BuildContext context) async {
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
      return Utils.noInternet("No internet connection. Please try again later.");
    } catch (e) {
      print("Error reserving book: $e");
      Utils.flushBarErrorMessage(
          "Failed to reserve book. Please try again.  $e", context);
      return false;
    }
  }

  Future<bool> rateBook(String uid, String rate, BuildContext context) async {
    try {
      dynamic response = await _apiService
          .postUrlResponse("${BookEndPoints.rateUrl}/$uid/$rate");

      if (response == null) {
        Utils.flushBarErrorMessage("Server did not respond", context);
        return false;
      }

      if (response['error'] != null) {
        Utils.flushBarErrorMessage(
            response['error'] ?? "Unknown error", context);
        return false;
      }
      return true;
    }on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    }  catch (e) {
      print("Error reserving book: $e");
      Utils.flushBarErrorMessage(
          "Failed to rate the book. Please try again.", context);
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchReservation(String filter, String seed,
      int page, int limit, BuildContext context) async {
    String url =
        '${BookEndPoints.reserveUrl}?status=$filter&seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        print(url);
      }
      dynamic response = await _apiService.getApiResponse(url);
      print('check for null ${response['data']}');
      List<ReservationModel> reservations = (response['data'] as List)
          .map((e) => ReservationModel.fromJson(e))
          .toList();

      final next = response['info']?['next'];
      return {"reservations": reservations, "next": next};
    } on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    } catch (error) {
      return Utils.flushBarErrorMessage(
          "Failed to get Reservation. Please try again. ${error.toString()}",
          context);
    }
  }

  Future<bool> cancelReservation(String uid, BuildContext context) async {
    try {
      print("${BookEndPoints.cancelReservation}/$uid");
      dynamic response = await _apiService
          .getDeleteApiResponse("${BookEndPoints.cancelReservation}/$uid");

      if (response == null) {
        Utils.flushBarErrorMessage("Server did not respond", context);
        return false;
      }

      if (response['error'] != null) {
        Utils.flushBarErrorMessage(
            response['error'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      return Utils.noInternet("No internet connection. Please try again later.");
    } catch (e) {
      print("Error reserving book: $e");
      Utils.flushBarErrorMessage(
          "Failed to cancel reservation. Please try again.", context);
      return false;
    }
  }
}
