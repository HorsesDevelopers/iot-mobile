import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/core/errors/exceptions.dart';
import '../../../common/infrastructure/api_constants.dart';
import '../models/notification_dto.dart';
import '../../../iam/infrastructure/datasources/auth_local_data_source.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationDto>> getNotifications();
  Future<void> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource localDataSource;
  final baseUrl = '$kBaseApiUrl/api/v1';

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.localDataSource,
  });

  @override
  Future<List<NotificationDto>> getNotifications() async {
    try {
      final token = await localDataSource.getToken();

      final response = await client.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Respuesta notificaciones: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => NotificationDto.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Error obteniendo notificaciones',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Error obteniendo notificaciones: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await localDataSource.getToken();

      final response = await client.patch(
        Uri.parse('$baseUrl/oam/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Error marcando notificación como leída',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Error marcando notificación como leída: $e',
        statusCode: 500,
      );
    }
  }
}