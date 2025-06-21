import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  final String token;

  const AuthToken(this.token);

  @override
  List<Object?> get props => [token];
}