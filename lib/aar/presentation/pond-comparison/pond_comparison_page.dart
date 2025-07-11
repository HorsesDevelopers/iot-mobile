import 'package:flutter/material.dart';
import '../../domain/entities/pond.dart';

class PondComparisonPage extends StatefulWidget {
  final List<Pond> ponds;
  const PondComparisonPage({super.key, required this.ponds});

  @override
  State<PondComparisonPage> createState() => _PondComparisonPageState();
}

class _PondComparisonPageState extends State<PondComparisonPage> {
  final Set<int> _selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final selectedPonds = _selectedIndexes.map((i) => widget.ponds[i]).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar Estanques'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            const Text(
              'Selecciona 2 o más estanques para comparar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.ponds.length,
                itemBuilder: (context, index) {
                  final pond = widget.ponds[index];
                  final selected = _selectedIndexes.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selectedIndexes.remove(index);
                        } else {
                          _selectedIndexes.add(index);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      width: 120,
                      decoration: BoxDecoration(
                        color: selected ? Colors.blueAccent.shade100 : Colors.white,
                        border: Border.all(
                          color: selected ? Colors.blue : Colors.grey.shade300,
                          width: selected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://cdn-icons-png.freepik.com/512/7006/7006177.png',
                            height: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pond.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pond.ubication,
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.compare),
              label: const Text('Comparar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: selectedPonds.length < 2
                  ? null
                  : () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => PondComparisonResult(ponds: selectedPonds),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PondComparisonResult extends StatelessWidget {
  final List<Pond> ponds;
  const PondComparisonResult({super.key, required this.ponds});

  int getFishCount(Pond pond) => pond.fishes.fold(0, (sum, fish) => sum + fish.quantity);

  @override
  Widget build(BuildContext context) {
    final attributes = [
      {'label': 'Nombre', 'icon': Icons.water, 'getter': (Pond p) => p.name, 'isNum': false},
      {'label': 'Ubicación', 'icon': Icons.location_on, 'getter': (Pond p) => p.ubication, 'isNum': false},
      {'label': 'Tipo de Agua', 'icon': Icons.opacity, 'getter': (Pond p) => p.waterType, 'isNum': false},
      {'label': 'Volumen (m³)', 'icon': Icons.square_foot, 'getter': (Pond p) => p.volume, 'isNum': true},
      {'label': 'Área (m²)', 'icon': Icons.aspect_ratio, 'getter': (Pond p) => p.area, 'isNum': true},
      {'label': 'Cantidad de Peces', 'icon': Icons.iso, 'getter': (Pond p) => getFishCount(p), 'isNum': true},
    ];

    Map<int, int> getMaxIndexes() {
      final map = <int, int>{};
      for (int i = 0; i < attributes.length; i++) {
        if (attributes[i]['isNum'] == true) {
          final getter = attributes[i]['getter'] as dynamic Function(Pond);
          final values = ponds.map((p) => getter(p) as num).toList();
          final max = values.reduce((a, b) => a > b ? a : b);
          map[i] = values.indexOf(max);
        }
      }
      return map;
    }

    final maxIndexes = getMaxIndexes();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Comparación de Estanques',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ponds.map((pond) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/616/616494.png',
                      height: 40,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pond.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )).toList(),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                columns: [
                  const DataColumn(label: SizedBox(width: 120, child: Text('Atributo', style: TextStyle(fontWeight: FontWeight.bold)))),
                  ...ponds.map((p) => DataColumn(label: SizedBox(width: 100, child: Center(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))))),
                ],
                rows: attributes.map((attr) {
                  final idx = attributes.indexOf(attr);
                  return DataRow(
                    cells: [
                      DataCell(Row(
                        children: [
                          Icon(attr['icon'] as IconData, size: 18, color: Colors.blueAccent),
                          const SizedBox(width: 6),
                          Text(attr['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                      ...ponds.asMap().entries.map((entry) {
                        final i = entry.key;
                        final pond = entry.value;
                        final getter = attr['getter'] as dynamic Function(Pond);
                        final value = getter(pond);
                        final isNum = attr['isNum'] == true;
                        final highlight = isNum && maxIndexes[idx] == i;
                        return DataCell(
                          Center(
                            child: Text(
                              isNum
                                  ? (value is int ? value.toString() : (value as double).toStringAsFixed(2))
                                  : value.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: highlight ? Colors.green : Colors.black,
                                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Cerrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}