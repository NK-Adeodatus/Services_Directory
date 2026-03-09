import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_event.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_state.dart';
import 'package:myapp/features/listings/presentation/pages/listing_detail_page.dart';
import 'package:myapp/features/listings/presentation/pages/listing_form_page.dart';

class DirectoryPage extends StatelessWidget {
  const DirectoryPage({super.key});

  static const _categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListingsBloc, ListingsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message != null && message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
      child: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (context, state) {
          return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a service',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  context
                      .read<ListingsBloc>()
                      .add(ListingsSearchChanged(value));
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((category) {
                  final selected = (category == 'All' &&
                          (state.selectedCategory == null ||
                              state.selectedCategory!.isEmpty)) ||
                      state.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) {
                        context.read<ListingsBloc>().add(
                              ListingsCategoryChanged(
                                category == 'All' ? null : category,
                              ),
                            );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.visibleListings.isEmpty
                      ? const Center(
                          child: Text(
                            'No listings yet.',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.visibleListings.length,
                          itemBuilder: (context, index) {
                            final listing = state.visibleListings[index];
                            return _ListingCard(listing: listing);
                          },
                        ),
            ),
          ],
        );
        },
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Listing listing;

  const _ListingCard({required this.listing});

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
          '${listing.category} • ${listing.address}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
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

class DirectoryFloatingActionButton extends StatelessWidget {
  const DirectoryFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ListingFormPage(
                  currentUserId: state.user.uid,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}

