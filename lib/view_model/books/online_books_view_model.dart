import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/repository/books_repository.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../model/book_info_model.dart';
import '../../utils/utils.dart';

class OnlineBooksViewModel with ChangeNotifier {
  final List<OnlineBooks> _booksList = [];
  final BooksRepository _booksRepo = BooksRepository();
  var logger = Logger();
  bool _isLoading = false;
  int _currentPage = 1;
  String _filter = '';

  int _limit = 10;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }
  String get filter => _filter;
  List<OnlineBooks> get booksList => _booksList;

  String _searchValue = '';
  String get searchValue => _searchValue;

  void setFilter(String value, BuildContext context) {
    if (_filter != value) {
      _filter = value;
      _searchValue = value;
      fetchBooksList(context);
      notifyListeners();
    }
  }
  Future<void> resetBookList(BuildContext context) async {
    _booksList.clear();
    _currentPage = 1;
    _filter = '';
    _searchValue='';
    _limit = 10;
    await fetchBooksList(context);
    notifyListeners();
  }

  Future<void> fetchBooksList(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage = 1;
      _booksList.clear();
      final Map<String, dynamic> response =
          await _booksRepo.fetchOnlineBooks(_searchValue, 1, _limit, context);

      if (response != null && response['booksList'] != null) {
        _booksList.addAll(response['booksList'] as List<OnlineBooks>);
      }
      if (response != null && response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      logger.e("Error fetching books: $error");
      Utils.flushBarErrorMessage("Error fetching books: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic> response = await _booksRepo.fetchOnlineBooks(
          _searchValue, _currentPage, _limit, context);

      if (response != null && response['booksList'] != null) {
        _booksList.addAll(response['booksList'] as List<OnlineBooks>);
        if (response['next'] != null) {
          _currentPage++;
        }
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      logger.e("Error fetching more books: $error");
      Utils.flushBarErrorMessage("Error fetching more books: $error", context);
    } finally {
      setLoading(false);
    }
  }
}
