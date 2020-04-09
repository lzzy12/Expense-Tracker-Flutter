import 'package:intl/intl.dart';
import '../model/Data.dart';

String getFormattedDate(DateTime date) {
  var format = DateFormat('d, MMMM, EEEE');
  return format.format(date);
}

String getWeekDayName(DateTime date) {
  return DateFormat.E('en_US').format(date)[0];
}

double getTotalExpense(List<Expense> data) {
  var sum = 0.0;
  for (var i in data) {
    sum += i.amount;
  }
  return sum;
}

double getExpenseOnWeekday(List<Expense> data, int weekday) {
  var t = 0.0;
  for (var i in data) {
    if (i.date.weekday == weekday) {
      t += i.amount;
    }
  }
  return t;
}

double getExpenseFractionOnWeekday(List<Expense> data, int weekday) {
  var total = getTotalExpense(data);
  if (total == 0) return 0;
  return getExpenseOnWeekday(data, weekday) / getTotalExpense(data);
}

String getWeekDayNameFromNumber(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      throw Exception('Invalid weeknumber');
  }
}
