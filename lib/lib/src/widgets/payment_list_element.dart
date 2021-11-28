import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laborator_sma/lib/src/models/payment.dart';

class PaymentListElement extends StatelessWidget {
  const PaymentListElement({Key? key, required this.number, required this.payment}) : super(key: key);

  final Payment payment;
  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
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
              flex:4,
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
            )
          ],
        )
      ),
    );
  }

}