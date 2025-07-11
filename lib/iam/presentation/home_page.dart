import 'package:flutter/material.dart';
import 'package:mobile/aar/domain/infrastructure/SensorWebSocketPage.dart';
import 'package:mobile/sdp/presentation/device_page.dart';
import 'package:provider/provider.dart';
import '../../../iam/application/auth_provider.dart';
import '../../aar/domain/infrastructure/sensor_data_provider.dart';
import '../../oam/application/notification_provider.dart';
import '../../oam/presentation/pages/notifications_page.dart';
import '../../oam/presentation/widgets/notification_badge.dart';
import '../../common/sidebar/presentation/sidebar_drawer.dart';
import '../../sdp/domain/entities/sensor.dart';
import '../../common/infrastructure/api_constants.dart';
import '../../sdp/infrastructure/sensor_repository.dart';

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
        Navigator.of(context).pushReplacementNamed('/home');
      }
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.getNotifications();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sensores en tiempo real',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Consumer<SensorDataProvider>(
                  builder: (context, provider, _) {
                    final logs = provider.sensorLogs;
                    if (logs.isEmpty) {
                      return const Text('No hay datos de sensores en tiempo real');
                    }
                    final lastLogs = logs.reversed.take(3).toList();
                    return Column(
                      children: lastLogs.map((sensor) => ListTile(
                        leading: const Icon(Icons.sensors, color: Colors.green),
                        title: Text('Estanque: ${sensor['pondId'] ?? '-'} | Tipo: ${sensor['sensorType'] ?? '-'}'),
                        subtitle: Text('Valor: ${sensor['value'] ?? '-'} | Estado: ${sensor['status'] ?? '-'}'),
                        trailing: Text(sensor['timestamp']?.toString() ?? ''),
                      )).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
            _buildCard(
              title: 'My Ponds',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    'https://cdn-icons-png.freepik.com/512/7006/7006177.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ponds');
              },
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Devices',
              child: SizedBox(
                height: 70,
                child: FutureBuilder<List<Sensor>>(
                  future: SensorRepository(kBaseApiUrl).fetchSensors(
                    Provider.of<AuthProvider>(context, listen: false).token!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error al cargar sensores'));
                    }
                    final sensors = snapshot.data ?? [];
                    final activos = sensors.where((s) => s.status.toUpperCase() == 'ACTIVE').length;
                    final errores = sensors.where((s) => s.status.toUpperCase() == 'ERROR').length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSensorSummary(Icons.sensors, 'Total', sensors.length, Colors.blue),
                        _buildSensorSummary(Icons.check_circle, 'Activos', activos, Colors.green),
                        _buildSensorSummary(Icons.error, 'Error', errores, Colors.red),
                      ],
                    );
                  },
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SensorWebSocketPage()));
              },
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

  Widget _buildSensorSummary(IconData icon, String label, int count, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text('$count', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
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
                    if (provider.unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${provider.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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

  Widget _buildCard({required String title, required Widget child, required VoidCallback onPressed}) {
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
            onPressed: onPressed,
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

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'See Tasks') {
          Navigator.pushReplacementNamed(context, '/tasks');
        }
      },
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