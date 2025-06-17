import 'package:flutter/material.dart';
import 'package:library_management_sys/model/book_request_model.dart';
import 'package:library_management_sys/repository/books_request_repository.dart';
import '../../data/response/api_response.dart';
import '../../utils/utils.dart';
import 'package:logger/logger.dart';

class BookRequestViewModel with ChangeNotifier {
  final List<BookRequestModel> _requestList = [];
  final BooksRequestRepository _requestsRepo = BooksRequestRepository();
  final Logger _logger = Logger();
  ApiResponse<BookRequestModel> requestsData = ApiResponse.loading();
  BookRequestModel? get currentUser => requestsData.data;

  void setUser(ApiResponse<BookRequestModel> response) {
    _logger.d('Setting user data in view model');
    requestsData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<BookRequestModel> get requestsList => _requestList;
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
      notifyListeners();
    }
  }

  Future<void> fetchRequests(BuildContext context) async {
    if (_isLoading) {
      return;
    }
    setLoading(true);
    try {
      _currentPage = 1;
      _requestList.clear();
      final Map<String, dynamic> response =
          await _requestsRepo.fetchBooksRequest(_filter, 1, _limit, context);

      _requestList.addAll(response['requests']);
      if (response['next'] != null) {
        _currentPage++;
        _logger.d('Next page available: $_currentPage');
      }
      _logger.i('Fetched ${_requestList.length} book requests successfully');
      notifyListeners();
    } catch (error) {
      _logger.e('Error fetching requests: $error');
      Utils.flushBarErrorMessage("Error fetching requests: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMore(BuildContext context) async {
    try {
      _logger.i(
          'Loading more requests: page=$_currentPage, limit=$_limit, filter=$_filter');
      final Map<String, dynamic> response = await _requestsRepo
          .fetchBooksRequest(_filter, _currentPage, _limit, context);
      if (response['next'] != null) {
        _logger.d('Next page available: ${response['next']}');
        _requestList.addAll(response['requests']);
        _currentPage++;
      }
      _logger.i('Loaded ${_requestList.length} total requests');
      notifyListeners();
    } catch (error) {
      _logger.e('Error loading more requests: $error');
      Utils.flushBarErrorMessage("Error fetching requests: $error", context);
    }
  }

  Future<bool> postRequests(dynamic body, BuildContext context) async {
    try {
      _logger.i('Posting new book request');
      final user = await _requestsRepo.postRequests(body, context);
      if (user) {
        _logger.i('Book request posted successfully');
        Utils.flushBarSuccessMessage(
            'You have successfully requested!!', context);
        await fetchRequests(context); // 👈 Add this line
        return true;
      }
      return user;
    } catch (e) {
      _logger.e('Error posting request: $e');
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }

  Future<bool> delete(String uid, BuildContext context) async {
    try {
      _logger.i('Deleting book request: UID=$uid');
      final user = await _requestsRepo.delete(uid, context);
      if (user) {
        _logger.i('Book request deleted successfully');
        Utils.flushBarSuccessMessage(
            'You have deleted on this request!!', context);
        await fetchRequests(context);
      }

      return user;
    } catch (e) {
      _logger.e('Error deleting request: $e');
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }

  Future<bool> update(String uid, dynamic body, BuildContext context) async {
    try {
      _logger.i('Updating book request: UID=$uid');
      final user = await _requestsRepo.update(uid, body, context);
      if (user) {
        _logger.i('Book request updated successfully');
        Utils.flushBarSuccessMessage(
            'You have updated your request!!', context);
      }
      return user;
    } catch (e) {
      _logger.e('Error updating request: $e');
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }
}
