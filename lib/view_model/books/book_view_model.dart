import 'package:flutter/material.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/repository/books_repository.dart';
import '../../data/response/api_response.dart';
import '../../utils/utils.dart';

class BooksViewModel with ChangeNotifier {
  final List<BooksModel> _booksList = [];
  final BooksRepository _booksRepo = BooksRepository();
  ApiResponse<BooksModel> booksData = ApiResponse.loading();
  BooksModel? get currentUser => booksData.data;
  void setUser(ApiResponse<BooksModel> response) {
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
      resetBookList(context);
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
      resetBookList(context);
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
      resetBookList(context);
      notifyListeners();
    }
  }
  Future<void> resetBookList(BuildContext context) async {
    _booksList.clear();
    _currentPage = 1;
    _filter = '';
    _bookGenre = '';
    _publisher = '';
    _bookAuthor = '';
    _searchValue = '';
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
      _currentPage=1;
      _booksList.clear();
      final Map<String,dynamic> response =
      await _booksRepo.fetchBooks(_filter,_bookAuthor,_publisher,_bookGenre,1,_limit,context);
      _booksList.addAll(response['booksList']);
      if(response['next']!=null){
        _currentPage++;
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error fetching books: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    try {
      final Map<String,dynamic> response =
      await _booksRepo.fetchBooks(_filter,_bookAuthor,_publisher,_bookGenre,_currentPage,_limit,context);
      if(_currentPage!=null){
        print("${response['next']}=$_currentPage");
        _booksList.addAll(response['booksList']);
        _currentPage++;
      }

      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error fetching books: $error", context);
    }
  }



 
}
