import 'package:flutter/material.dart';
import 'package:library_management_sys/endpoints/book_endpoints.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/repository/books_repository.dart';
import '../../data/response/api_response.dart';
import '../../model/book_info_model.dart';
import '../../utils/utils.dart';

class ReservationViewModel with ChangeNotifier {
  final List<BooksModel> _reservationList = [];
  final BooksRepository _booksRepo = BooksRepository();
  ApiResponse<BookInfoModel> booksData = ApiResponse.loading();
  BookInfoModel? get currentUser => booksData.data;
  void setUser(ApiResponse<BookInfoModel> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';

  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<BooksModel> get reservationList => _reservationList;
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
      fetchReservation(context);
      notifyListeners();
    }
  }


  Future<void> fetchReservation(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage = 1;
      _reservationList.clear();
      final Map<String, dynamic> response = await _booksRepo.fetchReservation(
          _filter, 1, _limit, context);
      _reservationList.addAll(response['reservations']);
      if (response['next'] != null) {
        _currentPage++;
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching books: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    try {
      final Map<String, dynamic> response = await _booksRepo.fetchReservation(
          _filter, _currentPage, _limit, context);
      _reservationList.addAll(response['reservations']);
      if (_currentPage != null) {
        _reservationList.addAll(response['reservations']);
        _currentPage++;
      }

      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching reservation: $error", context);
    }
  }

  Future<bool> deleteComment(String uid,BuildContext context) async {
    try {
      final user = await _booksRepo.cancelReservation(uid, context);
      if(user){
        Utils.flushBarSuccessMessage('You have cancelled the reservation!!', context);
      }
      return user;
    } catch (e) {
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }
}
