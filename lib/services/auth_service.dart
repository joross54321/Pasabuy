import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of auth state changes (Logged in / Logged out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;

  // Sign Up & Create Firestore User Document
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role, // 'requester' or 'shopper'
    required String address,
    required GeoPoint location,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        UserModel newUser = UserModel(
          uid: cred.user!.uid,
          fullName: fullName,
          email: email,
          role: role,
          address: address,
          location: location,
        );

        await _db.collection('users').doc(cred.user!.uid).set(newUser.toMap());
      }
      return cred;
    } catch (e) {
      rethrow;
    }
  }

  // Sign In
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}