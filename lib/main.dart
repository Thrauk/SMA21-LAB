import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laborator_sma/lib/src/battery_display.dart';
import 'package:laborator_sma/lib/src/smart_wallet.dart';
import 'package:laborator_sma/lib/src/view_payments.dart';

import 'lib/src/web_view_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ViewPayments());
}
