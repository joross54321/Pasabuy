import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/store_fsm_service.dart';

/// Extracted from ShopperDashboardScreen's inline "Intent-to-Shop" card + FSM
/// controls. FSM logic (StoreFsmService) is unchanged from the original.
class ShopperIntentBroadcastScreen extends StatefulWidget {
  const ShopperIntentBroadcastScreen({super.key});

  @override
  State<ShopperIntentBroadcastScreen> createState() => _ShopperIntentBroadcastScreenState();
}

class _ShopperIntentBroadcastScreenState extends State<ShopperIntentBroadcastScreen> {
  final StoreFsmService _fsmService = StoreFsmService();

  String _selectedStore = 'SM City Iloilo';
  bool _isListingActive = false;

  // Handle Intent-to-Shop Listing Toggle
  void _toggleListing() {
    setState(() {
      _isListingActive = !_isListingActive;
      if (_isListingActive) {
        _fsmService.handleGeofenceEvent('START_TRIP');
      } else {
        _fsmService.reset();
      }
    });
  }

  // Simulate Geofence Events for Testing FSM Transitions
  void _simulateGeofenceTrigger(String event) {
    setState(() {
      _fsmService.handleGeofenceEvent(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: AppBar(
        backgroundColor: AppColors.bgApp,
        title: const Text(
          'Broadcast Intent-to-Shop',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. FSM STATUS DISPLAY CARD
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Current Store Status',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        _fsmService.currentState.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. STORE SELECTION & INTENT-TO-SHOP BUTTON
              DropdownButtonFormField<String>(
                initialValue: _selectedStore,
                decoration: const InputDecoration(labelText: 'Target Store'),
                items: const [
                  DropdownMenuItem(value: 'SM City Iloilo', child: Text('SM City Iloilo')),
                  DropdownMenuItem(value: 'Gaisano Capital', child: Text('Gaisano Capital')),
                  DropdownMenuItem(value: 'Local Supermarket', child: Text('Local Supermarket')),
                ],
                onChanged: _isListingActive ? null : (val) => setState(() => _selectedStore = val!),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _toggleListing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isListingActive ? AppColors.danger : AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _isListingActive ? 'Cancel Intent-to-Shop' : 'Broadcast Intent-to-Shop',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              // 3. TESTING CONTROLS (Simulate Geofence Transitions)
              if (_isListingActive) ...[
                const Text(
                  'Simulate Geofence Triggers (Testing Mode):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => _simulateGeofenceTrigger('GEOFENCE_TRANSITION_ENTER'),
                      child: const Text('Enter Store Boundary'),
                    ),
                    OutlinedButton(
                      onPressed: () => _simulateGeofenceTrigger('GEOFENCE_TRANSITION_DWELL'),
                      child: const Text('Confirm Dwell (Inside)'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
