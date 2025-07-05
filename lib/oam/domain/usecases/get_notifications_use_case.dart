import 'package:dartz/dartz.dart';
import '../../../public/core/errors/failures.dart';
import '../repositories/notification_repository.dart';
import '../entities/notification.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<Notification>>> execute() {
    return repository.getNotifications();
  }
}