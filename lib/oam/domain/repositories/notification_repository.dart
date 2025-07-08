import 'package:dartz/dartz.dart';
import '../../../common/core/errors/failures.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotifications();
}