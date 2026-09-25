import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import 'requester_home_screen.dart';
import 'shopper_dashboard_screen.dart';

class RoleDispatchScreen extends StatelessWidget {
  final String uid;
  const RoleDispatchScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return FutureBuilder<UserModel?>(
      future: firestoreService.getUserProfile(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        if (user.role == 'shopper') {
          return const ShopperDashboardScreen();
        }
        return RequesterHomeScreen(currentUser: user);
      },
    );
  }
}