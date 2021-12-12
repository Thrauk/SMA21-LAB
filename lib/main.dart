import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laborator_sma/lib/src/repository/auth_repository.dart';
import 'package:laborator_sma/lib/src/view_payments.dart';

import 'lib/src/auth.dart';
import 'lib/src/web_view_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var connectivity = await (Connectivity().checkConnectivity());
  if(connectivity == ConnectivityResult.none) {
    ViewPayments.connState = ConnState.offline;
  } else {
    ViewPayments.connState = ConnState.online;
  }
  FirebaseAuthRepository firebaseAuthRepository = FirebaseAuthRepository();
  if(firebaseAuthRepository.currentUser.isNotEmpty){
    runApp(const ViewPayments());
  } else {
    runApp(const Auth());
  }
}
