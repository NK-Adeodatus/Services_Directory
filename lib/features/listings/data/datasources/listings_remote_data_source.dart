import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/listings/data/models/listing_model.dart';

abstract class ListingsRemoteDataSource {
  Stream<List<ListingModel>> watchAllListings();
  Future<void> createListing(ListingModel listing);
  Future<void> updateListing(ListingModel listing);
  Future<void> deleteListing(String id);
}

class ListingsRemoteDataSourceImpl implements ListingsRemoteDataSource {
  final FirebaseFirestore _firestore;

  ListingsRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('listings');

  @override
  Stream<List<ListingModel>> watchAllListings() {
    return _collection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(ListingModel.fromDocument).toList());
  }

  @override
  Future<void> createListing(ListingModel listing) async {
    await _collection.add(listing.toMap());
  }

  @override
  Future<void> updateListing(ListingModel listing) async {
    await _collection.doc(listing.id).update(listing.toMap());
  }

  @override
  Future<void> deleteListing(String id) async {
    await _collection.doc(id).delete();
  }
}

