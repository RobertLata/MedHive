import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';

import '../helpers/location_helper.dart';
import '../widgets/mh_appbar_logo_right.dart';

class RiderLocationPage extends StatefulWidget {
  final LatLng deliveryAddress;
  final String orderId;

  const RiderLocationPage(
      {super.key, required this.deliveryAddress, required this.orderId});

  @override
  State<RiderLocationPage> createState() => _RiderLocationPageState();
}

class _RiderLocationPageState extends State<RiderLocationPage> {
  MapController mapController = MapController();
  LatLng _currentPosition = const LatLng(0, 0);
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPosition();
  }

  void _listenToPosition() {
    var locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _updateRiderPosition(
          widget.orderId, position.latitude, position.longitude);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        mapController.move(_currentPosition, mapController.zoom);
      });
    });
  }

  Future<void> _updateRiderPosition(
      String orderId, double latitude, double longitude) async {
    final docOrders =
        FirebaseFirestore.instance.collection('Orders').doc(orderId);

    await docOrders.update({
      'riderLat': latitude,
      'riderLong': longitude,
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryAddress = widget.deliveryAddress;
    final distance =
        LocationHandler.calculateDistance(_currentPosition, deliveryAddress);

    return Scaffold(
      appBar: MhAppBarLogoRight(
        isBackVisible: true,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: _currentPosition,
                zoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    // Delivery address marker
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: deliveryAddress,
                      builder: (ctx) => const Icon(
                        Icons.home,
                        color: MhColors.mhBlueLight,
                        size: 40.0,
                      ),
                    ),
                    // Delivery guy's location marker
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentPosition,
                      builder: (ctx) => const Icon(
                        Icons.directions_bike,
                        color: MhColors.mhPurple,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(MhMargins.standardPadding),
            child: Text(
                'Distance to delivery address: ${distance.toStringAsFixed(2)} km'),
          ),
        ],
      ),
    );
  }
}
