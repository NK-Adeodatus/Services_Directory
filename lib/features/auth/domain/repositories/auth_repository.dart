import 'package:dartz/dartz.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';


abstract class AuthRepository {
  Future<Either<Exception, User>> login(String email, String password);
  Future<Either<Exception, void>> signup(String email, String password);
  Future<Either<Exception, void>> logout();
  Future<Either<Exception, User>> getCurrentUser();
}
