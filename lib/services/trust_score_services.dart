import 'package:cloud_firestore/cloud_firestore.dart';

class TrustScoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Recalculates and updates a user's average trust score in Firestore
  Future<void> updateUserTrustScore({
    required String targetUserId,
    required double newRating, // Rating given for a completed order (1.0 to 5.0)
  }) async {
    DocumentReference userRef = _db.collection('users').doc(targetUserId);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) return;

      Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
      double currentScore = (data['trustScore'] as num?)?.toDouble() ?? 5.0;
      int totalRatings = (data['totalRatings'] as num?)?.toInt() ?? 1;

      // Calculate new weighted running average
      int updatedCount = totalRatings + 1;
      double updatedScore = ((currentScore * totalRatings) + newRating) / updatedCount;

      transaction.update(userRef, {
        'trustScore': double.parse(updatedScore.toStringAsFixed(2)),
        'totalRatings': updatedCount,
      });
    });
  }
}