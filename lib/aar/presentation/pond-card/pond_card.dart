import 'package:flutter/material.dart';
import '../../domain/entities/pond.dart';

class PondCard extends StatelessWidget {
  final Pond pond;
  final VoidCallback? onDelete;

  const PondCard({
    super.key,
    required this.pond,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(pond.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ubicación: ${pond.ubication}'),
            Text('Tipo de agua: ${pond.waterType}'),
            Text('Cantidad de peces: ${pond.fishes.length}'),
            Text('Volumen: ${pond.volume} m³'),
            Text('Área: ${pond.area} m²'),
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        )
            : null,
      ),
    );
  }
}