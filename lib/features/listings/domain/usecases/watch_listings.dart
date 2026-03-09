import 'package:dartz/dartz.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/domain/repositories/listings_repository.dart';

class WatchListings {
  final ListingsRepository repository;

  WatchListings(this.repository);

  Stream<Either<Exception, List<Listing>>> call() {
    return repository.watchAllListings();
  }
}

