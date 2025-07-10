import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../application/device_provider.dart';
import '../domain/entities/device.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'óptimo':
        return const Color(0xFF74EA86);
      case 'error':
        return const Color(0xFFEA7474);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Header
              Positioned(
                left: 0,
                top: 0,
                width: 412,
                height: 77,
                child: Container(
                  color: const Color(0xFF2C2F33),
                  child: Row(
                    children: [
                      const SizedBox(width: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 29),
                            width: 27,
                            height: 20,
                            child: Column(
                              children: [
                                Container(height: 3, color: Colors.white),
                                const SizedBox(height: 7),
                                Container(height: 3, color: Colors.white),
                                const SizedBox(height: 7),
                                Container(height: 3, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Título
              const Positioned(
                left: 140,
                top: 128,
                child: Text(
                  'Devices',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                left: 19,
                top: 175,
                width: 374,
                height: 599,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    itemCount: provider.devices.length,
                    itemBuilder: (context, i) {
                      final d = provider.devices[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Row(
                          children: [
                            // ID
                            SizedBox(
                              width: 49,
                              child: Text(
                                d.deviceId,
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Alert
                            SizedBox(
                              width: 66,
                              child: Text(
                                d.sensorType,
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Detail
                            Expanded(
                              child: Text(
                                d.value,
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Status
                            Container(
                              width: 96,
                              height: 34,
                              decoration: BoxDecoration(
                                color: _statusColor(d.status),
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                d.status,
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Botones
              Positioned(
                left: 87,
                top: 829,
                width: 238,
                height: 59,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(249, 59, 59, 0.57),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Calibrate all',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 108,
                top: 925,
                width: 197,
                height: 59,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(249, 59, 59, 0.57),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}