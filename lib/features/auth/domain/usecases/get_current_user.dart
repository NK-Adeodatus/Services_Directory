import 'package:dartz/dartz.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Exception, User>> call() {
    return repository.getCurrentUser();
  }
}
