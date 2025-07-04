import 'package:flutter/material.dart';
import '../../domain/entities/device.dart';

class StatusBadge extends StatelessWidget {
  final DeviceStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == DeviceStatus.optimal ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
