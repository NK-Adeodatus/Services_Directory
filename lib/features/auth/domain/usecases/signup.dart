import 'package:dartz/dartz.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<Either<Exception, void>> call(String email, String password) {
    return repository.signup(email, password);
  }
}
