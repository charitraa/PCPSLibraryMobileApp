import 'package:flutter/material.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/repository/books_repository.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../model/book_info_model.dart';
import '../../utils/utils.dart';

class RecommendedViewModel with ChangeNotifier {
  final List<BooksModel> _booksList = [];
  final List<BooksModel> _frontList = [];
  final BooksRepository _booksRepo = BooksRepository();
  ApiResponse<BookInfoModel> booksData = ApiResponse.loading();
  BookInfoModel? get currentUser => booksData.data;
  final logger = Logger();

  void setUser(ApiResponse<BookInfoModel> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';
  String _bookGenre = '';
  String _bookAuthor = '';
  String _publisher = '';

  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<BooksModel> get booksList => _booksList;
  List<BooksModel> get frontList => _frontList;
  String get filter => _filter;
  String get bookGenre => _bookGenre;
  String get bookAuthor => _bookAuthor;
  String get publisher => _publisher;

  int get currentPage => _currentPage;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  String _searchValue = '';
  String get searchValue => _searchValue;

  void setFilter(String value, BuildContext context) {
    if (_filter != value) {
      _filter = value;
      _searchValue = value;
      _bookGenre = '';
      _publisher = '';
      _bookAuthor = '';
      fetchBooksList(context);
      notifyListeners();
    }
  }

  void setBookGenreGrp(String value, BuildContext context) {
    if (_bookGenre != value) {
      _filter = '';
      _searchValue = '';
      _bookGenre = value;
      _publisher = '';
      _bookAuthor = '';
      fetchBooksList(context);
      notifyListeners();
    }
  }

  void setBookAuthor(String value, BuildContext context) {
    if (_bookAuthor != value) {
      _filter = '';
      _searchValue = '';
      _bookGenre = '';
      _publisher = '';
      _bookAuthor = value;
      fetchBooksList(context);
      notifyListeners();
    }
  }

  void setPublisher(String value, BuildContext context) {
    if (_publisher != value) {
      _filter = '';
      _searchValue = '';
      _bookGenre = '';
      _publisher = value;
      _bookAuthor = '';
      fetchBooksList(context);
      notifyListeners();
    }
  }

  Future<void> resetBookList(BuildContext context) async {
    _booksList.clear();
    _currentPage = 1;
    _filter = '';
    _publisher = '';
    _bookGenre = '';
    _bookAuthor = '';
    _limit = 10;
    await fetchBooksList(context);
    notifyListeners();
  }

  Future<void> refresh(BuildContext context) async {
    _booksList.clear();
    _filter = '';
    _searchValue = '';
    _bookGenre = '';
    _publisher = '';
    _bookAuthor = '';
    _currentPage = 1;
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
      _frontList.clear();
      final Map<String, dynamic>? response = await _booksRepo.recommended(
          _filter, _bookAuthor, _publisher, _bookGenre, 1, _limit, context);

      if (response != null && response['booksList'] != null) {
        _booksList.addAll(response['booksList'] as List<BooksModel>);
        _frontList.addAll(response['booksList'] as List<BooksModel>);
      } else {
        logger.w("No books received in response");
      }
      if (response != null && response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      logger.e("Error fetching recommended books: $error");
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic>? response = await _booksRepo.recommended(
          _filter, _bookAuthor, _publisher, _bookGenre, _currentPage, _limit, context);

      if (response != null && response['booksList'] != null) {
        _booksList.addAll(response['booksList'] as List<BooksModel>);
        if (response['next'] != null) {
          _currentPage++;
        }
      } else {
        logger.w("No additional books received for page $_currentPage");
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      logger.e("Error fetching more recommended books: $error");
    } finally {
      setLoading(false);
    }
  }
}