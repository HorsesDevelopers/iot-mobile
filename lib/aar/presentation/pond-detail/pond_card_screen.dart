import 'package:flutter/material.dart';

class PondCard extends StatelessWidget {
  final String name;
  final int sensors;
  final int fish;
  final String imageUrl;
  final VoidCallback onDelete;

  const PondCard({
    super.key,
    required this.name,
    required this.sensors,
    required this.fish,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue.shade100, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.sensors, size: 16),
                      const SizedBox(width: 4),
                      Text('$sensors sensors'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.set_meal, size: 16),
                      const SizedBox(width: 4),
                      Text('$fish fish'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}