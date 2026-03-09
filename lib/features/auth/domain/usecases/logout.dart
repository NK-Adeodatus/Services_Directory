import 'package:dartz/dartz.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<Either<Exception, void>> call() {
    return repository.logout();
  }
}
