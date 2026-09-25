import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/role_dispatch_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using auto-configured options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  const mapboxToken = String.fromEnvironment('ACCESS_TOKEN');
if (mapboxToken.isNotEmpty) {
  MapboxOptions.setAccessToken(mapboxToken);
}
  runApp(const PasabuyApp());
}

class PasabuyApp extends StatelessWidget {
  const PasabuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasabuy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthWrapper(),
    );
  }
}

/// Listens to auth state changes and routes the user accordingly
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading spinner while determining auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If a session exists, route to profile verification / dashboard
        if (snapshot.hasData && snapshot.data != null) {
          return RoleDispatchScreen(uid: snapshot.data!.uid);
        }

        // Otherwise, show Login / Sign-up
        return const LoginScreen();
      },
    );
  }
}