
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laborator_sma/lib/src/models/monthly_expenses.dart';
import 'package:laborator_sma/lib/src/models/payment.dart';
import 'package:laborator_sma/lib/src/widgets/edit_payment_popup.dart';
import 'package:laborator_sma/lib/src/widgets/payment_list_element.dart';

class ViewPayments extends StatelessWidget {
  const ViewPayments({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ViewPaymentsPage(),
    );
  }
}

class ViewPaymentsPage extends StatefulWidget {
  const ViewPaymentsPage({Key? key}) : super(key: key);

  @override
  State<ViewPaymentsPage> createState() => _ViewPaymentsPageState();
}

class _ViewPaymentsPageState extends State<ViewPaymentsPage> {
  final fb = FirebaseDatabase.instance;
  String queryValue = '';
  String errorMessage = '';
  MonthlyExpenses? monthlyExpenses;
  TextEditingController expensesController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  List<Payment> payments = List<Payment>.empty();
  List<String?> types = List<String>.empty();
  String dropdownValue = '';
  @override
  void initState() {
    super.initState();
    fb.reference().child('wallet').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      setState(() {
        payments = List<Payment>.empty(growable: true);
        print(snapshot.value);
        for(String key in snapshot.value.keys) {
          payments.add(Payment.fromJson(key, snapshot.value[key]));
        }
        types = payments.map((payment) {
          return payment.type;
        }).toSet().toList();
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
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: payments.length,
                itemBuilder: (BuildContext context, int index) {
                  return PaymentListElement(number: index, payment: payments[index], types: types,);
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) => EditPaymentPopup(payment: Payment.empty(DateFormat('yyyy-mm-dd hh:mm:ss').format(DateTime.now())), fd: FirebaseDatabase.instance, typesList: types));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }



}

/*

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 */
