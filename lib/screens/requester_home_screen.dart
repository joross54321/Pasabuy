import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../models/user_model.dart';
import '../services/haversine_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import 'create_item_request_screen.dart';

/// Full-screen live map of nearby active Shoppers for the Requester.
///
/// NOTE: mapbox_maps_flutter's own supported-API matrix marks "View
/// Annotations" as unsupported on both Android and iOS — there is no
/// ViewAnnotationManager/widget-builder API in this package to render
/// arbitrary Flutter widgets as map markers. Instead we project each
/// marker's GeoPoint to screen pixels via MapboxMap.pixelForCoordinate()
/// and overlay real Flutter widgets with Stack/Positioned, refreshed
/// whenever the camera moves or the live listings change.
class RequesterHomeScreen extends StatefulWidget {
  final UserModel currentUser;
  const RequesterHomeScreen({super.key, required this.currentUser});

  @override
  State<RequesterHomeScreen> createState() => _RequesterHomeScreenState();
}

class _RequesterHomeScreenState extends State<RequesterHomeScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MapboxMap? _mapboxMap;
  int _navIndex = 0;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _nearbyShoppers = [];
  String _lastSignature = '';

  // Screen-space pixel positions for the current frame's markers.
  // Key is the listing doc id, plus a reserved '__you__' entry.
  final Map<String, ScreenCoordinate> _markerPositions = {};

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _refreshMarkerPositions();
  }

  Future<void> _refreshMarkerPositions() async {
    final map = _mapboxMap;
    if (map == null) return;

    final positions = <String, ScreenCoordinate>{};

    positions['__you__'] = await map.pixelForCoordinate(
      Point(
        coordinates: Position(
          widget.currentUser.location.longitude,
          widget.currentUser.location.latitude,
        ),
      ),
    );

    for (final doc in _nearbyShoppers) {
      final geo = doc.data()['location'] as GeoPoint?;
      if (geo == null) continue;
      positions[doc.id] = await map.pixelForCoordinate(
        Point(coordinates: Position(geo.longitude, geo.latitude)),
      );
    }

    if (mounted) {
      setState(() {
        _markerPositions
          ..clear()
          ..addAll(positions);
      });
    }
  }

  void _onNavTap(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CreateItemRequestScreen()),
      );
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWidget(
              key: const ValueKey('requester-live-map'),
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: Position(
                    widget.currentUser.location.longitude,
                    widget.currentUser.location.latitude,
                  ),
                ),
                zoom: 16.5,
              ),
              onMapCreated: _onMapCreated,
              onCameraChangeListener: (_) => _refreshMarkerPositions(),
            ),
          ),

          // Live Shopper listings, filtered to the 150m micro-cell.
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _db
                .collection('listings')
                .where('isListingActive', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              final allListings = snapshot.data?.docs ?? [];

              final nearby = allListings.where((doc) {
                final geo = doc.data()['location'] as GeoPoint?;
                if (geo == null) return false;
                return HaversineService.isWithinMicroCell(
                  widget.currentUser.location,
                  geo,
                  maxRadiusMeters: 150.0,
                );
              }).toList();

              final signature = nearby.map((d) {
                final geo = d.data()['location'] as GeoPoint?;
                return '${d.id}:${geo?.latitude}:${geo?.longitude}';
              }).join('|');

              _nearbyShoppers = nearby;
              if (signature != _lastSignature) {
                _lastSignature = signature;
                WidgetsBinding.instance.addPostFrameCallback((_) => _refreshMarkerPositions());
              }

              return Stack(
                children: [
                  for (final doc in nearby)
                    if (_markerPositions[doc.id] != null)
                      _ShopperPin(
                        position: _markerPositions[doc.id]!,
                        distanceMeters: HaversineService.calculateDistance(
                          widget.currentUser.location,
                          doc.data()['location'] as GeoPoint,
                        ),
                      ),

                  if (_markerPositions['__you__'] != null)
                    _YouPin(position: _markerPositions['__you__']!),

                  if (snapshot.connectionState != ConnectionState.waiting && nearby.isEmpty)
                    Positioned(
                      top: topInset + 64,
                      left: 24,
                      right: 24,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 2)),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storefront_outlined, size: 16, color: AppColors.placeholder),
                              SizedBox(width: 8),
                              Text(
                                'No active Shoppers broadcasting nearby',
                                style: TextStyle(fontSize: 12, color: AppColors.bodyText),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Floating overlay: current mode pill + notification bell.
          Positioned(
            top: topInset + 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 2)),
                    ],
                  ),
                  child: const Text(
                    'Current Mode: Requester',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
                Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.notifications_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    _CircleIconButton(
                      icon: Icons.logout,
                      onPressed: () => _auth.signOut(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        centerLabel: 'Request',
        centerIcon: Icons.add_shopping_cart,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.textDark, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

/// Solid purple rectangular pin marking the current Requester's own position.
class _YouPin extends StatelessWidget {
  const _YouPin({required this.position});

  final ScreenCoordinate position;

  static const double _width = 56;
  static const double _height = 30;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.x - _width / 2,
      top: position.y - _height,
      child: Container(
        width: _width,
        height: _height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x337C3AED), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: const Text(
          'You',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}

/// Circular purple Shopper marker with a white distance pill underneath.
class _ShopperPin extends StatelessWidget {
  const _ShopperPin({required this.position, required this.distanceMeters});

  final ScreenCoordinate position;
  final double distanceMeters;

  static const double _iconSize = 36;

  @override
  Widget build(BuildContext context) {
    final label = '${distanceMeters.round()} m';

    return Positioned(
      left: position.x - _iconSize / 2,
      top: position.y - _iconSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _iconSize,
            height: _iconSize,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x337C3AED), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: const Icon(Icons.storefront, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 4, offset: Offset(0, 1))],
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
