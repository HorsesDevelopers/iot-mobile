import 'package:flutter/material.dart';

import '../../domain/entities/pond.dart';
import '../pond-comparison/pond_comparison_page.dart' as comparison;
import '../pond-create/pond_create.dart';
import '../pond-detail/pond_card_screen.dart' as detail;

class PondListScreen extends StatelessWidget {
  const PondListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Pond> ponds = [
      Pond(
        id: '1',
        name: 'River Pond',
        fish: 10,
        sensors: 5,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyXxzSWr0cei2ueRODd1cff6igFil93drvLQ&s',
      ),
      Pond(
        id: '2',
        name: 'Home Pond',
        fish: 3,
        sensors: 2,
        imageUrl: 'https://c8.alamy.com/comp/ET160H/goldfish-pond-dong-yang-palace-lu-residential-complex-imperial-palace-ET160H.jpg',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ponds'),
        backgroundColor: Colors.black87,
    ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Create Pond Button (just under the title)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePondPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade100,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Create Pond'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: ponds.length,
                itemBuilder: (context, index) {
                  final pond = ponds[index];
                  return detail.PondCard(
                    name: pond.name,
                    sensors: pond.sensors,
                    fish: pond.fish,
                    imageUrl: pond.imageUrl,
                    onDelete: () {
                      // Aquí tu lógica de borrado
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted ${pond.name}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCompareDialog(context, ponds),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade100,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Compare',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompareDialog(BuildContext context, List<Pond> ponds) {
  List<Pond> selected = [];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Select 2 Ponds to Compare'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: ponds.map((pond) {
                final isSelected = selected.contains(pond);
                return CheckboxListTile(
                  value: isSelected,
                  title: Text(pond.name),
                  onChanged: (value) {
                    setState(() {
                      if (value == true && selected.length < 2) {
                        selected.add(pond);
                      } else if (value == false) {
                        selected.remove(pond);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selected.length == 2
                  ? () {
                      Navigator.pop(context); // Cierra el diálogo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => comparison.PondComparisonPage(
                            pondA: selected[0],
                            pondB: selected[1],
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Compare'),
            ),
          ],
        );
      });
    },
  );
}

}