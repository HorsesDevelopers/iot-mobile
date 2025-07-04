class Device {
  final String id;
  final String alert;
  final String detail;
  final DeviceStatus status;

  Device({
    required this.id,
    required this.alert,
    required this.detail,
    required this.status,
  });
}

enum DeviceStatus { optimal, error }

extension DeviceStatusExtension on DeviceStatus {
  String get label {
    switch (this) {
      case DeviceStatus.optimal:
        return 'Óptimo';
      case DeviceStatus.error:
        return 'Error';
    }
  }
}
