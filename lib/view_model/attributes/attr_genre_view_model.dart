import 'package:flutter/material.dart';
import 'package:library_management_sys/model/genre_model.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../repository/attributes_repository.dart';
import '../../utils/utils.dart';

class AttrGenreViewModel with ChangeNotifier {
  final List<Genre> _genreList = [];
  final AttributesRepository _booksRepo = AttributesRepository();
  ApiResponse<Genre> booksData = ApiResponse.loading();
  Genre? get currentUser => booksData.data;
  final Logger _logger = Logger();

  void setUser(ApiResponse<Genre> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<Genre> get genresList => _genreList; // Fixed naming to camelCase
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
      _currentPage = 1;
      _genreList.clear();
      final Map<String, dynamic>? response =
      await _booksRepo.fetchGenre(_filter, 1, _limit, context);

      if (response != null && response['Genre'] != null) {
        _genreList.addAll(response['Genre'] as List<Genre>);
      } else {
        _logger.w("No genres received in response");
        Utils.flushBarErrorMessage("No genres received from server", context);
      }
      if (response != null && response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e("Error fetching genres: $error");
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreGenres(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic>? response =
      await _booksRepo.fetchGenre(_filter, _currentPage, _limit, context);

      if (response != null && response['Genre'] != null) {
        _genreList.addAll(response['Genre'] as List<Genre>);
        if (response['next'] != null) {
          _currentPage++;
        }
      } else {
        _logger.w("No additional genres received for page $_currentPage");
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e("Error fetching more genres: $error");
    } finally {
      setLoading(false);
    }
  }
}