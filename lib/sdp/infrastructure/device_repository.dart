import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/entities/device.dart';

class DeviceRepository {
  final String baseUrl;

  DeviceRepository(this.baseUrl);

  Future<List<Device>> fetchDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/fogs'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Device.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar dispositivos');
    }
  }
}