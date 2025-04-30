import 'package:flutter/material.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/model/due_model.dart';
import 'package:library_management_sys/model/my_books_model.dart';
import 'package:library_management_sys/repository/my_books_repository.dart';
import '../../data/response/api_response.dart';
import '../../model/book_info_model.dart';
import '../../utils/utils.dart';

class MyDueViewModel with ChangeNotifier {
  final List<DueModel> _booksList = [];
  final MyBooksRepository _booksRepo = MyBooksRepository();
  ApiResponse<BookInfoModel> booksData = ApiResponse.loading();
  BookInfoModel? get currentUser => booksData.data;
  void setUser(ApiResponse<BookInfoModel> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<DueModel> get booksList => _booksList;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetchBooksList(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _booksList.clear();
      final Map<String, dynamic> response = await _booksRepo.getDues(context);
      print(response['booksList']);
      _booksList.addAll(response['booksList']);
      Future.microtask(() => notifyListeners());
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching books: $error", context);
    } finally {
      setLoading(false);
    }
  }
}
