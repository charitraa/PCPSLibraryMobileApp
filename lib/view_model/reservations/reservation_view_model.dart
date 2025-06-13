import 'package:flutter/material.dart';
import 'package:library_management_sys/endpoints/book_endpoints.dart';
import 'package:library_management_sys/repository/books_repository.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../model/reservation_model.dart';
import '../../utils/utils.dart';

class ReservationViewModel with ChangeNotifier {
  final List<ReservationModel> _reservationList = [];
  final BooksRepository _booksRepo = BooksRepository();
  ApiResponse<ReservationModel> booksData = ApiResponse.loading();
  ReservationModel? get currentUser => booksData.data;
  final logger = Logger();

  void setUser(ApiResponse<ReservationModel> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';
  String _status = 'Pending';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<ReservationModel> get reservationList => _reservationList;
  String get filter => _filter;
  String get status => _status; // Fixed: Corrected getter to return _status

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

  void setStatus(String value, BuildContext context) {
    if (_status != value) {
      _status = value;
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
          _status, _filter, 1, _limit, context);

      if (response != null && response['reservations'] != null) {
        _reservationList.addAll(response['reservations'] as List<ReservationModel>);
      } else {
        logger.w("No reservations received in response");
      }
      if (response != null && response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      logger.e("Error fetching reservations: $error");
      Utils.flushBarErrorMessage("Error fetching reservations: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic>? response = await _booksRepo.fetchReservation(
          _status, _filter, _currentPage, _limit, context);

      if (response != null && response['reservations'] != null) {
        _reservationList.addAll(response['reservations'] as List<ReservationModel>);
        if (response['next'] != null) {
          _currentPage++;
        }
      } else {
        logger.w("No additional reservations received for page $_currentPage");
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      logger.e("Error fetching more reservations: $error");
      Utils.flushBarErrorMessage("Error fetching reservations: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<bool> cancel(String uid, BuildContext context) async {
    try {
      final bool success = await _booksRepo.cancelReservation(uid, context);
      if (success) {
        Utils.flushBarSuccessMessage('You have cancelled the reservation!!', context);
      }
      Future.microtask(() => notifyListeners());
      return success;
    } catch (e) {
      logger.e("Error canceling reservation: $e");
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }
}