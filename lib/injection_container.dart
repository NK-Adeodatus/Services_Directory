import 'package:get_it/get_it.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:myapp/features/auth/domain/usecases/get_current_user.dart';
import 'package:myapp/features/auth/domain/usecases/login.dart';
import 'package:myapp/features/auth/domain/usecases/logout.dart';
import 'package:myapp/features/auth/domain/usecases/signup.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/listings/data/datasources/listings_remote_data_source.dart';
import 'package:myapp/features/listings/data/repositories/listings_repository_impl.dart';
import 'package:myapp/features/listings/domain/repositories/listings_repository.dart';
import 'package:myapp/features/listings/domain/usecases/create_update_delete_listing.dart';
import 'package:myapp/features/listings/domain/usecases/watch_listings.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_event.dart';

final sl = GetIt.instance;

void init() {
  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      signup: sl(),
      logout: sl(),
      getCurrentUser: sl(),
    ),
  );

  sl.registerFactory(
    () => ListingsBloc(
      watchListings: sl(),
      createListing: sl(),
      updateListing: sl(),
      deleteListing: sl(),
    )..add(ListingsStarted()),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerLazySingleton(() => WatchListings(sl()));
  sl.registerLazySingleton(() => CreateListing(sl()));
  sl.registerLazySingleton(() => UpdateListing(sl()));
  sl.registerLazySingleton(() => DeleteListing(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ListingsRepository>(
    () => ListingsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ListingsRemoteDataSource>(
    () => ListingsRemoteDataSourceImpl(),
  );
}
