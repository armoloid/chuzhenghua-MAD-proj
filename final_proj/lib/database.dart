import 'package:flutter/material.dart';

class GlobalData {
  static String? currentUser;
  static bool isDarkMode = false;

  static List<Map<String, String>> users = [
    {"email": "user@gmail.com", "pass": "1234"},
  ];

  static Map<String, Map<String, dynamic>> userHouseData = {
    "user@gmail.com": {
      "devices": <Map<String, dynamic>>[
        {
          "name": "Main Lamp",
          "room": "Living Room",
          "isOn": true,
          "isFav": true
        },
      ],
      "rooms": <String>["Living Room"],
      "presets": <Map<String, dynamic>>[],
    }
  };

  static List<Map<String, dynamic>> get currentDevices {
    final data = userHouseData[currentUser];
    if (data == null || data['devices'] == null) return [];
    return List<Map<String, dynamic>>.from(data['devices']);
  }

  static List<String> get currentRooms {
    final data = userHouseData[currentUser];
    if (data == null || data['rooms'] == null) return ["Living Room"];
    return List<String>.from(data['rooms']);
  }

  static List<dynamic> get currentPresets => 
    GlobalData.userHouseData[GlobalData.currentUser]?['presets'] ?? [];
}
