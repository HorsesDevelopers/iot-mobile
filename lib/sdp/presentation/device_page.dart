import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../common/infrastructure/api_constants.dart';
import '../../iam/application/auth_provider.dart';
import '../domain/entities/sensor.dart';
import '../infrastructure/sensor_repository.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late Future<List<Sensor>> _sensorsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;
      setState(() {
        _sensorsFuture = SensorRepository(kBaseApiUrl).fetchSensors(token!);
      });
    });
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.green;
      case 'ERROR':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores'),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: FutureBuilder<List<Sensor>>(
        future: _sensorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final sensors = snapshot.data ?? [];
          if (sensors.isEmpty) {
            return const Center(child: Text('No hay sensores disponibles.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sensors.length,
            itemBuilder: (context, index) {
              final sensor = sensors[index];
              final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.tryParse(sensor.lastUpdate) ?? DateTime.now());
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.sensors, size: 40, color: Colors.blueAccent),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${sensor.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text('Tipo: ${sensor.sensorType ?? '-'}'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text('Estado: '),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _statusColor(sensor.status).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    sensor.status,
                                    style: TextStyle(
                                      color: _statusColor(sensor.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.water_drop, size: 18, color: Colors.lightBlue),
                                const SizedBox(width: 4),
                                Text('Oxígeno: ${sensor.oxygenLevel}'),
                                const SizedBox(width: 16),
                                const Icon(Icons.thermostat, size: 18, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text('Temp: ${sensor.temperatureLevel}°C'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Última actualización: $formattedDate', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}