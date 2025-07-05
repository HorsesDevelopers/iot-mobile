import 'dart:convert';
import '../../../public/core/errors/exceptions.dart';
import '../../../public/core/network/http_client_wrapper.dart';
import '../models/auth_response_dto.dart';
import '../models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> signIn(String username, String password);
  Future<UserDto> signUp(String username, String password, List<String> roles);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClientWrapper client;
  final String baseUrl = 'http://localhost:8091';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseDto> signIn(String username, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/authentication/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['token'] != null && jsonResponse['token'].isNotEmpty) {
          return AuthResponseDto.fromJson(jsonResponse);
        } else {
          throw ServerException(
            message: 'Invalid token in response',
            statusCode: response.statusCode,
          );
        }
      } catch (e) {
        throw ServerException(
          message: 'Error processing response: ${e.toString()}',
          statusCode: response.statusCode,
        );
      }
    } else {
      throw ServerException(
        message: 'Incorrect credentials',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserDto> signUp(String username, String password, List<String> roles) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/v1/authentication/sign-up'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'roles': roles,
        }),
      );
      print('Registration response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return UserDto.fromJson(jsonResponse);
      } else {
        String errorMessage = 'Registration error';
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['message'] ?? 'Registration error';
        } catch (_) {}

        throw ServerException(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Connection error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}