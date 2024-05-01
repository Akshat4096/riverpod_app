// views/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../Controller/map_notifier.dart';
import '../Model/map_location.dart';
import 'map_screen.dart';

final mapProvider = StateNotifierProvider<MapNotifier, LatLng?>((ref) => MapNotifier());

class MapWidget extends ConsumerWidget {
  const MapWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LatLng? selectedLocation = ref.watch(mapProvider);
    bool isAddressSelected = selectedLocation != null ;

    void _onTap(LatLng location) {
      ref.read(mapProvider.notifier).updateLocation(location);
    }


    void _addOrUseAddress(BuildContext context, WidgetRef ref) async {
      if (isAddressSelected) {
        // Use the selected address
        // Perform any action you want here with the selected location
        print('Selected Address: ${selectedLocation.latitude}, ${selectedLocation.longitude}');
      } else {
        // Add a new address
        final selectedLocation = ref.watch(mapProvider);
        final currentLocation = ref.read(currentLocationProvider).asData;

        if (selectedLocation != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              selectedLocation.latitude, selectedLocation.longitude);
          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks[0];
            String address =
                '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
            final newLocation = MapLocation(
              location: selectedLocation,
              address: address,
            );
            ref.read(savedLocationsProvider).add(newLocation);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Address added successfully.'),
            ));
          }
        }
      }
    }
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {},
          onTap: _onTap,
          initialCameraPosition:CameraPosition(
            target: LatLng(0, 0),
            zoom: 13,
          ),
          markers: {
            if (selectedLocation != null)
              Marker(markerId: MarkerId('selected'), position: selectedLocation),
            if (ref.watch(currentLocationProvider).asData != null)
              Marker(
                markerId: MarkerId('current'),
                position: ref.watch(currentLocationProvider).asData!.value ?? LatLng(0, 0),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
          },
        ),
        if (selectedLocation != null)
          Positioned(
            top: 50,
            left: 5,
            right: 5,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${selectedLocation.latitude}, ${selectedLocation.longitude}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

        Positioned(
          bottom: 20,
          left: 10,
          child: ElevatedButton(
            onPressed: () =>_addOrUseAddress(context , ref),
            child: Text(isAddressSelected ? 'Use this address' : 'Add Address'),
          ),
        ),
      ],
    );
  }

}
