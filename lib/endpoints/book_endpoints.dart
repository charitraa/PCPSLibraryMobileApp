import 'package:library_management_sys/constant/base_url.dart';

class BookEndPoints {
  static var onlineBooks = "${BaseUrl.baseUrl}/online-books";
  static var bookUrl = "${BaseUrl.baseUrl}/books";

  static var reserveUrl = "${BaseUrl.baseUrl}/circulation/reservations";
  static var renewalUrl = "${BaseUrl.baseUrl}/circulation/renewals";
  static var rateUrl = "${BaseUrl.baseUrl}/ratings";
  static var cancelReservation = "${BaseUrl.baseUrl}/circulation/reservations";

  // my books
  static var myBooks = "${BaseUrl.baseUrl}/me/book-status";
  static var pay = "${BaseUrl.baseUrl}/me/payments";
  static var due = "${BaseUrl.baseUrl}/me/dues";
}
