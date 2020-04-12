import 'package:flutter/material.dart';
import 'package:personal_expenses_flutter/AddExpensesDialog.dart';
import 'package:personal_expenses_flutter/ExpenseList.dart';
import 'package:personal_expenses_flutter/NothingAddedWidget.dart';
import 'package:personal_expenses_flutter/model/Data.dart';
import 'package:personal_expenses_flutter/model/sqlite-database.dart';
import 'package:personal_expenses_flutter/utils/utils.dart';
import 'ExpenseDistributionChart.dart';
import 'SplashScreen.dart';

void main() => runApp(PersonalExpenseStateless());

class PersonalExpenseStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker App',
      debugShowCheckedModeBanner: false,
      home: PersonalExpensesApp(),
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.blue),
    );
  }
}

class PersonalExpensesApp extends StatefulWidget {
  @override
  _PersonalExpensesAppState createState() => _PersonalExpensesAppState();
}

class _PersonalExpensesAppState extends State<PersonalExpensesApp> {
  List<Expense> data = [];

  @override
  Widget build(BuildContext context) {
    var db = SingletonDatabase();
    return FutureBuilder<List<Expense>>(
      future: db.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          if (snapshot.hasError)
            return Scaffold(
                body: Text('Pff... Database Error: ${snapshot.error}'));
          this.data = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Personal Expenses App'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addButtonClicked(context);
                  },
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ExpenseDistributionChart(data),
                  ),
                  data.isEmpty
                      ? NothingAddedWidget()
                      : ExpenseList(
                          data, _deleteElement, _editListElement, _addElement),
                ],
              ),
            ),
            floatingActionButton: Container(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  _addButtonClicked(context);
                },
              ),
            ),
          );
        }
      },
    );
  }

  void _editListElement(int index, Expense newData) {
    setState(() {
      data[index] = newData;
    });
    var db = SingletonDatabase();
    db.insert(newData);
  }

  void _deleteElement(int index) {
    var db = SingletonDatabase();
    db.delete(data[index]);
    setState(() {
      data.removeAt(index);
    });
  }

  void _addElement(Expense e) {
    setState(() {
      data.add(e);
    });
    var db = SingletonDatabase();
    db.insert(e);
  }

  void _addButtonClicked(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(child: BottomAddExpensesDialogue());
        }).then((data) {
      if (data != null) {
        var _data = data as Expense;
        setState(() {
          _addElement(_data);
        });
        print(
            '${_data.expenseName}: ${_data.amount} on ${getFormattedDate(_data.date)}');
      }
    });
  }
}
