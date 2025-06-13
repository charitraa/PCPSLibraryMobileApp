import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/model/my_books_model.dart';
import 'package:library_management_sys/repository/my_books_repository.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../model/book_info_model.dart';
import '../../utils/utils.dart';

class MyBooksViewModel with ChangeNotifier {
  final List<MyBooksModel> _booksList = [];
  final MyBooksRepository _booksRepo = MyBooksRepository();
  ApiResponse<BookInfoModel> booksData = ApiResponse.loading();
  BookInfoModel? get currentBook => booksData.data;
  final Logger _logger = Logger();

  void setBook(ApiResponse<BookInfoModel> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<MyBooksModel> get booksList => _booksList;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetchBooksList(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _booksList.clear();
      final Map<String, dynamic>? response = await _booksRepo.myBooks(context);
      if (response != null && response['booksList'] != null) {
        _booksList.addAll(response['booksList'] as List<MyBooksModel>);
        if (kDebugMode) {
          _logger.d('Books fetched: ${_booksList.length} items');
        }
      } else {
        _logger.w('No books received in response');
        Utils.flushBarErrorMessage('No books received from server', context);
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e('Error fetching books: $error');
      String errorMessage = error.toString().contains('No internet connection')
          ? 'No internet connection. Please try again.'
          : 'Error fetching books: $error';
      Utils.flushBarErrorMessage(errorMessage, context);
    } finally {
      setLoading(false);
    }
  }

  Future<bool> renewBook(String uid, BuildContext context) async {
    if (_isLoading) return false;
    setLoading(true);
    try {
      final bool success = await _booksRepo.renew(uid, context);
      if (success) {
        _logger.d('Book renewed successfully for UID: $uid');
        Utils.flushBarSuccessMessage('Book renewed successfully!', context);
        await fetchBooksList(context);
      } else {
        _logger.w('Failed to renew book for UID: $uid');
        Utils.flushBarErrorMessage('Failed to renew book', context);
      }
      return success;
    } catch (error) {
      _logger.e('Error renewing book: $error');
      String errorMessage = error.toString().contains('No internet connection')
          ? 'No internet connection. Please try again.'
          : 'Error renewing book: $error';
      Utils.flushBarErrorMessage(errorMessage, context);
      return false;
    } finally {
      setLoading(false);
    }
  }
}