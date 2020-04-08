import 'package:flutter/material.dart';
import 'package:personal_expenses_flutter/utils/utils.dart';
import './model/Data.dart';
import 'package:uuid/uuid.dart';

class BottomAddExpensesDialogue extends StatefulWidget {
  final Expense expense;

  BottomAddExpensesDialogue() : expense = null;

  BottomAddExpensesDialogue.edit(this.expense);

  @override
  State<StatefulWidget> createState() {
    return _BottomAddExpensesDialogueState(expense);
  }
}

class _BottomAddExpensesDialogueState extends State<BottomAddExpensesDialogue> {
  TextEditingController _expenseNameController;
  TextEditingController _amountController;
  DateTime selectedDate;
  var _validateName = false;
  var _validateAmount = false;
  Expense expense;

  _BottomAddExpensesDialogueState(this.expense);

  @override
  void initState() {
    super.initState();
    _expenseNameController =
        TextEditingController(text: expense != null ? expense.expenseName : '');
    _amountController = TextEditingController(
        text: expense != null ? expense.amount.toString() : '');
    selectedDate = expense != null ? expense.date : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(16),
      width: size.width,
      height: size.height / 1.5,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Expense on',
                errorText:
                    _validateName ? 'This field must not be empty' : null,
              ),
              controller: _expenseNameController,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Amount',
                errorText:
                    _validateAmount ? 'This field must not be empty' : null,
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  width: size.width,
                  child: Text(
                    getFormattedDate(selectedDate),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      var today = DateTime.now();
                      var weekStart =
                          today.subtract(Duration(days: today.weekday));
                      var weekEnd = today.add(
                          Duration(days: DateTime.daysPerWeek - today.weekday));
                      showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: weekStart,
                              lastDate: weekEnd)
                          .then((DateTime date) {
                        setState(() {
                          if (date != null) selectedDate = date;
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: RaisedButton(
              color: Colors.blue,
              child: Text(
                expense != null ? 'Save' : 'Add Expense',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_expenseNameController.text.isEmpty ||
                    _amountController.text.isEmpty) {
                  setState(() {
                    _validateName = _expenseNameController.text.isEmpty;
                    _validateAmount = _amountController.text.isEmpty;
                  });
                  return;
                }
                Navigator.pop(
                    context,
                    Expense(
                      expense != null ? expense.id : Uuid().v4(),
                      _expenseNameController.text,
                      double.parse(_amountController.text),
                      selectedDate,
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
