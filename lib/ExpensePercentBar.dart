import 'package:flutter/material.dart';
import './utils/utils.dart';

class ExpensePercentBar extends StatelessWidget {
  final double expensePercent;
  final double expense;
  final int weekday;

  ExpensePercentBar(this.expensePercent, this.expense, this.weekday);

  static const height = 50.0;
  static const width = 10.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(expense.toInt().toString()),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
        ),
        Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              color: Colors.grey,
            ),
            Container(
              color: Colors.blue,
              width: width,
              height: expensePercent * height,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
        ),
        Text(getWeekDayNameFromNumber(weekday)[0])
      ],
    );
  }
}
