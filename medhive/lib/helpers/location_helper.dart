import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:latlong2/latlong.dart';

abstract class LocationHandler {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled. Please enable the services
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, we cannot request permissions.

      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  // Calculate distance between two LatLng points using Haversine formula
  static double calculateDistance(LatLng point1, LatLng point2) {
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
}