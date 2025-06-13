import 'package:flutter/material.dart';
import 'package:library_management_sys/model/Publisher_model.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../repository/attributes_repository.dart';
import '../../utils/utils.dart';

class AttrPublisherViewModel with ChangeNotifier {
  final List<Publisher> _publisherList = [];
  final AttributesRepository _booksRepo = AttributesRepository();
  ApiResponse<Publisher> booksData = ApiResponse.loading();
  Publisher? get currentUser => booksData.data;
  final Logger _logger = Logger();

  void setUser(ApiResponse<Publisher> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<Publisher> get publishersList => _publisherList;
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
      fetchPublishersList(context);
      notifyListeners();
    }
  }

  Future<void> fetchPublishersList(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage = 1;
      _publisherList.clear();
      final Map<String, dynamic>? response =
      await _booksRepo.fetchPublisher(_filter, 1, _limit, context);

      if (response != null && response['publisher'] != null) {
        _publisherList.addAll(response['publisher'] as List<Publisher>);
      } else {
        _logger.w("No publishers received in response");
        Utils.flushBarErrorMessage("No publishers received from server", context);
      }
      if (response != null && response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e("Error fetching publishers: $error");
      Utils.flushBarErrorMessage("Error fetching publishers: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMorePublishers(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic>? response =
      await _booksRepo.fetchPublisher(_filter, _currentPage, _limit, context);

      if (response != null && response['publisher'] != null) {
        _publisherList.addAll(response['publisher'] as List<Publisher>);
        if (response['next'] != null) {
          _currentPage++;
        }
      } else {
        _logger.w("No additional publishers received for page $_currentPage");
        Utils.flushBarErrorMessage("No publishers received from server", context);
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e("Error fetching more publishers: $error");
      Utils.flushBarErrorMessage("Error fetching publishers: $error", context);
    } finally {
      setLoading(false);
    }
  }
}