import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class HaversineService {
  // Earth's radius in meters
  static const double _earthRadiusMeters = 6371000.0;

  /// Calculates straight-line distance in meters between two GeoPoints
  static double calculateDistance(GeoPoint point1, GeoPoint point2) {
    double lat1Rad = _toRadians(point1.latitude);
    double lat2Rad = _toRadians(point2.latitude);
    double deltaLatRad = _toRadians(point2.latitude - point1.latitude);
    double deltaLngRad = _toRadians(point2.longitude - point1.longitude);

    double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLngRad / 2) * sin(deltaLngRad / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusMeters * c; // Distance in meters
  }

  /// Checks if a Requester is within the 150-meter micro-cell radius of a Shopper
  static bool isWithinMicroCell(GeoPoint shopperLocation, GeoPoint requesterLocation, {double maxRadiusMeters = 150.0}) {
    double distance = calculateDistance(shopperLocation, requesterLocation);
    return distance <= maxRadiusMeters;
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180.0);
  }
}