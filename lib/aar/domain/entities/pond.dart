import 'package:equatable/equatable.dart';

class Pond extends Equatable {
  final int id;
  final String name;
  final String ubication;
  final String waterType;
  final List<Fish> fishes;
  final double volume;
  final double area;
  final DateTime createdAt;

  const Pond({
    required this.id,
    required this.name,
    required this.ubication,
    required this.waterType,
    required this.fishes,
    required this.volume,
    required this.area,
    required this.createdAt,
  });

  factory Pond.fromJson(Map<String, dynamic> json) {
    return Pond(
      id: json['id'],
      name: json['name'],
      ubication: json['ubication'],
      waterType: json['waterType'],
      fishes: (json['fishes'] as List<dynamic>?)
          ?.map((f) => Fish.fromJson(f))
          .toList() ?? [],
      volume: (json['volume'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ubication': ubication,
    'waterType': waterType,
    'fishes': fishes.map((f) => f.toJson()).toList(),
    'volume': volume,
    'area': area,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, ubication, waterType, fishes, volume, area, createdAt];
}

class Fish extends Equatable {
  final int id;
  final String type;
  final int quantity;
  final int pondId;
  final DateTime createdAt;

  const Fish({
    required this.id,
    required this.type,
    required this.quantity,
    required this.pondId,
    required this.createdAt,
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'],
      type: json['type'],
      quantity: json['quantity'],
      pondId: json['pondId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'quantity': quantity,
    'pondId': pondId,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, type, quantity, pondId, createdAt];
}