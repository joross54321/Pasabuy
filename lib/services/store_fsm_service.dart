enum ShopperState {
  idle,
  inTransit,
  dwell,
  insideStore,
}

class StoreFsmService {
  ShopperState _currentState = ShopperState.idle;

  ShopperState get currentState => _currentState;

  /// Handles state transitions triggered by Geofence events
  ShopperState handleGeofenceEvent(String geofenceEventType) {
    switch (_currentState) {
      case ShopperState.idle:
        if (geofenceEventType == 'START_TRIP') {
          _currentState = ShopperState.inTransit;
        }
        break;

      case ShopperState.inTransit:
        if (geofenceEventType == 'GEOFENCE_TRANSITION_ENTER') {
          _currentState = ShopperState.dwell;
        }
        break;

      case ShopperState.dwell:
        if (geofenceEventType == 'GEOFENCE_TRANSITION_DWELL') {
          _currentState = ShopperState.insideStore;
          // Trigger automated requester push notification dispatch here
        } else if (geofenceEventType == 'GEOFENCE_TRANSITION_EXIT') {
          _currentState = ShopperState.inTransit; // Reset back if user left prematurely
        }
        break;

      case ShopperState.insideStore:
        if (geofenceEventType == 'FINISH_SHOPPING') {
          _currentState = ShopperState.idle;
        }
        break;
    }

    return _currentState;
  }

  /// Reset FSM to idle
  void reset() {
    _currentState = ShopperState.idle;
  }
}
