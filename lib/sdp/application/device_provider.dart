import 'package:flutter/material.dart';
import '../domain/entities/device.dart';
import '../infrastructure/device_repository.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceRepository repository;
  List<Device> devices = [];
  bool loading = false;

  DeviceProvider(this.repository);

  Future<void> loadDevices() async {
    loading = true;
    notifyListeners();
    devices = await repository.fetchDevices();
    loading = false;
    notifyListeners();
  }
}