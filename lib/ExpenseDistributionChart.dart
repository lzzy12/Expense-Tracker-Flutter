import 'package:flutter/material.dart';
import 'package:personal_expenses_flutter/ExpensePercentBar.dart';
import 'package:personal_expenses_flutter/model/Data.dart';
import 'package:personal_expenses_flutter/utils/utils.dart';

class ExpenseDistributionChart extends StatelessWidget {
  List<Expense> expenses;
  List<DateTime> weekDays;

  ExpenseDistributionChart(List<Expense> data) {
    var today = DateTime.now();
    var weekStart = today.subtract(Duration(days: today.weekday));
    var weekEnd = today.add(Duration(days: 7 - today.weekday));
    // Only interested in this week's data
    for (int i = 0; i < data.length; i++) {
      if (data[i].date.compareTo(weekStart) < 0 ||
          data[i].date.compareTo(weekEnd) > 0) {
        data.removeAt(i);
      }
    }
    data.sort((a, b) => a.date.weekday.compareTo(b.date.weekday));
    expenses = data;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Card(
        elevation: 20,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              ...List.generate(7, (index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                    child: ExpensePercentBar(
                        getExpenseFractionOnWeekday(expenses, index + 1),
                        getExpenseOnWeekday(expenses, index + 1),
                        index + 1));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
