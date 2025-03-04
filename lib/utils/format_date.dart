import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString); // Parse the ISO 8601 string
  return DateFormat('yyyy-MM-dd')
      .format(dateTime); // Format it to show only the date
}
