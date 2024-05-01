import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation {
  final LatLng? location;
  final String address;

  MapLocation({required this.location, required this.address});
}