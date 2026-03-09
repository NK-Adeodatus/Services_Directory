import 'package:dartz/dartz.dart';
import 'package:myapp/features/listings/data/datasources/listings_remote_data_source.dart';
import 'package:myapp/features/listings/data/models/listing_model.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/domain/repositories/listings_repository.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  final ListingsRemoteDataSource remoteDataSource;

  ListingsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Exception, List<Listing>>> watchAllListings() async* {
    try {
      await for (final models in remoteDataSource.watchAllListings()) {
        yield Right<Exception, List<Listing>>(models);
      }
    } catch (e) {
      if (e is Exception) {
        yield Left<Exception, List<Listing>>(e);
      } else {
        yield Left<Exception, List<Listing>>(Exception(e.toString()));
      }
    }
  }

  @override
  Future<Either<Exception, void>> createListing(Listing listing) async {
    try {
      await remoteDataSource.createListing(_toModel(listing));
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> updateListing(Listing listing) async {
    try {
      await remoteDataSource.updateListing(_toModel(listing));
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> deleteListing(String id) async {
    try {
      await remoteDataSource.deleteListing(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  ListingModel _toModel(Listing listing) {
    return ListingModel(
      id: listing.id,
      name: listing.name,
      category: listing.category,
      address: listing.address,
      contactNumber: listing.contactNumber,
      description: listing.description,
      latitude: listing.latitude,
      longitude: listing.longitude,
      createdBy: listing.createdBy,
      timestamp: listing.timestamp,
    );
  }
}

