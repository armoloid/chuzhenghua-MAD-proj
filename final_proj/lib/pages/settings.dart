import 'package:flutter/material.dart';
import '../database.dart';
import 'login.dart';
import 'about.dart';

class SettingsView extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const SettingsView({super.key, required this.onThemeChanged});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _showAboutPage = false;
  void _showVerifyPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    
    String actualPassword = '';
    try {
      final userMap = GlobalData.users.firstWhere(
        (u) => u['email'] == GlobalData.currentUser, 
        orElse: () => {'pass': ''}
      );
      actualPassword = userMap['pass'] ?? '';
    } catch (e) {
      actualPassword = '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verify"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please enter your current password to continue."),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password", 
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == actualPassword) {
                Navigator.pop(context);
                _showEditProfileDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Incorrect password!"), 
                    backgroundColor: Colors.red
                  ),
                );
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
  void _showEditProfileDialog(BuildContext context) {
    String currentName = GlobalData.userHouseData[GlobalData.currentUser]?['displayName'] ?? 'User';
    String currentEmail = GlobalData.currentUser ?? '';
    
    String currentPass = '';
    try {
      final userMap = GlobalData.users.firstWhere(
        (u) => u['email'] == GlobalData.currentUser, 
        orElse: () => {'pass': ''}
      );
      currentPass = userMap['pass'] ?? '';
    } catch (e) {
      currentPass = '';
    }

    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    final passController = TextEditingController(text: currentPass);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Display Name", prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passController,
                decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                String oldEmail = GlobalData.currentUser!;
                String newEmail = emailController.text;

                if (GlobalData.userHouseData[oldEmail] != null) {
                   GlobalData.userHouseData[oldEmail]!['displayName'] = nameController.text;
                }

                final userIndex = GlobalData.users.indexWhere((u) => u['email'] == oldEmail);
                
                if (userIndex != -1) {
                  GlobalData.users[userIndex]['pass'] = passController.text;

                  if (newEmail != oldEmail && newEmail.isNotEmpty) {
                    var houseData = GlobalData.userHouseData[oldEmail];
                    if (houseData != null) {
                      GlobalData.userHouseData[newEmail] = houseData;
                      GlobalData.userHouseData.remove(oldEmail);
                    }

                    GlobalData.users[userIndex]['email'] = newEmail;

                    GlobalData.currentUser = newEmail;
                  }
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showAboutPage) {
      return AboutView(
        onBack: () {
          setState(() {
            _showAboutPage = false;
          });
        },
      );
    }

    String userEmail = GlobalData.currentUser ?? "Not Logged In";
    String displayName = GlobalData.userHouseData[GlobalData.currentUser]?['displayName'] ?? 'User';

    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(displayName),
          accountEmail: Text(userEmail),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40),
          ),
        ),
        
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text("About the App"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            setState(() {
              _showAboutPage = true; 
            });
          },
        ),

        SwitchListTile(
            secondary: Icon(
                GlobalData.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: GlobalData.isDarkMode ? Colors.amber : Colors.grey),
            title: const Text("Dark Mode"),
            value: GlobalData.isDarkMode,
            onChanged: (bool value) {
              setState(() {
                GlobalData.isDarkMode = value;
              });
              widget.onThemeChanged();
            }),

        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text("Edit Profile"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showVerifyPasswordDialog(context),
        ),
        
        const Spacer(),
        
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout", style: TextStyle(color: Colors.red)),
          onTap: () {
            GlobalData.currentUser = null;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(onThemeChanged: widget.onThemeChanged)));
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}