class Device {
  final String deviceId;
  final String sensorType;
  final String value;
  final String timestamp;
  final String status;

  Device({
    required this.deviceId,
    required this.sensorType,
    required this.value,
    required this.timestamp,
    required this.status,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    deviceId: json['device_Id'],
    sensorType: json['sensor_type'],
    value: json['value'],
    timestamp: json['timestamp'],
    status: json['status'],
  );
}