// controllers/map_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapNotifier extends StateNotifier<LatLng?> {
  MapNotifier() : super(null);

  void updateLocation(LatLng newLocation) {
    state = newLocation;
  }
}
