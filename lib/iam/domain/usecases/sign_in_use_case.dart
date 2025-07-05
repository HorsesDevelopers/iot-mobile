import 'package:dartz/dartz.dart';
import '../../../common/core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import '../value_objects/auth_token.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, AuthToken>> execute(String username, String password) {
    return repository.signIn(username, password);
  }
}