import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/infrastructure/api_constants.dart';
import '../../../iam/application/auth_provider.dart';

class CreatePondPage extends StatefulWidget {
  const CreatePondPage({super.key});

  @override
  State<CreatePondPage> createState() => _CreatePondPageState();
}

class _CreatePondPageState extends State<CreatePondPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ubicationController = TextEditingController();
  final TextEditingController waterTypeController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  bool _isLoading = false;

  Future<void> createPond({
    required String token,
    required String ubication,
    required String name,
    required String waterType,
    required double volume,
    required double area,
  }) async {
    final response = await http.post(
      Uri.parse('$kBaseApiUrl/api/v1/ponds'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ubication': ubication,
        'name': name,
        'waterType': waterType,
        'volume': volume,
        'area': area,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el estanque: ${response.statusCode} - ${response.body}');
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Estanque'),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Nuevo Estanque',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: _inputDecoration('Nombre del Estanque', Icons.water),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ubicationController,
                    decoration: _inputDecoration('Ubicación', Icons.location_on),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: waterTypeController,
                    decoration: _inputDecoration('Tipo de Agua', Icons.opacity),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: volumeController,
                    decoration: _inputDecoration('Volumen (m³)', Icons.square_foot),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: areaController,
                    decoration: _inputDecoration('Área (m²)', Icons.aspect_ratio),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 28),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Estanque', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final token = authProvider.token;
                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No autenticado')),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      try {
                        await createPond(
                          token: token,
                          ubication: ubicationController.text,
                          name: nameController.text,
                          waterType: waterTypeController.text,
                          volume: double.tryParse(volumeController.text) ?? 0,
                          area: double.tryParse(areaController.text) ?? 0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Estanque creado exitosamente')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
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