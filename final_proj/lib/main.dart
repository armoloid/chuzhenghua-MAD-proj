import 'package:flutter/material.dart';
import 'database.dart'; 
import 'nav.dart'; 
import 'pages/login.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void refreshApp() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: GlobalData.isDarkMode ? ThemeMode.dark : ThemeMode.light, 
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: LoginPage(onThemeChanged: refreshApp), 
    );
  }
}