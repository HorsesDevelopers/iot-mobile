import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int id;
  final String message;
  final String title;
  final DateTime createdAt;
  final bool read;

  const Notification({
    required this.id,
    required this.message,
    required this.title,
    required this.createdAt,
    required this.read,
  });

  @override
  List<Object?> get props => [id, message, title, createdAt, read];
}