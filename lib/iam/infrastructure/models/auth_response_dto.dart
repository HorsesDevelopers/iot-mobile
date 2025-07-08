import '../../domain/value_objects/auth_token.dart';

class AuthResponseDto {
  final String token;

  AuthResponseDto({required this.token});

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(token: json['token'] ?? '');
  }

  AuthToken toDomain() => AuthToken(token);
}