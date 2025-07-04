import 'package:flutter/material.dart';
import '../domain/entities/device.dart';

class DeviceProvider with ChangeNotifier {
  final List<Device> _devices = [
    Device(id: 'TQ-0001', alert: 'Alerta 1', detail: 'Lorem ipsum dolor sit amet...', status: DeviceStatus.optimal),
    Device(id: 'TQ-0002', alert: 'Alerta 2', detail: 'Lorem ipsum dolor sit amet...', status: DeviceStatus.error),
    Device(id: 'TQ-0003', alert: 'Alerta 3', detail: 'Lorem ipsum dolor sit amet...', status: DeviceStatus.error),
    Device(id: 'TQ-0004', alert: 'Alerta 4', detail: 'Lorem ipsum dolor sit amet...', status: DeviceStatus.optimal),
  ];

  List<Device> get devices => _devices;

  void calibrateAll() {
    for (var device in _devices) {
      device = Device(
        id: device.id,
        alert: device.alert,
        detail: device.detail,
        status: DeviceStatus.optimal,
      );
    }
    notifyListeners();
  }
}