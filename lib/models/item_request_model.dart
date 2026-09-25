import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRequestModel {
  final String? id;
  final String requesterId;
  final String itemName;
  final int quantity;
  final double estimatedCost;
  final String status;
  final DateTime? createdAt;

  ItemRequestModel({
    this.id,
    required this.requesterId,
    required this.itemName,
    required this.quantity,
    required this.estimatedCost,
    required this.status,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'requesterId': requesterId,
      'itemName': itemName,
      'quantity': quantity,
      'estimatedCost': estimatedCost,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory ItemRequestModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemRequestModel(                              
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      itemName: data['itemName'] ?? '',
      quantity: data['quantity'] ?? 1,
      estimatedCost: (data['estimatedCost'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'PENDING',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}