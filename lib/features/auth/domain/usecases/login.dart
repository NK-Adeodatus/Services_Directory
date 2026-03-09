import 'package:dartz/dartz.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Exception, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}
