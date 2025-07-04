import 'package:flutter/material.dart';
import 'package:mobile/features/assets-and-resources/domain/entities/pond.dart';

class PondComparisonPage extends StatelessWidget {
  final Pond pondA;
  final Pond pondB;

  const PondComparisonPage({
    super.key,
    required this.pondA,
    required this.pondB,
  });

  @override
  Widget build(BuildContext context) {
    final moreFish = pondA.fish > pondB.fish ? pondA.name : pondB.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Ponds'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$moreFish has more fish!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    // Para pantallas grandes → lado a lado
                    return Row(
                      children: [
                        Expanded(child: PondCard(pond: pondA)),
                        const SizedBox(width: 16),
                        Expanded(child: PondCard(pond: pondB)),
                      ],
                    );
                  } else {
                    // Para pantallas pequeñas → uno sobre otro
                    return ListView(
                      children: [
                        PondCard(pond: pondA),
                        const SizedBox(height: 16),
                        PondCard(pond: pondB),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade100,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PondCard extends StatelessWidget {
  final Pond pond;

  const PondCard({super.key, required this.pond});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue.shade100, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Image.network(
              pond.imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  pond.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sensors, size: 16),
                    const SizedBox(width: 4),
                    Text('${pond.sensors} sensors'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.set_meal, size: 16),
                    const SizedBox(width: 4),
                    Text('${pond.fish} fish'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}