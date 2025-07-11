import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

import '../../../common/infrastructure/api_constants.dart';
import 'sensor_data_provider.dart';

class SensorWebSocketPage extends StatefulWidget {
  const SensorWebSocketPage({super.key});

  @override
  State<SensorWebSocketPage> createState() => _SensorWebSocketPageState();
}

class _SensorWebSocketPageState extends State<SensorWebSocketPage> {
  StompClient? stompClient;

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: '$kBaseApiUrl/ws',
        onConnect: onConnect,
        onWebSocketError: (error) => print('WebSocket error: $error'),
      ),
    );
    stompClient!.activate();
  }

  void onConnect(StompFrame frame) {
    stompClient!.subscribe(
      destination: '/topic/sensors',
      callback: (StompFrame message) {
        final data = json.decode(message.body!);
        final provider = Provider.of<SensorDataProvider>(context, listen: false);
        if (data is List) {
          provider.addSensorDataList(List<Map<String, dynamic>>.from(data));
        } else {
          provider.addSensorData(Map<String, dynamic>.from(data));
        }
      },
    );
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de Sensores en Tiempo Real')),
      body: Consumer<SensorDataProvider>(
        builder: (context, provider, _) {
          final sensorLogs = provider.sensorLogs;
          return ListView.builder(
            itemCount: sensorLogs.length,
            itemBuilder: (context, index) {
              final sensor = sensorLogs[index];
              return ListTile(
                title: Text('Estanque: ${sensor['pondId'] ?? '-'} | Tipo: ${sensor['sensorType'] ?? '-'}'),
                subtitle: Text('Valor: ${sensor['value'] ?? '-'} | Estado: ${sensor['status'] ?? '-'}'),
                trailing: Text(sensor['timestamp']?.toString() ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}