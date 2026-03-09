import 'package:dartz/dartz.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, User>> login(String email, String password) async {
    try {
      final firebaseUser = await remoteDataSource.login(email, password);
      if (!firebaseUser.emailVerified) {
        return Left(Exception('Please verify your email before logging in.'));
      }
      return Right(UserModel.fromFirebaseUser(firebaseUser));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> signup(String email, String password) async {
    try {
      await remoteDataSource.signup(email, password);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null && user.emailVerified) {
        return Right(UserModel.fromFirebaseUser(user));
      }
      return Left(Exception('User not found or email not verified'));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
