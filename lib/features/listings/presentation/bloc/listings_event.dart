import 'package:equatable/equatable.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';

abstract class ListingsEvent extends Equatable {
  const ListingsEvent();

  @override
  List<Object?> get props => [];
}

class ListingsStarted extends ListingsEvent {}

class ListingsSearchChanged extends ListingsEvent {
  final String query;

  const ListingsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ListingsCategoryChanged extends ListingsEvent {
  final String? category;

  const ListingsCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class ListingCreated extends ListingsEvent {
  final Listing listing;

  const ListingCreated(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingUpdated extends ListingsEvent {
  final Listing listing;

  const ListingUpdated(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingDeleted extends ListingsEvent {
  final String id;

  const ListingDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

