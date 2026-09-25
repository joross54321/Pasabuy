import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;          // Firebase Unique ID
  final String fullName;     // User's Full Name
  final String email;        // Login Email
  final String role;         // Active Role: 'requester' or 'shopper'
  final String address;      // Dorm or Condominium Address
  final GeoPoint location;   // GPS Coordinates (Latitude, Longitude)
  final double trustScore;   // Default 5.0 rating

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    required this.address,
    required this.location,
    this.trustScore = 5.0,   // Starts at a perfect score
  });

  // 1. Convert UserModel object -> Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'role': role,
      'address': address,
      'location': location,
      'trustScore': trustScore,
      'createdAt': FieldValue.serverTimestamp(), // Automatically sets current time
    };
  }

  // 2. Convert Firestore Map -> UserModel object
  factory UserModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return UserModel(
      uid: docId ?? map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'requester',
      address: map['address'] ?? '',
      location: map['location'] ?? const GeoPoint(0, 0),
      trustScore: (map['trustScore'] as num?)?.toDouble() ?? 5.0,
    );
  }
}
