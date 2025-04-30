import 'package:flutter/material.dart';
import 'package:library_management_sys/model/my_payment.dart';
import 'package:library_management_sys/repository/books_repository.dart';
import 'package:library_management_sys/repository/my_books_repository.dart';
import '../../data/response/api_response.dart';
import '../../model/reservation_model.dart';
import '../../utils/utils.dart';

class PaymentViewModel with ChangeNotifier {
  final List<PaymentModel> _reservationList = [];
  final MyBooksRepository _booksRepo = MyBooksRepository();
  ApiResponse<ReservationModel> booksData = ApiResponse.loading();
  ReservationModel? get currentUser => booksData.data;
  void setUser(ApiResponse<ReservationModel> response) {
    booksData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _status = 'Pending';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<PaymentModel> get reservationList => _reservationList;

  int get currentPage => _currentPage;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetchReservation(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage = 1;
      _reservationList.clear();
      final Map<String, dynamic> response = await _booksRepo.getPayment(
           1, _limit, context);
      _reservationList.addAll(response['reservations']);
      if (response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching books: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    try {
      final Map<String, dynamic> response = await _booksRepo.getPayment(
         _currentPage, _limit, context);
      _reservationList.addAll(response['reservations']);
      if (_currentPage != null) {
        _reservationList.addAll(response['reservations']);
        _currentPage++;
      }

      Future.microtask(() => notifyListeners());
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching reservation: $error", context);
    }
  }

}
