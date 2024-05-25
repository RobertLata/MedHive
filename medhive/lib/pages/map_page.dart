import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';

import '../helpers/location_helper.dart';

class MapPage extends StatefulWidget {
  final LatLng deliveryAddress;
  final LatLng riderAddress;
  final String orderId;

  const MapPage(
      {super.key,
      required this.deliveryAddress,
      required this.riderAddress,
      required this.orderId});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  late LatLng _currentPosition = widget.riderAddress;
  late StreamSubscription<DocumentSnapshot> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPosition();
  }

  void _listenToPosition() {
    _positionStreamSubscription = FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double lat = data['riderLat'];
        double lng = data['riderLong'];
        setState(() {
          _currentPosition = LatLng(lat, lng);
          mapController.move(_currentPosition, mapController.zoom);
        });
      }
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
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: deliveryAddress,
                      builder: (ctx) => const Icon(Icons.home,
                          color: MhColors.mhBlueLight, size: 40.0),
                    ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentPosition,
                      builder: (ctx) => const Icon(Icons.directions_bike,
                          color: MhColors.mhPurple, size: 40.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(MhMargins.standardPadding),
            child: Text(
                'The rider is ${distance.toStringAsFixed(2)} km away from you'),
          ),
        ],
      ),
    );
  }
}
