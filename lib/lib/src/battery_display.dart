import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryDisplay extends StatelessWidget {
  const BatteryDisplay({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BatteryDisplayPage(),
    );
  }
}

class BatteryDisplayPage extends StatefulWidget {
  const BatteryDisplayPage({Key? key}) : super(key: key);

  @override
  State<BatteryDisplayPage> createState() => _BatteryDisplayPageState();
}

class _BatteryDisplayPageState extends State<BatteryDisplayPage> {
  final _battery = Battery();
  List<String> stateMessageList = ['Full', 'Charging', 'Discharging'];
  List<IconData> stateIconList = [Icons.battery_full, Icons.battery_charging_full_rounded, Icons.battery_alert];
  String stateMessage = "Unknown";

  @override
  void initState() {
    super.initState();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      switch(state) {
        case BatteryState.full:
          stateMessage = stateMessageList[0];
          break;
        case BatteryState.charging:
          stateMessage = stateMessageList[1];
          break;
        case BatteryState.discharging:
          stateMessage = stateMessageList[2];
        break;
      }
      setState(() {});
    });
  }

  Future<String?> getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    return data!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                stateMessage,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
