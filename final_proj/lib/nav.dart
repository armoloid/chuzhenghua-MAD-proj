import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/devices.dart';
import 'pages/presets.dart';
import 'pages/settings.dart';

class NavigationMenu extends StatefulWidget {
  final VoidCallback onThemeChanged; 
  const NavigationMenu({super.key, required this.onThemeChanged});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}
class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void updateTheme() {
    setState(() {});
  }

  final List<String> _titles = ["Home", "Devices", "Presets", "Settings"];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeView(),
      const DevicesView(),
      const PresetsView(),
      SettingsView(onThemeChanged: widget.onThemeChanged), 
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Devices"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome), label: "Presets"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
