import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/device_provider.dart';
import '../../domain/entities/device.dart';
import '../widgets/status_badge.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.black12),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(2.5),
              3: FlexColumnWidth(1.2),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Colors.black12),
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('Alerts', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('Detail', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              ...deviceProvider.devices.map((device) {
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.all(8), child: Text(device.id)),
                    Padding(padding: const EdgeInsets.all(8), child: Text(device.alert)),
                    Padding(padding: const EdgeInsets.all(8), child: Text(device.detail)),
                    Padding(padding: const EdgeInsets.all(8), child: StatusBadge(status: device.status)),
                  ],
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              deviceProvider.calibrateAll();
            },
            child: const Text('Calibrate all'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          )
        ],
      ),
    );
  }
}
