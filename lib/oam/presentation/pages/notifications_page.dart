// lib/features/oam/presentation/pages/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/notification_provider.dart';
import '../../domain/entities/notification.dart' as notification_entity;
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case NotificationStatus.loading:
              return const LoadingView(message: 'Cargando notificaciones...');

            case NotificationStatus.error:
              return ErrorView(
                message: provider.error ?? 'Error desconocido',
                onRetry: () => provider.getNotifications(),
              );

            case NotificationStatus.loaded:
              final notifications = provider.notifications;
              if (notifications.isEmpty) {
                return const Center(
                  child: Text('No tienes notificaciones'),
                );
              }

              return RefreshIndicator(
                onRefresh: () => provider.getNotifications(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationCard(notification);
                  },
                ),
              );

            default:
              return const Center(child: Text('Cargue notificaciones'));
          }
        },
      ),
    );
  }

  Widget _buildNotificationCard(notification_entity.Notification notification) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.read ? Colors.grey : Colors.deepPurple,
          child: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.message),
        trailing: Text(
          _formatDate(notification.createdAt),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}