import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/entities/sensor.dart';

class SensorRepository {
  final String baseUrl;

  SensorRepository(this.baseUrl);

  Future<List<Sensor>> fetchSensors(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/sensors'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Sensor.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar sensores');
    }
  }
}