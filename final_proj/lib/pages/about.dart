import 'package:flutter/material.dart';
import 'feedback.dart';
import 'package:flutter/services.dart';

class AboutView extends StatelessWidget {
  final VoidCallback onBack;

  const AboutView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            title: const Text("Back to Settings",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text("Home Hub",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Company: HomeHub Pte. Ltd",
              style: TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          const Text("Developer: Zheng Hua", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 20),
          const Text("Description",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "The main objective is to create a single app that can manage all types of smart devices in a home to make it more convenient for smart home users. Other features include device history, which allows users to monitor when the device was used and for how long. Presets, for example, you set dim lighting for specific lights and turn off all other devices for a movie night preset and with a click of a button, it would load the preset that you previously saved before. Overview, which allows you to see statistics of your house such as how many devices are on, the temperature of the rooms and so on.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 30),
          const Text("Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text("Call us at 87651234"),
            subtitle: const Text("Hold to copy number"),
            onLongPress: () {
              Clipboard.setData(const ClipboardData(text: "+65 8765 1234"));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Phone number copied to clipboard!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text("Email"),
            subtitle: const Text("Send us your feedback"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
