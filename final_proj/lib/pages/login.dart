import 'package:flutter/material.dart';
import '../nav.dart';
import '../database.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const LoginPage({super.key, required this.onThemeChanged});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() {
    String inputEmail = _userController.text.trim();

    bool isValid = GlobalData.users.any(
        (u) => u['email'] == inputEmail && u['pass'] == _passController.text);

    if (isValid) {
      GlobalData.currentUser = inputEmail;

      if (!GlobalData.userHouseData.containsKey(inputEmail)) {
        GlobalData.userHouseData[inputEmail] = {
          "displayName": "User",
          "devices": <Map<String, dynamic>>[],
          "rooms": <String>["Living Room"],
          "presets": <Map<String, dynamic>>[],
        };
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationMenu(
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid login!")),
      );
    }
  }

  void _showRegisterDialog() {
    final regEmail = TextEditingController();
    final regPass = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Register Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: regEmail,
                decoration: const InputDecoration(labelText: "New Email")),
            TextField(
                controller: regPass,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (regEmail.text.isNotEmpty && regPass.text.isNotEmpty) {
                setState(() {
                  GlobalData.users.add(
                      {"email": regEmail.text.trim(), "pass": regPass.text});

                  GlobalData.userHouseData[regEmail.text.trim()] = {
                    "devices": <Map<String, dynamic>>[],
                    "rooms": <String>["Living Room"],
                    "presets": <Map<String, dynamic>>[],
                  };
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Account Created! Log in to start your hub.")),
                );
              }
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.blue),
            const SizedBox(height: 30),
            TextField(
                controller: _userController,
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(
                controller: _passController,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
                obscureText: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _handleLogin, child: const Text("Login")),
            ),
            TextButton(
                onPressed: _showRegisterDialog,
                child: const Text("Register for an account")),
          ],
        ),
      ),
    );
  }
}
