import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//AIzaSyA24dafkWaAS7QeKhJefBEzUdD0bLfVv2Q
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    getMyLocation();
    if (Platform.isAndroid) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.070482, 31.3424045),
    zoom: 15,
  );

  List stores = [
    {
      'lat': 12.241274891,
      'lng': 12.241274891,
      'storeName': "Apple",
    }
  ];

  List<Marker> lats = [];

  @override
  Widget build(BuildContext context) {
    // for (var element in stores) {
    //
    //   Marker marker = Marker(
    //     markerId: element["lat"],
    //     position: LatLng(
    //       element["lat"],
    //       element["lng"],
    //     ),
    //   );
    //
    //   lats.add(marker);
    // }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.hybrid,
            markers: markers.values.toSet(),
            initialCameraPosition: _kGooglePlex,
            onTap: (point) => onMapTapped(point),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
              child: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Confirm location"),
            ),
          ))
        ],
      ),
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  onMapTapped(LatLng point) async {
    markers.clear();

    List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(point.latitude, point.longitude);

    if (placemarks.isNotEmpty) {
      print(placemarks[0].name);
      print(placemarks[0].administrativeArea);
      print(placemarks[0].country);
      print(placemarks[0].isoCountryCode);
      print(placemarks[0].locality);
      print(placemarks[0].postalCode);
      print(placemarks[0].street);
      print(placemarks[0].subAdministrativeArea);
      print(placemarks[0].subThoroughfare);
      print(placemarks[0].subLocality);
      print(placemarks[0].thoroughfare);
    }

    var marker = Marker(
      markerId: MarkerId(point.latitude.toString()),
      position: point,
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: placemarks[0].name,
        snippet: placemarks[0].street,
      ),
    );

    markers[MarkerId(point.latitude.toString())] = marker;
    print('Marker added to list');
    setState(() {});
  }

  void getMyLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    print('Lat => ${_locationData.latitude}');
    print('Lng => ${_locationData.longitude}');
  }
}
