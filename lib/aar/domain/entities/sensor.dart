class Sensor {
  final int id;
  final double oxygenLevel;
  final String? sensorType;
  final String status;
  final double temperatureLevel;
  final DateTime lastUpdate;

  Sensor({
    required this.id,
    required this.oxygenLevel,
    required this.sensorType,
    required this.status,
    required this.temperatureLevel,
    required this.lastUpdate,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      oxygenLevel: (json['oxygenLevel'] as num).toDouble(),
      sensorType: json['sensorType'],
      status: json['status'],
      temperatureLevel: (json['temperatureLevel'] as num).toDouble(),
      lastUpdate: DateTime.parse(json['last_update']),
    );
  }
}