import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mis_app/services/maps_services.dart';
import 'package:http/http.dart' as http;

class MapDialog extends StatefulWidget {
  const MapDialog({super.key});

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  final LatLng _facultyLocation = const LatLng(41.9975, 21.409887755806437);
  final LatLng _secondLocation = const LatLng(42.0054, 21.40715);
  final Set<Marker> _markers = {};
  LocationData? _currentLocation;
  final Location _location = Location();
  final Set<Polyline> _polylines = {};
  StreamSubscription<LocationData>? _locationSubscription;
  late GoogleMapController _mapController;

  void _startLocationTracking() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData newLocationData) {
      setState(() {
        _currentLocation = newLocationData;
        _markers.clear();
        if (_currentLocation != null) {
          _markers.add(Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(100.0),
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
                _currentLocation!.latitude!, _currentLocation!.longitude!),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ));
        }
      });
    });
  }

  Future<void> _getDirections() async {
    String directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${_facultyLocation.latitude},${_facultyLocation.longitude}'
        '&destination=${_secondLocation.latitude},${_secondLocation.longitude}'
        '&mode=driving'
        '&key=NoKeyForYou';

    final response = await http.get(Uri.parse(directionsUrl));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final routes = jsonResponse['routes'];
      if (routes != null && routes.isNotEmpty) {
        final points = decodePolyline(routes[0]['overview_polyline']['points']);
        setState(() {
          _polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
    _getDirections().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AlertDialog(
      title: const Text("Map"),
      content: SizedBox(
        width: mediaQuery.size.width * 0.8,
        height: mediaQuery.size.height * 0.6,
        child: GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _facultyLocation,
            zoom: 17,
          ),
          polylines: _polylines,
          markers: _markers,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
