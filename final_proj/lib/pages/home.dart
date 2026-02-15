import 'package:flutter/material.dart';
import '../database.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    int totalOn = GlobalData.currentDevices.where((d) => d['isOn'] == true).length;
    int totalDevices = GlobalData.currentDevices.length;
    List<Map<String, dynamic>> favorites =
        GlobalData.currentDevices.where((d) => d['isFav'] == true).toList().cast<Map<String, dynamic>>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _statCard("Devices On", "$totalOn / $totalDevices", Icons.power,
                Colors.green),
            const SizedBox(width: 10),
            _statCard("Room temp", "24°C", Icons.thermostat, Colors.red),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("Favorites",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        if (favorites.isEmpty)
          const Center(
              child:
                  Text("No favorites yet! Star a device in the Devices tab.")),
        ...favorites
            .map((device) => Card(
                  child: SwitchListTile(
                    title: Text(device['name']),
                    value: device['isOn'] ?? false,
                    onChanged: (v) => setState(() => device['isOn'] = v),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _statCard(String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(val,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
