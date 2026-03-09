import 'package:dartz/dartz.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/domain/repositories/listings_repository.dart';

class CreateListing {
  final ListingsRepository repository;

  CreateListing(this.repository);

  Future<Either<Exception, void>> call(Listing listing) {
    return repository.createListing(listing);
  }
}

class UpdateListing {
  final ListingsRepository repository;

  UpdateListing(this.repository);

  Future<Either<Exception, void>> call(Listing listing) {
    return repository.updateListing(listing);
  }
}

class DeleteListing {
  final ListingsRepository repository;

  DeleteListing(this.repository);

  Future<Either<Exception, void>> call(String id) {
    return repository.deleteListing(id);
  }
}

