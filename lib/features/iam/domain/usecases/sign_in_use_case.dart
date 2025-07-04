import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../value_objects/auth_token.dart';
import '../../../../core/errors/failures.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, AuthToken>> execute(String username, String password) {
    return repository.signIn(username, password);
  }
}