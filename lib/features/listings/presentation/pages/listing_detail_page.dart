import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_event.dart';
import 'package:myapp/features/listings/presentation/pages/listing_form_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingDetailPage extends StatelessWidget {
  final Listing listing;

  const ListingDetailPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final cameraPosition = CameraPosition(
      target: LatLng(listing.latitude, listing.longitude),
      zoom: 15,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(listing.name),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated &&
                  state.user.uid == listing.createdBy) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ListingFormPage(
                            existing: listing,
                            currentUserId: state.user.uid,
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      context
                          .read<ListingsBloc>()
                          .add(ListingDeleted(listing.id));
                      Navigator.of(context).pop();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: cameraPosition,
                  markers: {
                    Marker(
                      markerId: MarkerId(listing.id),
                      position: LatLng(listing.latitude, listing.longitude),
                      infoWindow: InfoWindow(title: listing.name),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              listing.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              listing.category,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    listing.address,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white70, size: 18),
                const SizedBox(width: 4),
                Text(
                  listing.contactNumber,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              listing.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchNavigation(listing),
                icon: const Icon(Icons.directions),
                label: const Text('Navigate with Google Maps'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchNavigation(Listing listing) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

