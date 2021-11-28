import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laborator_sma/lib/src/models/payment.dart';
import 'package:laborator_sma/lib/src/widgets/edit_payment_popup.dart';

class PaymentListElement extends StatelessWidget {
  const PaymentListElement({Key? key, required this.number, required this.payment, required this.types}) : super(key: key);

  final Payment payment;
  final int number;
  final List<String?> types;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
                flex:1,
                child: Container(
                  color: Colors.blueAccent,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text('$number'),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(payment.name!)
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            Expanded(
              flex:3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Text(
                            'Date: ${payment.date.split(' ')[0]}'
                        ),
                        Text(
                          'Time: ${payment.date.split(' ')[1].replaceAll(' ', '')}',
                        ),
                      ]

                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                        children: <Widget>[
                          Text(
                              '${payment.cost} LEI'
                          ),
                          Text(
                            payment.type ?? '' ,
                          ),
                        ]

                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context) => EditPaymentPopup(payment: payment, fd: FirebaseDatabase.instance, typesList: types));
                    },
                    child: const Icon(
                      Icons.edit
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseDatabase.instance.reference().child('wallet').child(payment.date).remove();
                    },
                    child: const Icon(
                        Icons.delete_forever
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

}