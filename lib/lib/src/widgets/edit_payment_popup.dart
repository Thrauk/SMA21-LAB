import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:laborator_sma/lib/src/models/payment.dart';


class EditPaymentPopup extends StatelessWidget {
  const EditPaymentPopup({Key? key, required this.payment, required this.fd, required this.typesList}) : super(key: key);

  final Payment payment;
  final FirebaseDatabase fd;
  final List<String?> typesList;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return EditPaymentPopupAux(payment: payment, fd: fd, typesList: typesList);
  }
}

class EditPaymentPopupAux extends StatefulWidget {
  const EditPaymentPopupAux({Key? key, required this.payment, required this.fd, required this.typesList}) : super(key: key);
  final Payment payment;
  final FirebaseDatabase fd;
  final List<String?> typesList;
  @override
  State<EditPaymentPopupAux> createState() => _EditPaymentPopupState(payment: payment, fd: fd, typesList: typesList);
}


class _EditPaymentPopupState extends State<EditPaymentPopupAux> {
  _EditPaymentPopupState({required this.payment, required this.fd, required this.typesList})
  {
    dropdownValue = payment.type ?? typesList[0];
  }

  final Payment payment;
  final FirebaseDatabase fd;
  final List<String?> typesList;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  bool nameChanged = false;
  bool costChanged = false;

  String? dropdownValue;

  String errorText = '';

  @override
  Widget build(BuildContext context) {
    nameController.text = !nameChanged ? (payment.name ?? '') : nameController.text;
    costController.text = !costChanged ? (payment.cost != null ? (payment.cost.toString()) : '') : costController.text ;

    return AlertDialog(
      content: Column(
        children: <Widget>[
          Text(
            errorText,
            style: const TextStyle(color: Colors.red),
          ),
          TextField(
            controller: nameController,
            onChanged: (_) {
              nameChanged = true;
            },
          ),
          TextField(
            controller: costController,
            onChanged: (_) {
              costChanged = true;
            },
          ),
          DropdownButton(
            items: typesList.map((String? value) {
              return DropdownMenuItem(child: Text(value ?? ''), value: value);
            }).toList(),
            value: dropdownValue,
            onChanged: (String? newValue) async {
              setState(() {
                dropdownValue = newValue!;

              });
            },
          ),
          Text(
            'Time of payment: ${payment.date}'
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if(costController.text == '' || nameController.text == '') {
              setState(() {
                errorText = 'Can not leave any empty text fields!';
              });
            }
            else {
              Navigator.pop(context, 'SAVE');
              payment.type = dropdownValue;
              payment.name = nameController.value.text != '' ? nameController.value.text : payment.name;
              payment.cost = nameController.value.text != '' ? double.parse(costController.value.text) : payment.cost;
              await fd.reference().child('wallet').child(payment.date).update(payment.toJson());
            }

          },
          child: const Text('SAVE'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'CANCEL');
          },
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}