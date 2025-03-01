import 'package:flutter/material.dart';
import 'package:library_management_sys/model/author_model.dart';
import '../../data/response/api_response.dart';
import '../../repository/attributes_repository.dart';
import '../../utils/utils.dart';

class AttrAuthorViewModel with ChangeNotifier {
  final List<Author> _authorList = [];
  final AttributesRepository _booksRepo = AttributesRepository();
  ApiResponse<Author> booksData = ApiResponse.loading();
  Author? get currentUser => booksData.data;
  void setUser(ApiResponse<Author> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';

  int _currentPage = 1;
  int _limit = 10;


  bool get isLoading => _isLoading;
  List<Author> get authorsList => _authorList;
  String get filter => _filter;

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
      fetchAuthorsList(context);
      notifyListeners();
    }
  }
 
  
  Future<void> fetchAuthorsList(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage=1;
      _authorList.clear();
      final Map<String,dynamic> response =
      await _booksRepo.fetchAuthor(_filter,1,_limit,context);
      _authorList.addAll(response['author']);
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

  Future<void> loadMoreAuthors(BuildContext context) async {
    try {
      final Map<String,dynamic> response =
      await _booksRepo.fetchAuthor(_filter,_currentPage,_limit,context);
      if(_currentPage!=null){
        print("${response['next']}=$_currentPage");
        _authorList.addAll(response['author']);
        _currentPage++;
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error fetching authors: $error", context);
    }
  }




}
