// lib/aar/domain/entities/pond.dart
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

  @override
  List<Object?> get props => [id, type, quantity, pondId, createdAt];
}