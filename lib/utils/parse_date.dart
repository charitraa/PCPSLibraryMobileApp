import 'package:intl/intl.dart';

String parseDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString); // Parse the ISO 8601 string
  return DateFormat('MMMM d, yyyy').format(dateTime); // Format to "June 5, 2019"
}
