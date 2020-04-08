import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  var format = DateFormat('d, MMMM, EEEE');
  return format.format(date);
}
