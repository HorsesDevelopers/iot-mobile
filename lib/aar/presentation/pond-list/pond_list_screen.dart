import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile/aar/presentation/pond-comparison/pond_comparison_page.dart';
import 'package:mobile/aar/presentation/pond-detail/pond_card_detail.dart';
import 'package:provider/provider.dart';
import '../../../common/infrastructure/api_constants.dart';
import '../../../iam/application/auth_provider.dart';
import '../../domain/entities/pond.dart';
import '../pond-card/pond_card.dart';

class PondListScreen extends StatefulWidget {
  const PondListScreen({super.key});

  @override
  State<PondListScreen> createState() => _PondListScreenState();
}

class _PondListScreenState extends State<PondListScreen> {
  late Future<List<Pond>> _pondsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;
      setState(() {
        _pondsFuture = fetchPonds(token!);
      });
    });
  }

  Future<List<Pond>> fetchPonds(String token) async {
    final response = await http.get(
      Uri.parse('$kBaseApiUrl/api/v1/ponds'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
        return data.map((json) => Pond(
          id: json['id'],
          name: json['name'],
          ubication: json['ubication'],
          waterType: json['waterType'],
          fishes: (json['fishes'] as List).map((f) => Fish(
            id: f['id'],
            type: f['type'],
            quantity: f['quantity'],
            pondId: f['pondId'],
            createdAt: dateFormat.parse(f['createdAt']),
          )).toList(),
          volume: (json['volume'] as num).toDouble(),
          area: (json['area'] as num).toDouble(),
          createdAt: dateFormat.parse(json['createdAt']),
        )).toList();
      } else {
        throw Exception('El backend no devolvió una lista');
      }
    } else {
      throw Exception('Error al cargar los estanques: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ponds'),
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<Pond>>(
        future: _pondsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final ponds = snapshot.data ?? [];
          if (ponds.isEmpty) {
            return const Center(child: Text('No hay estanques'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ponds.length,
            itemBuilder: (context, index) {
              final pond = ponds[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PondDetailScreen(pond: pond),
                    ),
                  );
                },
                child: PondCard(
                  pond: pond,
                  onDelete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted ${pond.name}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'compare',
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.compare_arrows),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final token = authProvider.token;
              final ponds = await fetchPonds(token!);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PondComparisonPage(ponds: ponds),
                ),
              );
              setState(() {
                _pondsFuture = fetchPonds(token);
              });
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: Colors.redAccent.shade100,
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/pond-create');
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final token = authProvider.token;
              setState(() {
                _pondsFuture = fetchPonds(token!);
              });
            },
          ),
        ],
      ),
    );
  }
}