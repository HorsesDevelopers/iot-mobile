import 'package:flutter/material.dart';
import '../domain/entities/sensor.dart';
import '../infrastructure/sensor_repository.dart';

class SensorProvider extends ChangeNotifier {
  final SensorRepository repository;
  List<Sensor> sensors = [];
  bool loading = false;

  SensorProvider(this.repository);

  Future<void> loadSensors(String token) async {
    loading = true;
    notifyListeners();
    sensors = await repository.fetchSensors(token);
    loading = false;
    notifyListeners();
  }
}