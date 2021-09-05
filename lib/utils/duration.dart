import 'package:intl/intl.dart';

String formatDuration(Duration duration) {
  var format = DateFormat("HH:mm:ss");
  var date = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  date = date.add(duration);
  return format.format(date);
}

String formatDateTime(DateTime dateTime) {
  var format = DateFormat("yyyy-MMM-dd HH:mm:ss");
  return format.format(dateTime);
}