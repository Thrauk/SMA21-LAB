import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:laborator_sma/lib/src/models/monthly_expenses.dart';

class SmartWallet extends StatelessWidget {
  const SmartWallet({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SmartWalletPage(),
    );
  }
}

class SmartWalletPage extends StatefulWidget {
  const SmartWalletPage({Key? key}) : super(key: key);

  @override
  State<SmartWalletPage> createState() => _SmartWalletPageState();
}

class _SmartWalletPageState extends State<SmartWalletPage> {
  final fb = FirebaseDatabase.instance;
  String queryValue = '';
  String errorMessage = '';
  MonthlyExpenses? monthlyExpenses;
  TextEditingController expensesController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  List<String> months = List<String>.empty();
  String dropdownValue = '';
  @override
  void initState() {
    super.initState();
    fb.reference().child('calendar').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      setState(() {
        months = List<String>.empty(growable: true);
        months.add('');
        print(snapshot.value);
        for(String key in snapshot.value.keys) {
          months.add(key);
        }
        print(months);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DropdownButton(
              items: months.map((String value) {
                return DropdownMenuItem(child: Text(value), value: value);
              }).toList(),
              value: dropdownValue,
              onChanged: (String? newValue) async {
                dropdownValue = newValue!;


                if(dropdownValue != '') {
                  DataSnapshot data = await ref
                      .child('calendar')
                      .child(dropdownValue.toLowerCase())
                      .get();
                  setState( () {

                    monthlyExpenses = MonthlyExpenses.fromJson(
                        queryValue.toLowerCase(), data.value);
                    if (monthlyExpenses != null) {
                      setState(() {
                        incomeController.text =
                            monthlyExpenses!.income.toString();
                        expensesController.text =
                            monthlyExpenses!.expenses.toString();
                      });
                    }
                  });
                }

              },
            ),
            Text(errorMessage),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(
                  child: Text('Income: '),
                ),
                Expanded(child: TextField(controller: incomeController)),
                const Expanded(
                  child: Text(''
                      'Expanses:'),
                ),
                Expanded(
                  child: TextField(controller: expensesController),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (monthlyExpenses != null &&
                    expensesController.text != '' &&
                    incomeController.text != '') {
                  monthlyExpenses!.expenses =
                      int.parse(expensesController.text);
                  monthlyExpenses!.income = int.parse(incomeController.text);
                  await ref
                      .child('calendar')
                      .child(monthlyExpenses!.month)
                      .update(monthlyExpenses!.toJson());
                }
              },
              child: const Text('UPDATE'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 30)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        queryValue = text;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DataSnapshot data = await ref
                          .child('calendar')
                          .child(queryValue.toLowerCase())
                          .get();

                      if (data.value != null) {
                        errorMessage = '';
                        print(data.value);
                        monthlyExpenses = MonthlyExpenses.fromJson(
                            queryValue.toLowerCase(), data.value);
                        if (monthlyExpenses != null) {
                          setState(() {
                            incomeController.text =
                                monthlyExpenses!.income.toString();
                            expensesController.text =
                                monthlyExpenses!.expenses.toString();
                          });
                        }
                      } else {
                        setState(() {
                          errorMessage = 'Value can not be found';
                        });
                      }
                    },
                    child: const Text('SEARCH'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 30)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getMonths() async {
    List<String> ret = List<String>.empty();
    DataSnapshot data = await fb.reference().child('calendar').get();
    return data.value().map((el) => ret.add(el));
  }

}

/*

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 */
