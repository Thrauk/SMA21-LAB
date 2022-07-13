import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucrarea 12',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng facultate = const LatLng(45.74502884, 21.2275766);
  LatLng opera = const LatLng(45.754081351058666, 21.225863361934802);

  Marker facultateMarker = Marker(position: LatLng(45.74502884, 21.2275766), markerId: const MarkerId('facultate'));
  Marker operaMarker = Marker(position: LatLng(45.754081351058666, 21.225863361934802), markerId: const MarkerId('opera'));

  static final CameraPosition _position = CameraPosition(
    target: LatLng(45.74502884, 21.2275766),
    zoom: 18,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _position,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {facultateMarker,operaMarker},
        polylines: {Polyline(polylineId: PolylineId('facultate-opera'),
          points: [facultate, opera],
        )},
      ),
    );
  }

}