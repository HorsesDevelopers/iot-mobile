import '../../domain/entities/user.dart';

class UserDto {
  final String username;
  final List<String> roles;

  UserDto({required this.username, required this.roles});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    if (json['username'] != null) {
      return UserDto(
        username: json['username'],
        roles: json['roles'] != null
            ? List<String>.from(json['roles'])
            : [],
      );
    } else if (json['user'] != null && json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      return UserDto(
        username: user['username'] ?? '',
        roles: user['roles'] != null
            ? List<String>.from(user['roles'])
            : [],
      );
    }

    return UserDto(
      username: json.toString(),
      roles: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'roles': roles,
    };
  }

  User toDomain() => User(username: username, roles: roles);
}