import 'package:flutter/material.dart';
import 'package:library_management_sys/model/genre_model.dart';
import '../../data/response/api_response.dart';
import '../../repository/attributes_repository.dart';
import '../../utils/utils.dart';

class AttrGenreViewModel with ChangeNotifier {
  final List<Genre> _genreList = [];
  final AttributesRepository _booksRepo = AttributesRepository();
  ApiResponse<Genre> booksData = ApiResponse.loading();
  Genre? get currentUser => booksData.data;
  void setUser(ApiResponse<Genre> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';

  int _currentPage = 1;
  int _limit = 10;


  bool get isLoading => _isLoading;
  List<Genre> get GenresList => _genreList;
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
      fetchGenresList(context);
      notifyListeners();
    }
  }


  Future<void> fetchGenresList(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage=1;
      _genreList.clear();
      final Map<String,dynamic> response =
      await _booksRepo.fetchGenre(_filter,1,_limit,context);
      _genreList.addAll(response['Genre']);
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

  Future<void> loadMoreGenres(BuildContext context) async {
    try {
      final Map<String,dynamic> response =
      await _booksRepo.fetchGenre(_filter,_currentPage,_limit,context);
      if(_currentPage!=null){
        print("${response['next']}=$_currentPage");
        _genreList.addAll(response['Genre']);
        _currentPage++;
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(
          "Error fetching Genres: $error", context);
    }
  }




}
