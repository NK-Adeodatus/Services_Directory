import 'package:equatable/equatable.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';

class ListingsState extends Equatable {
  final List<Listing> allListings;
  final List<Listing> visibleListings;
  final String searchQuery;
  final String? selectedCategory;
  final bool isLoading;
  final String? errorMessage;

  const ListingsState({
    required this.allListings,
    required this.visibleListings,
    required this.searchQuery,
    required this.selectedCategory,
    required this.isLoading,
    required this.errorMessage,
  });

  factory ListingsState.initial() {
    return const ListingsState(
      allListings: [],
      visibleListings: [],
      searchQuery: '',
      selectedCategory: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  ListingsState copyWith({
    List<Listing>? allListings,
    List<Listing>? visibleListings,
    String? searchQuery,
    String? selectedCategory,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ListingsState(
      allListings: allListings ?? this.allListings,
      visibleListings: visibleListings ?? this.visibleListings,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allListings,
        visibleListings,
        searchQuery,
        selectedCategory,
        isLoading,
        errorMessage,
      ];
}

