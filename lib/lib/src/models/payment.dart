import 'package:intl/intl.dart';

class Payment {
  Payment({
    required this.date,
    this.cost,
    this.name,
    this.type
  }) {dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);}
  final String date;
  String? name, type;
  double? cost;
  DateTime? dateTime;

  Payment.fromJson(this.date, Map<dynamic, dynamic> json) {
    cost = json['cost'];
    name = json['name'];
    type = json['type'];
  }


  Map<String, dynamic> toJson() => <String, dynamic>{
    'cost': cost,
    'name': name,
    'type': type,
  };
}