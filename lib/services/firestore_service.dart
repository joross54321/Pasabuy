import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/item_request_model.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Get User Profile Data
  Future<UserModel?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // 2. Stream All Active Requesters (For Shopper Proximity Matching)
  Stream<List<UserModel>> streamRequesters() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'requester')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // 3. Create Item Request (Requester)
  Future<void> createItemRequest({
    required String requesterId,
    required String itemName,
    required int quantity,
    required double estimatedCost,
  }) async {
    await _db.collection('item_requests').add({
      'requesterId': requesterId,
      'itemName': itemName,
      'quantity': quantity,
      'estimatedCost': estimatedCost,
      'status': 'PENDING',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. Stream Pending Requests for a Specific Requester
  Stream<QuerySnapshot> streamRequesterRequests(String requesterId) {
    return _db
        .collection('item_requests')
        .where('requesterId', isEqualTo: requesterId)
        .snapshots();
  }

  // 5. Accept Item Request & Create Transaction (Shopper Action)
  Future<void> acceptItemRequest({
    required String requestId,
    required String requesterId,
    required String shopperId,
    required String storeName,
    required double totalAmount,
  }) async {
    WriteBatch batch = _db.batch();

    // Update item request status to ACCEPTED
    DocumentReference reqRef = _db.collection('item_requests').doc(requestId);
    batch.update(reqRef, {'status': 'ACCEPTED'});

    // Create a new record in transactions collection
    DocumentReference transRef = _db.collection('transactions').doc();
    batch.set(transRef, {
      'requestId': requestId,
      'requesterId': requesterId,
      'shopperId': shopperId,
      'storeName': storeName,
      'totalAmount': totalAmount,
      'status': 'MATCHED',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
      // Update shopper's live GPS location in Firestore
    Future<void> updateUserLocation(String uid, GeoPoint newLocation) async {
      await _db.collection('users').doc(uid).update({
        'location': newLocation,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
  }
      // Advance transaction status ('IN_TRANSIT', 'DELIVERED', 'COMPLETED')
    Future<void> updateTransactionStatus({
      required String transactionId,
      required String newStatus,
    }) async {
      await _db.collection('transactions').doc(transactionId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

        // Stream active transactions for a Requester
      Stream<List<TransactionModel>> streamRequesterTransactions(String requesterId) {
        return _db
            .collection('transactions')
            .where('requesterId', isEqualTo: requesterId)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
                .toList());
      }

      // Stream active transactions for a Shopper
      Stream<List<TransactionModel>> streamShopperTransactions(String shopperId) {
        return _db
            .collection('transactions')
            .where('shopperId', isEqualTo: shopperId)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
                .toList());
      }
}
