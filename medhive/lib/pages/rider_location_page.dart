import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';

class MapPage extends StatefulWidget {
  final LatLng deliveryAddress; // Delivery address coordinates

  MapPage({required this.deliveryAddress});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  LatLng _currentPosition = LatLng(45.7489, 21.2087); // Default position: San Francisco
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _positionStreamSubscription.cancel();
  }

  void _getPosition() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
          (Position position) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      },
      onError: (error) => print(error),
    );
  }

  // Calculate distance between two LatLng points using Haversine formula
  double calculateDistance(LatLng point1, LatLng point2) {
    const EARTH_RADIUS = 6371.0; // Earth's radius in kilometers
    final double lat1 = point1.latitude;
    final double lon1 = point1.longitude;
    final double lat2 = point2.latitude;
    final double lon2 = point2.longitude;
    final double dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
    final double dLon = (lon2 - lon1) * (3.141592653589793 / 180.0);
    final double a = pow(sin(dLat / 2), 2) +
        cos(lat1 * (3.141592653589793 / 180.0)) *
            cos(lat2 * (3.141592653589793 / 180.0)) *
            pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = EARTH_RADIUS * c;
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    final deliveryAddress = widget.deliveryAddress;

    final distance = calculateDistance(_currentPosition, deliveryAddress);

    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: _currentPosition,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    // Delivery address marker
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: deliveryAddress,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.home,
                          color: MhColors.mhBlueLight,
                          size: 40.0,
                        ),
                      ),
                    ),
                    // Delivery guy's location marker
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentPosition,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_pin,
                          color: MhColors.mhPurple,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(MhMargins.standardPadding),
            child: Text('Distance to delivery address: ${distance.toStringAsFixed(2)} km'),
          ),
        ],
      ),
    );
  }
}
