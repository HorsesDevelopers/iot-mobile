import 'package:flutter/material.dart';

class CreatePondPage extends StatelessWidget {
  const CreatePondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController fishController = TextEditingController();
    final TextEditingController sensorsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Pond'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Pond Name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fishController,
              decoration: const InputDecoration(
                labelText: 'Number of Fish',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: sensorsController,
              decoration: const InputDecoration(
                labelText: 'Number of Sensors',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la lógica de creación
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pond Created')),
                );
                Navigator.pop(context); // Volver a la lista
              },
              child: const Text('Create Pond'),
            ),
          ],
        ),
      ),
    );
  }
}
