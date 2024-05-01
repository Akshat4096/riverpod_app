import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(MapState(null, false, null));

  void updateLocation(LatLng newLocation, bool isAddressSelected, LatLng? currentLocation) {
    state = MapState(newLocation, isAddressSelected, currentLocation);
  }
}

class MapState {
  final LatLng? location;
  final bool isAddressSelected;
  final LatLng? currentLocation;

  MapState(this.location, this.isAddressSelected, this.currentLocation);
}
