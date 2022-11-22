import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/places.dart";

const kGoogleApiKey = "AIzaSyDu3ov0UuButM8WgABpmOz8GXzXRjMfdqg";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
const List<Widget> _views = <Widget>[
  Text('Filter'),
  Text('Map'),
  Text('List')
];

class UNTApp extends StatelessWidget {
  const UNTApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // dark text for status bar
        statusBarColor: Colors.transparent));
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
  late GoogleMapController _mapController;
  CameraPosition? _cameraPosition;
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //     automaticallyImplyLeading: false,
        //     //centerTitle: true,
        //     backgroundColor: const Color(0xFF00853e),
        //     title: Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: <Widget>[
        //         IconButton(
        //             onPressed: (){_goToDP();},
        //             icon: const Icon(Icons.school_rounded)),
        //       ],
        //       // children: <Widget>[
        //       //   // ToggleButtons with a single selection.
        //       //   const SizedBox(height: 4),
        //       //   ToggleButtons(
        //       //     direction: Axis.horizontal,
        //       //     onPressed: (int index) {
        //       //       setState(() {
        //       //         for (int i = 0; i < 3; i++) {
        //       //           _selectedView[i] = i == index;
        //       //         }
        //       //       });
        //       //     },
        //       //     textStyle: const TextStyle(fontWeight: FontWeight.bold),
        //       //     borderRadius: const BorderRadius.all(Radius.circular(8)),
        //       //     focusColor: const Color(0xFF00853e),
        //       //     selectedBorderColor: const Color(0xFF00853e),
        //       //     selectedColor: const Color(0xFF00853e),
        //       //     fillColor: const Color(0xE7FFFFFF),
        //       //     color: Colors.white,
        //       //     constraints: const BoxConstraints(
        //       //       minHeight: 30.0,
        //       //       minWidth: 80.0,
        //       //     ),
        //       //     isSelected: _selectedView,
        //       //     children: _views,
        //       //   ),
        //       // ],
        //       ),
        // ),
        body: _mapView(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_list_rounded),
              label: "Filter"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: "Map"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_rounded),
              label: "List"
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF00853e),
          onTap: _onNavBarTapped,
        ),
      ),
    );
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _filterBottomSheet(context);
        break;
      case 1: break;
      case 2:
        _listBottomSheet(context);
        break;
      default: break;
    }
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
  }

  GoogleMap _mapView() {
    return GoogleMap(
      padding: const EdgeInsets.only(
          top: 32),
      initialCameraPosition: _cameraPosition ?? _posDiscoveryPark,
      onCameraMove: _onCameraMove,
      onMapCreated: (GoogleMapController controller) {
        //_mapController.complete(controller);
        _mapController = controller;
        setState(() {});
      },
      buildingsEnabled: true,
      indoorViewEnabled: true,
      myLocationEnabled: true,
      trafficEnabled: true,
    );
  }

  final CameraPosition _posDiscoveryPark = const CameraPosition(
    bearing: 302,
    target: LatLng(33.25369983707906, -97.15252309168712),
    zoom: 17,
  );

  Future<void> _goToDP() async {
    //final GoogleMapController controller = await _mapController.future;
    _mapController.animateCamera(CameraUpdate.newCameraPosition(_posDiscoveryPark));
  }
  void _listBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Wrap(
          children: <Widget>[
            const SizedBox(
              height: 32,
              child: Center(child: Icon(Icons.drag_handle_rounded)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LocationData(),
                  LocationData(),
                  LocationData(),
                  LocationData(),
                  LocationData(),
                ]
              ),
            )
          ],
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      isDismissible: true
    ).whenComplete(() => setState(() {_selectedIndex = 1;}));
  }

  void _filterBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Wrap(
          alignment: WrapAlignment.center,
          children: const <Widget>[
            SizedBox(
              height: 32,
              child: Center(child: Icon(Icons.drag_handle_rounded)),
            ),
            FilterPage(),
          ],
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      isDismissible: true
    ).whenComplete(() => setState(() {_selectedIndex = 1;}));
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Filter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        DropdownButton<String>(
          hint: const Text("Restaurant"),
          items: <String>['Restaurant Type A', 'Restaurant Type B', 'Restaurant Type C', 'Restaurant Type D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
        DropdownButton<String>(
          hint: const Text("Shops"),
          items: <String>['Shop Type A', 'Shop Type B', 'Shop Type C', 'Shop Type D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
        DropdownButton<String>(
          hint: const Text("Zones"),
          items: <String>['Zone A', 'Zone B', 'Zone C', 'Zone D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
        DropdownButton<String>(
          hint: const Text("Activities"),
          items: <String>['Activity A', 'Activity B', 'Activity C', 'Activity D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
        DropdownButton<String>(
          hint: const Text("Services"),
          items: <String>['Service A', 'Service B', 'Service C', 'Service D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "One", child: Text("One")),
    const DropdownMenuItem(value: "Two", child: Text("Two")),
    const DropdownMenuItem(value: "Three", child: Text("Three")),
    const DropdownMenuItem(value: "Four", child: Text("Four")),
  ];
  return menuItems;
}


class LocationData extends StatelessWidget {
  const LocationData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text("Business", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                LocationImage(),
                SizedBox(width: 12),
                LocationImage(),
                SizedBox(width: 12),
                LocationImage(),
                SizedBox(width: 12),
                LocationImage(),
                SizedBox(width: 12),
              ],)
          ),
        )
      ],
    );
  }
}

class LocationImage extends StatelessWidget {
  const LocationImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container( // Change to Image when using actual data
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
