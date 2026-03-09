import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_state.dart';
import 'package:myapp/features/listings/presentation/pages/listing_detail_page.dart';
import 'package:myapp/features/listings/presentation/pages/listing_form_page.dart';

class MyListingsPage extends StatelessWidget {
  const MyListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Center(
            child: Text(
              'Log in to manage your listings.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return BlocBuilder<ListingsBloc, ListingsState>(
          builder: (context, listingsState) {
            final myListings = listingsState.allListings
                .where((l) => l.createdBy == authState.user.uid)
                .toList();

            if (myListings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You have no listings yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ListingFormPage(currentUserId: authState.user.uid),
                          ),
                        );
                      },
                      child: const Text('Create Listing'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: myListings.length,
              itemBuilder: (context, index) {
                final listing = myListings[index];
                return _MyListingCard(listing: listing);
              },
            );
          },
        );
      },
    );
  }
}

class _MyListingCard extends StatelessWidget {
  final Listing listing;

  const _MyListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF012A4A),
      child: ListTile(
        title: Text(
          listing.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          listing.address,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ListingDetailPage(listing: listing),
            ),
          );
        },
      ),
    );
  }
}

