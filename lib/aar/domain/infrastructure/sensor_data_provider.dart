import 'package:flutter/material.dart';

class SensorDataProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _sensorLogs = [];

  List<Map<String, dynamic>> get sensorLogs => List.unmodifiable(_sensorLogs);

  void addSensorData(Map<String, dynamic> data) {
    _sensorLogs.add(data);
    notifyListeners();
  }

  void addSensorDataList(List<Map<String, dynamic>> dataList) {
    _sensorLogs.addAll(dataList);
    notifyListeners();
  }

  void clear() {
    _sensorLogs.clear();
    notifyListeners();
  }
}