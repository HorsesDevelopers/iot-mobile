import 'package:flutter/material.dart';
import '../../domain/entities/pond.dart';

class PondCard extends StatelessWidget {
  final Pond pond;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate; // Nuevo callback

  const PondCard({
    super.key,
    required this.pond,
    this.onDelete,
    this.onUpdate, // Nuevo parámetro
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://cdn-icons-png.freepik.com/512/7006/7006177.png',
              height: 48,
            ),
            const SizedBox(height: 10),
            Text(
              pond.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.iso, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Peces: ${pond.fishes.fold(0, (sum, f) => sum + f.quantity)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.opacity, color: Colors.lightBlue, size: 20),
                const SizedBox(width: 6),
                Text(
                  pond.waterType,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            if (onDelete != null || onUpdate != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onUpdate != null)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      onPressed: onUpdate,
                      tooltip: 'Actualizar estanque',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}