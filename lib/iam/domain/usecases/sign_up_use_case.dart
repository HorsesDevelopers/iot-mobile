import 'package:dartz/dartz.dart';
import '../../../public/core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, User>> execute(String username, String password, List<String> roles) {
    return repository.signUp(username, password, roles);
  }
}