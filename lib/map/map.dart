import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UNTApp extends StatelessWidget {
  const UNTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Campus Map',
      home: Map(),
    );
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kDiscoveryPark = CameraPosition(
    bearing: 302,
    target: LatLng(33.25369983707906, -97.15252309168712),
    zoom: 17,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kDiscoveryPark,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToDP,
        label: const Text('DP'),
        icon: const Icon(Icons.school),
        backgroundColor: const Color(0xFF00853e),
      ),
    );
  }

  Future<void> _goToDP() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kDiscoveryPark));
  }
}