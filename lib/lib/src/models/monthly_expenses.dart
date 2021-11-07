class MonthlyExpenses {

  MonthlyExpenses({
    required this.month,
    this.income,
    this.expenses,
  });
  final String month;
  int? income,expenses;

  MonthlyExpenses.fromJson(this.month, Map<dynamic, dynamic> json) {
    income = json['income'];
    expenses =json['expenses'] ;
  }


  Map<String, dynamic> toJson() => <String, dynamic>{
    'expenses': expenses,
    'income': income,
  };

}