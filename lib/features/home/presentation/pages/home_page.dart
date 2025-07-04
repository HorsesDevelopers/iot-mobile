import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/application/auth_provider.dart';
import '../../../notifications/application/notification_provider.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';
import '../../../sidebar/presentation/sidebar_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          NotificationBadge(),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              title: 'My Ponds',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    'https://i.imgur.com',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    'https://i.imgur.com',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Devices',
              child: Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    _buildDeviceRow('TQ-0001', 'Optimal'),
                    _buildDeviceRow('TQ-0002', 'Error'),
                    _buildDeviceRow('TQ-0003', 'Error'),
                    _buildDeviceRow('TQ-0004', 'Optimal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildNotificationsCard(context),
            const SizedBox(height: 20),
            _buildActionButton('See Tasks'),
            const SizedBox(height: 10),
            _buildActionButton('Download Report'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      provider.status == NotificationStatus.loading
                          ? 'Cargando notificaciones...'
                          : 'Tienes ${provider.unreadCount} notificaciones',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  ).then((_) {
                    // Actualizar al regresar
                    provider.getNotifications();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                ),
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String id, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id),
          Text(status),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.shade100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}