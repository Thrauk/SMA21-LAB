import 'package:intl/intl.dart';

class Payment {
  Payment({
    required this.date,
    this.cost,
    this.name,
    this.type,
    this.ownerUid
  }) {dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);}
  final String date;
  String? name, type;
  double? cost;
  DateTime? dateTime;
  String? ownerUid;

  Payment.fromJson(this.date, Map<dynamic, dynamic> json) {
    cost = json['cost'] * 1.0;
    name = json['name'];
    type = json['type'];
    ownerUid = json['ownerUid'];
  }

  Payment.empty(this.date) {

    name = '';
    cost = 0.0;
  }


  Map<String, dynamic> toJson() => <String, dynamic>{
    'cost': cost,
    'name': name,
    'type': type,
    'ownerUid' : ownerUid,
  };
}