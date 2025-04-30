import 'package:library_management_sys/constant/base_url.dart';

class BookEndPoints{
  static var bookUrl="${BaseUrl.baseUrl}/books";
  static var reserveUrl="${BaseUrl.baseUrl}/bookflow/reservations";
  static var renewalUrl="${BaseUrl.baseUrl}/bookflow/renewals";
  static var rateUrl="${BaseUrl.baseUrl}/ratings";
  static var cancelReservation="${BaseUrl.baseUrl}/bookflow/reservations/cancel";

  // my books
  static var myBooks="${BaseUrl.baseUrl}/me/book-status";
  static var pay="${BaseUrl.baseUrl}/me/payments";
  static var due="${BaseUrl.baseUrl}/me/dues";
}
