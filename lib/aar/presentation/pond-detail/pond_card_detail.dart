import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../common/infrastructure/api_constants.dart';
import '../../domain/entities/pond.dart';

class PondDetailScreen extends StatefulWidget {
  final Pond pond;

  const PondDetailScreen({super.key, required this.pond});

  @override
  State<PondDetailScreen> createState() => _PondDetailScreenState();
}

class _PondDetailScreenState extends State<PondDetailScreen> {
  late Pond pond;

  @override
  void initState() {
    super.initState();
    pond = widget.pond;
  }

  Future<void> _createFish(String type, int quantity, int pondId) async {
    final url = Uri.parse('$kBaseApiUrl/api/v1/fishes');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': type,
        'quantity': quantity,
        'pondId': pondId,
      }),
    );
  }

  Future<void> _fetchFishes() async {
    final url = Uri.parse('$kBaseApiUrl/api/v1/ponds/${pond.id}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pond = Pond.fromJson(data);
      });
    }
  }

  void _showAddFishDialog(BuildContext context, int pondId) {
    final _formKey = GlobalKey<FormState>();
    String fishType = '';
    int quantity = 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar pez'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tipo de pez'),
                validator: (value) => value == null || value.isEmpty ? 'Ingrese el tipo' : null,
                onSaved: (value) => fishType = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese la cantidad';
                  if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Cantidad inválida';
                  return null;
                },
                onSaved: (value) => quantity = int.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                await _createFish(fishType, quantity, pondId);
                Navigator.pop(context);
                await _fetchFishes();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fishCount = pond.fishes.fold(0, (sum, f) => sum + f.quantity);

    final sensors = [
      {'name': 'Sensor de pH', 'value': '7.2'},
      {'name': 'Sensor de Temperatura', 'value': '25°C'},
      {'name': 'Sensor de Oxígeno', 'value': '8.1 mg/L'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pond.name),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultTabController(
              length: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'https://cdn-icons-png.freepik.com/512/7006/7006177.png',
                          height: 80,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pond.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.blueAccent,
                    tabs: const [
                      Tab(text: 'Details'),
                      Tab(text: 'Fishes'),
                      Tab(text: 'Sensors'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Detalles
                        ListView(
                          children: [
                            Text('Nombre: ${pond.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Ubicación: ${pond.ubication}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Tipo de agua: ${pond.waterType}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Volumen: ${pond.volume} m³', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Área: ${pond.area} m²', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Cantidad de peces: $fishCount', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        // Peces
                        ListView(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar pez'),
                              onPressed: () {
                                _showAddFishDialog(context, pond.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...(
                                pond.fishes.isEmpty
                                    ? [const Text('No hay peces registrados')]
                                    : pond.fishes.map((f) => ListTile(
                                  leading: const Icon(Icons.iso, color: Colors.blueAccent),
                                  title: Text(f.type),
                                  trailing: Text('Cantidad: ${f.quantity}'),
                                ))
                            ),
                          ],
                        ),
                        // Sensores
                        ListView(
                          children: sensors.map((s) => ListTile(
                            leading: const Icon(Icons.sensors, color: Colors.green),
                            title: Text(s['name']!),
                            trailing: Text(s['value']!),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}