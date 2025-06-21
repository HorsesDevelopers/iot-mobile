import '../../domain/entities/notification.dart';

class NotificationDto {
  final int id;
  final String title;
  final String description;

  NotificationDto({
    required this.id,
    required this.title,
    required this.description,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Notification toDomain() {
    return Notification(
      id: id,
      title: title,
      message: description,
      createdAt: DateTime.now(),
      read: false,
    );
  }
}