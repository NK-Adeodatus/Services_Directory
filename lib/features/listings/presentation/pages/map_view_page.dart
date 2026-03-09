import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_state.dart';

class MapViewPage extends StatelessWidget {
  const MapViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingsBloc, ListingsState>(
      builder: (context, state) {
        if (state.allListings.isEmpty) {
          return const Center(
            child: Text(
              'No locations to show on the map yet.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final first = state.allListings.first;

        final cameraPosition = CameraPosition(
          target: LatLng(first.latitude, first.longitude),
          zoom: 13,
        );

        final markers = state.allListings
            .map(
              (listing) => Marker(
                markerId: MarkerId(listing.id),
                position: LatLng(listing.latitude, listing.longitude),
                infoWindow: InfoWindow(title: listing.name),
              ),
            )
            .toSet();

        return GoogleMap(
          initialCameraPosition: cameraPosition,
          markers: markers,
          myLocationButtonEnabled: false,
        );
      },
    );
  }
}

