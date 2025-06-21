import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              title: 'My Ponds',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    'https://i.imgur.com/YOUR_IMAGE1.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    'https://i.imgur.com/YOUR_IMAGE2.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Devices',
              child: Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    _buildDeviceRow('TQ-0001', 'Optimal'),
                    _buildDeviceRow('TQ-0002', 'Error'),
                    _buildDeviceRow('TQ-0003', 'Error'),
                    _buildDeviceRow('TQ-0004', 'Optimal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Notifications',
              child: Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.black),
                    SizedBox(width: 8),
                    Text('You have 3 notifications'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButton('See Tasks'),
            const SizedBox(height: 10),
            _buildActionButton('Download Report'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String id, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id),
          Text(status),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.shade100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
