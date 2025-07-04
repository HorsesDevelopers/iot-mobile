// lib/features/om/domain/usecases/get_notifications_use_case.dart
import 'package:dartz/dartz.dart';
import '../repositories/notification_repository.dart';
import '../entities/notification.dart';
import '../../../../core/errors/failures.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<Notification>>> execute() {
    return repository.getNotifications();
  }
}