import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../value_objects/auth_token.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthToken>> signIn(String username, String password);
  Future<Either<Failure, User>> signUp(String username, String password, List<String> roles);
  Future<Either<Failure, User>> getCurrentUser();
  Future<void> signOut();
}