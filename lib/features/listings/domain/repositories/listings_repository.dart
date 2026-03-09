import 'package:dartz/dartz.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';

abstract class ListingsRepository {
  Stream<Either<Exception, List<Listing>>> watchAllListings();
  Future<Either<Exception, void>> createListing(Listing listing);
  Future<Either<Exception, void>> updateListing(Listing listing);
  Future<Either<Exception, void>> deleteListing(String id);
}

