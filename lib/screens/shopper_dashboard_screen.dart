import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/haversine_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import 'shopper_intent_broadcast_screen.dart';

class ShopperDashboardScreen extends StatefulWidget {
  const ShopperDashboardScreen({super.key});

  @override
  State<ShopperDashboardScreen> createState() => _ShopperDashboardScreenState();
}

class _ShopperDashboardScreenState extends State<ShopperDashboardScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GeoPoint? _shopperLocation;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchShopperLocation();
  }

  // Fetch current shopper's registered home/GPS location from Firestore
  Future<void> _fetchShopperLocation() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          _shopperLocation = userDoc['location'] as GeoPoint?;
        });
      }
    }
  }

  void _onNavTap(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ShopperIntentBroadcastScreen()),
      );
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: AppBar(
        backgroundColor: AppColors.bgApp,
        title: const Text(
          'Shopper Dashboard',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _auth.signOut(),
          )
        ],
      ),
      body: _shopperLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // REAL-TIME PROXIMITY-MATCHED REQUESTERS LIST
                  const Text(
                    'Nearby Requesters (Within 150m)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _db
                          .collection('users')
                          .where('role', isEqualTo: 'requester')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        var requesterDocs = snapshot.data!.docs;

                        // Filter requesters using Haversine Formula
                        var matchedRequesters = requesterDocs.where((doc) {
                          GeoPoint requesterLoc = doc['location'] as GeoPoint;
                          return HaversineService.isWithinMicroCell(
                            _shopperLocation!,
                            requesterLoc,
                            maxRadiusMeters: 150.0,
                          );
                        }).toList();

                        if (matchedRequesters.isEmpty) {
                          return const Center(
                            child: Text(
                              'No requesters found within 150m radius.',
                              style: TextStyle(color: AppColors.bodyText),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: matchedRequesters.length,
                          itemBuilder: (context, index) {
                            var requester = matchedRequesters[index];
                            GeoPoint requesterLoc = requester['location'] as GeoPoint;
                            double distance = HaversineService.calculateDistance(
                              _shopperLocation!,
                              requesterLoc,
                            );

                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.surface,
                                  child: Icon(Icons.person, color: AppColors.primary),
                                ),
                                title: Text(
                                  requester['fullName'],
                                  style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  '${requester['address']} • ${distance.toStringAsFixed(1)}m away',
                                  style: const TextStyle(color: AppColors.bodyText),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Handle accepting order request
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                  child: const Text('Accept'),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        centerLabel: 'Broadcast',
        centerIcon: Icons.campaign_outlined,
      ),
    );
  }
}
