import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:personal_expenses_flutter/AddExpensesDialog.dart';
import './model/Data.dart';
import './utils/utils.dart';
import 'package:uuid/uuid.dart';

enum Confirm { yes, no }

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(int) onDeleteButtonClicked;
  final void Function(int, Expense) onEditButtonClicked;
  final void Function(Expense) onUndoEvent;
  Expense removed;

  ExpenseList(this.expenses, this.onDeleteButtonClicked,
      this.onEditButtonClicked, this.onUndoEvent);

  void _onEditButtonClicked(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomAddExpensesDialogue.edit(expenses[index]);
        }).then((newData) {
      if (newData != null) onEditButtonClicked(index, newData);
    });
  }

  void _onDeleteButtonClicked(context, index) {
    Widget confirmButton = FlatButton(
      child: Text('Yes'),
      onPressed: () => Navigator.pop(context, Confirm.yes),
    );

    Widget cancelButton = FlatButton(
      child: Text('No'),
      onPressed: () => Navigator.pop(context, Confirm.no),
    );

    var alert = AlertDialog(
      elevation: 12.0,
      title: Text('Are you sure you want to delete the entry?'),
      content: Text('${expenses[index].expenseName} will be deleted!'),
      actions: <Widget>[confirmButton, cancelButton],
    );
    showDialog(context: context, child: alert).then((response) {
      if (response != null && response == Confirm.yes)
        onDeleteButtonClicked(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 10.0,
              child: Dismissible(
                background: Container(
                  color: Theme.of(context).primaryColor,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.delete,
                          size: 50,
                          color: Colors.white,
                        ),
                      )),
                ),
                key: Key(Uuid().v4()),
                onDismissed: (direction) {
                  removed = expenses[index];
                  onDeleteButtonClicked(index);
                  Flushbar flush;
                  flush = Flushbar<bool>(
                    message: 'An item has been removed!',
                    duration: Duration(seconds: 5),
                    flushbarStyle: FlushbarStyle.FLOATING,
                    backgroundGradient:
                        LinearGradient(colors: [Colors.blue, Colors.teal]),
                    mainButton: FlatButton(
                      child: Text(
                        'Undo',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        onUndoEvent(Expense.from(removed));
                        flush.dismiss(true);
                      },
                    ),
                  )..show(context).then((value) {
                      removed = null;
                    });
                },
                child: ListTile(
                  leading: ClipOval(
                    child: Material(
                      color: Theme
                          .of(context)
                          .primaryColor, // button color
                      child: InkWell(
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(
                              child: Text(
                                '${expenses[index].amount}',
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ),
                    ),
                  ),
                  title: Text(expenses[index].expenseName),
                  subtitle: Text(
                    getFormattedDate(expenses[index].date),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          key: Key('$index'),
                          icon: Icon(Icons.edit),
                          onPressed: () => _onEditButtonClicked(context, index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _onDeleteButtonClicked(context, index),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
