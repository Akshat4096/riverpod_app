// views/saved_addresses_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_app/Model/map_location.dart';

import 'map_screen.dart';
import 'map_widget.dart';

final isAddressSelectedProvider = StateProvider<bool>((ref) => false);


class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<MapLocation> savedLocations = ref.watch(savedLocationsProvider);
    final LatLng? currentLocation = ref.watch(currentLocationProvider).asData?.value;
    final isAddressSelected = ref.watch(mapProvider).isAddressSelected  ;
    final selectedLocation = ref.watch(mapProvider).location;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
      ),
      body: ListView.builder(
        itemCount: savedLocations.length + 1,
        itemBuilder: (context, index) {
          if(index == savedLocations.length){
            return ListTile(
              title: Text('Current Address'),
              trailing: Icon(Icons.location_on, color: Colors.green),
            );
          }
          final location = savedLocations[index];
          return ListTile(
            onTap: () {
              ref.read(mapProvider.notifier).updateLocation(location.location! , true , currentLocation);
              Navigator.pop(context);
            },
            leading: Text('${index+1}'),
            title: Text(location.address),
            subtitle: Text('Latitude: ${location.location?.latitude}, Longitude: ${location.location?.longitude}'),
            trailing: currentLocation != null && location.location == currentLocation
                ? Text('Current Address', style: TextStyle(color: Colors.green))
                : null,
          );
        },
      ),
    );
  }
}
