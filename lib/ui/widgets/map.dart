import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => MapSampleState();
}

class MapSampleState extends State<Map> {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Location _locationController = Location();
  LatLng? userLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/mapthemes/uber_theme.json')
        .then((value) {
      mapTheme = value;
    });
    _updateUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(mapTheme);
                _controller.complete(controller);
              },
              markers: {
                Marker(
                    markerId: const MarkerId("userLocation"),
                    position: userLocation!,
                    infoWindow: const InfoWindow(title: "You are here"))
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: _goToTheLake,
              label: const Text('To the lake!'),
              icon: const Icon(Icons.directions_boat),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FloatingActionButton(
                onPressed: _goToMe,
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: userLocation!, zoom: 14.4746)));
  }

  Future<void> _updateUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.longitude != null &&
          currentLocation.latitude != null) {
        setState(() {
          userLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }
}
