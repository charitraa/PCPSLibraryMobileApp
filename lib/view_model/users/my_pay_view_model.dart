import 'package:flutter/material.dart';
import 'package:library_management_sys/model/my_payment.dart';
import 'package:library_management_sys/repository/my_books_repository.dart';
import 'package:logger/logger.dart';
import '../../data/response/api_response.dart';
import '../../model/reservation_model.dart';
import '../../utils/utils.dart';

class PaymentViewModel with ChangeNotifier {
  final List<PaymentModel> _paymentList = [];
  final MyBooksRepository _booksRepo = MyBooksRepository();
  ApiResponse<ReservationModel> paymentData = ApiResponse.loading();
  ReservationModel? get currentPayment => paymentData.data;
  final Logger _logger = Logger();

  void setPayment(ApiResponse<ReservationModel> response) {
    paymentData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _status = 'Pending';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<PaymentModel> get paymentList => _paymentList;
  String get status => _status;
  int get currentPage => _currentPage;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  void setStatus(String value, BuildContext context) {
    if (_status != value) {
      _status = value;
      fetchPayment(context);
      notifyListeners();
    }
  }

  Future<void> fetchPayment(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage = 1;
      _paymentList.clear();
      final Map<String, dynamic>? response =
      await _booksRepo.getPayment(1, _limit, context);
      if (response != null && response['reservations'] != null) {
        _paymentList.addAll(response['reservations'] as List<PaymentModel>);
      } else {
        _logger.w('No payments received in response');
      }
      if (response != null && response['next'] != null) {
        _currentPage++;
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e('Error fetching payments: $error');

    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMorePayments(BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      final Map<String, dynamic> response =
      await _booksRepo.getPayment(_currentPage, _limit, context);
      if (response != null && response['reservations'] != null) {
        _paymentList.addAll(response['reservations'] as List<PaymentModel>);
        if (response['next'] != null) {
          _currentPage++;
        }
      } else {
        _logger.w('No additional payments received for page $_currentPage');
        Utils.flushBarErrorMessage('No payments received from server', context);
      }
      Future.microtask(() => notifyListeners());
    } catch (error) {
      _logger.e('Error fetching more payments: $error');

    } finally {
      setLoading(false);
    }
  }
}