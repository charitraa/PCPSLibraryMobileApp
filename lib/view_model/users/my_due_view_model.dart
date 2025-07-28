import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/model/due_model.dart';
import 'package:library_management_sys/repository/my_books_repository.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../model/book_info_model.dart';

class MyDueViewModel with ChangeNotifier {
  final List<DueModel> _duesList = [];
  final MyBooksRepository _booksRepo = MyBooksRepository();
  ApiResponse<BookInfoModel> duesData = ApiResponse.loading();
  BookInfoModel? get currentDue => duesData.data;
  final Logger _logger = Logger();

  void setDue(ApiResponse<BookInfoModel> response) {
    duesData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<DueModel> get duesList => _duesList;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetchDues(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _duesList.clear();
      final Map<String, dynamic> response = await _booksRepo.getDues(context);
      if (response != null && response['booksList'] != null) {
        _duesList.addAll(response['booksList'] as List<DueModel>);
        if (kDebugMode) {
          _logger.d('Dues fetched: ${_duesList.length} items');
        }
      } else {
        _logger.w('No dues received in response');
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e('Error fetching dues: $error');

    } finally {
      setLoading(false);
    }
  }
}