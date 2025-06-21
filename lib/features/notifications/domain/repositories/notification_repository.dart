import 'package:dartz/dartz.dart';
import '../entities/notification.dart';
import '../../../../core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotifications();
}