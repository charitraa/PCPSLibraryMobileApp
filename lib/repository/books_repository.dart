import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/book_endpoints.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/utils/utils.dart';

class BooksRepository {
  final BaseApiServices _apiService = NetworkApiService();

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
      if (kDebugMode) {
        print(url);
      }
      dynamic response = await _apiService.getApiResponse(url);
      List<BooksModel> booksList = [];
      if (response['data'] != null && response['data'] is List) {
        booksList = (response['data'] as List)
            .map((e) => BooksModel.fromJson(e))
            .toList();
      }
      final next = response['info']?['next'];

      return {"booksList": booksList, "next": next};
    } catch (error) {
      return Utils.flushBarErrorMessage(error.toString(), context);
    }
  }
}
