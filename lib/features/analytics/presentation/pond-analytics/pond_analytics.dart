import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PondStatsPage extends StatelessWidget {
  PondStatsPage({super.key});

  // Simulamos datos de ponds
  final List<_PondData> pondData = [
    _PondData('River Pond', 10),
    _PondData('Home Pond', 3),
    _PondData('Lake Pond', 8),
  ];

  // Simulamos KPIs
  //Nivel promedio de oxigeno
  final double averageOxygenLevel = 5.8;
  //Valor promedio de turbidez
  final double ntu = 30.5;
  //KPIs de temperatura
  double averageTemperatureLevel = 10;
  double maximumDailyTemperature = 12;
  double minimumDailyTemperature = 5;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pond Statistics'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Fish Count per Pond',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: pondData.map((pond) {
                    return BarChartGroupData(
                      x: pondData.indexOf(pond),
                      barRods: [
                        BarChartRodData(
                          toY: pond.fishCount.toDouble(),
                          color: Colors.redAccent,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= pondData.length) return Container();
                          return Text(
                            pondData[index].name,
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // KPIs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKPI(
                  title: 'Average Oxygen Level',
                  value: '${averageOxygenLevel.toStringAsFixed(1)} mg/L',
                  icon: Icons.water,
                ),
                _buildKPI(
                  title: 'Turbidity',
                  value: '${ntu.toStringAsFixed(1)} NTU',
                  icon: Icons.waves,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPI({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class _PondData {
  final String name;
  final int fishCount;

  _PondData(this.name, this.fishCount);
}
