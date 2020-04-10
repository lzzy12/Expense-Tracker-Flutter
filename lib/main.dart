import 'package:flutter/material.dart';
import 'package:personal_expenses_flutter/AddExpensesDialog.dart';
import 'package:personal_expenses_flutter/ExpenseList.dart';
import 'package:personal_expenses_flutter/model/Data.dart';
import 'package:personal_expenses_flutter/utils/utils.dart';
import 'ExpenseDistributionChart.dart';

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

  var _ex = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                ? Center(child: Center(child: Text('Nothing Here')))
                : ExpenseList(
                    data, _deleteElement, _editListElement, _addElement),
          ],
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _addButtonClicked(context);
          },
        ),
      ),
    );
  }

  void _editListElement(int index, Expense newData) {
    setState(() {
      data[index] = newData;
    });
  }

  void _deleteElement(int index) {
    setState(() {
      data.removeAt(index);
    });
  }

  void _addElement(Expense e) {
    setState(() {
      data.add(e);
    });
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
          this.data.add(_data);
        });
        print(
            '${_data.expenseName}: ${_data.amount} on ${getFormattedDate(_data.date)}');
      }
    });
  }
}
