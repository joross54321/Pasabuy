import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? id;
  final String requestId;
  final String requesterId;
  final String shopperId;
  final String storeName;
  final double totalAmount;
  final String status; // 'MATCHED', 'IN_TRANSIT', 'DELIVERED', 'COMPLETED'
  final DateTime? createdAt;

  TransactionModel({
    this.id,
    required this.requestId,
    required this.requesterId,
    required this.shopperId,
    required this.storeName,
    required this.totalAmount,
    this.status = 'MATCHED',
    this.createdAt,
  });

  // Convert Object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'requesterId': requesterId,
      'shopperId': shopperId,
      'storeName': storeName,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
    };
  }

  // Read Object from Firestore Map
  factory TransactionModel.fromMap(Map<String, dynamic> map, String docId) {
    return TransactionModel(
      id: docId,
      requestId: map['requestId'] ?? '',
      requesterId: map['requesterId'] ?? '',
      shopperId: map['shopperId'] ?? '',
      storeName: map['storeName'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'MATCHED',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}