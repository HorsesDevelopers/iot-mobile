import 'package:dartz/dartz.dart';
import '../../../public/core/errors/exceptions.dart';
import '../../../public/core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/auth_token.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthToken>> signIn(String username, String password) async {
    try {
      final authResponse = await remoteDataSource.signIn(username, password);
      await localDataSource.saveToken(authResponse.token);
      return Right(authResponse.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String username, String password, List<String> roles) async {
    try {
      final userDto = await remoteDataSource.signUp(username, password, roles);
      return Right(userDto.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    await localDataSource.clearToken();
  }
}