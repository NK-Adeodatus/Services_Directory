import 'package:equatable/equatable.dart';

class Listing extends Equatable {
  final String id;
  final String name;
  final String category;
  final String address;
  final String contactNumber;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime? timestamp;

  const Listing({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        address,
        contactNumber,
        description,
        latitude,
        longitude,
        createdBy,
        timestamp,
      ];
}

