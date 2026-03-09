import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/domain/usecases/create_update_delete_listing.dart';
import 'package:myapp/features/listings/domain/usecases/watch_listings.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_event.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final WatchListings watchListings;
  final CreateListing createListing;
  final UpdateListing updateListing;
  final DeleteListing deleteListing;

  StreamSubscription? _subscription;

  ListingsBloc({
    required this.watchListings,
    required this.createListing,
    required this.updateListing,
    required this.deleteListing,
  }) : super(ListingsState.initial()) {
    on<ListingsStarted>(_onStarted);
    on<ListingsSearchChanged>(_onSearchChanged);
    on<ListingsCategoryChanged>(_onCategoryChanged);
    on<ListingCreated>(_onListingCreated);
    on<ListingUpdated>(_onListingUpdated);
    on<ListingDeleted>(_onListingDeleted);
  }

  void _onStarted(ListingsStarted event, Emitter<ListingsState> emit) {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    _subscription?.cancel();
    _subscription = watchListings().listen((either) {
      either.fold(
        (failure) => addError(failure, StackTrace.current),
        (listings) {
          final next = state.copyWith(
            allListings: listings,
            isLoading: false,
            errorMessage: null,
          );
          final filtered = _applyFilters(
            listings: next.allListings,
            query: next.searchQuery,
            category: next.selectedCategory,
          );
          emit(next.copyWith(visibleListings: filtered));
        },
      );
    }, onError: (error, stackTrace) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ));
    });
  }

  void _onSearchChanged(
      ListingsSearchChanged event, Emitter<ListingsState> emit) {
    final filtered = _applyFilters(
      listings: state.allListings,
      query: event.query,
      category: state.selectedCategory,
    );
    emit(state.copyWith(
      searchQuery: event.query,
      visibleListings: filtered,
    ));
  }

  void _onCategoryChanged(
      ListingsCategoryChanged event, Emitter<ListingsState> emit) {
    final filtered = _applyFilters(
      listings: state.allListings,
      query: state.searchQuery,
      category: event.category,
    );
    emit(state.copyWith(
      selectedCategory: event.category,
      visibleListings: filtered,
    ));
  }

  Future<void> _onListingCreated(
      ListingCreated event, Emitter<ListingsState> emit) async {
    await createListing(event.listing);
  }

  Future<void> _onListingUpdated(
      ListingUpdated event, Emitter<ListingsState> emit) async {
    await updateListing(event.listing);
  }

  Future<void> _onListingDeleted(
      ListingDeleted event, Emitter<ListingsState> emit) async {
    await deleteListing(event.id);
  }

  List<Listing> _applyFilters({
    required List<Listing> listings,
    required String query,
    required String? category,
  }) {
    return listings.where((listing) {
      final matchesQuery = query.isEmpty ||
          listing.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          category == null || category.isEmpty || listing.category == category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

