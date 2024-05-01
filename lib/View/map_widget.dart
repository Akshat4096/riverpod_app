  // views/map_widget.dart
  import 'dart:developer';

import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:geocoding/geocoding.dart';

  import '../Controller/map_notifier.dart';
  import '../Model/map_location.dart';
  import 'map_screen.dart';

  final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) => MapNotifier());

  final isAddressSelectedProvider = StateProvider<bool>((ref) => false);

  class MapWidget extends ConsumerWidget {
    const MapWidget({super.key});


    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final mapState = ref.watch(mapProvider);
      final selectedLocation = mapState.location;
      final isAddressSelected = mapState.isAddressSelected;

      void _onTap(LatLng location) {
        ref.read(mapProvider.notifier).updateLocation(location, mapState.isAddressSelected, mapState.currentLocation);
      }
      void _addOrUseAddress(BuildContext context, WidgetRef ref) async {
        if (mapState.isAddressSelected) {
          print('Selected Address: ${mapState.location?.latitude}, ${mapState.location?.longitude}');
        } else {
          final selectedLocation = mapState.location;
          final currentLocation = mapState.currentLocation;
          if (selectedLocation != null) {
            List<Placemark> placemarks = await placemarkFromCoordinates(selectedLocation.latitude, selectedLocation.longitude);
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
              ref.read(mapProvider.notifier).updateLocation(selectedLocation, false, currentLocation);
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
              if (mapState.currentLocation != null)
                Marker(
                  markerId: MarkerId('current'),
                  position : mapState.currentLocation! ,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
            },
          ),
          if (mapState.location != null)
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
                  '${mapState.location!.latitude}, ${mapState.location!.longitude}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 10,
            child: ElevatedButton(
              onPressed: () =>_addOrUseAddress(context , ref),
              child: Text(mapState.isAddressSelected ? 'Use this Address' : 'Add Address'),
            ),
          ),
        ],
      );
    }

  }
