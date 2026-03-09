import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';

class ListingModel extends Listing {
  const ListingModel({
    required super.id,
    required super.name,
    required super.category,
    required super.address,
    required super.contactNumber,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.createdBy,
    super.timestamp,
  });

  factory ListingModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final timestamp = data['timestamp'];
    return ListingModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? '',
      address: data['address'] as String? ?? '',
      contactNumber: data['contactNumber'] as String? ?? '',
      description: data['description'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
      createdBy: data['createdBy'] as String? ?? '',
      timestamp: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
    };
  }
}

