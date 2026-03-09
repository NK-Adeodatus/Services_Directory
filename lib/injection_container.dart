import 'package:get_it/get_it.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:myapp/features/auth/domain/usecases/get_current_user.dart';
import 'package:myapp/features/auth/domain/usecases/login.dart';
import 'package:myapp/features/auth/domain/usecases/logout.dart';
import 'package:myapp/features/auth/domain/usecases/signup.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';

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

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
}
