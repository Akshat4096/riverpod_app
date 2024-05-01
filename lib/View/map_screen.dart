// views/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_app/View/save_address_screen.dart';

import '../Model/map_location.dart';
import 'map_widget.dart';

final currentLocationProvider = FutureProvider.autoDispose<LatLng>((ref) async {
  final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(position.latitude, position.longitude);
});


final savedLocationsProvider =
StateProvider<List<MapLocation>>((ref) => []);

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  void navigateToMap(BuildContext context, LatLng? selectedLocation) {
    Navigator.pop(context, selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location-Tracker'),
      ),
      body: MapWidget(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Saved Addresses'),
              onTap: () async {
                // Navigate to the saved addresses screen and wait for a result
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SavedAddressesScreen()),
                );
                // Pass the selected location back to the map screen
                navigateToMap(context, selectedLocation);
              },
            ),
          ],
        ),
      ),
    );
  }

}
