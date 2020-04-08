class Expense {
  String id;
  String expenseName;
  double amount;
  DateTime date;

  Expense(this.id, this.expenseName, this.amount, this.date);

  Expense.from(Expense data)
      : id = data.id,
        expenseName = data.expenseName,
        amount = data.amount,
        date = data.date;

  Map toMap() {
    return {
      'id': id,
      'expenseName': expenseName,
      'amount': amount,
      'date': date
    };
  }

  String toString() {
    return toMap().toString();
  }
}
