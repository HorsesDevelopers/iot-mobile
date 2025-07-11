import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../common/infrastructure/api_constants.dart';
import 'sensor_data_provider.dart';

class SensorWebSocketService {
  static final SensorWebSocketService _instance = SensorWebSocketService._internal();
  factory SensorWebSocketService() => _instance;
  SensorWebSocketService._internal();

  StompClient? _client;
  bool _connected = false;

  void connect(BuildContext context) {
    if (_connected) return;
    _client = StompClient(
      config: StompConfig.SockJS(
        url: '$kBaseApiUrl/ws',
        onConnect: (frame) {
          _connected = true;
          _client!.subscribe(
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
        },
        onWebSocketError: (error) => print('WebSocket error: $error'),
      ),
    );
    _client!.activate();
  }

  void disconnect() {
    _client?.deactivate();
    _connected = false;
  }
}