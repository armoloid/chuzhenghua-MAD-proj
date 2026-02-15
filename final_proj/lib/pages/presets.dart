import 'package:flutter/material.dart';
import '../database.dart';

class PresetsView extends StatefulWidget {
  const PresetsView({super.key});

  @override
  State<PresetsView> createState() => _PresetsViewState();
}

class _PresetsViewState extends State<PresetsView> {
  void _createPreset() {
    final TextEditingController nameController = TextEditingController();
    List<Map<String, dynamic>> selectionList =
        GlobalData.currentDevices.map((device) {
      return {
        "name": device['name'],
        "selected": false,
      };
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Create New Preset",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          labelText: "Preset Name")),
                  const SizedBox(height: 20),
                  const Text("Which devices should turn ON?",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const Divider(),

                  SizedBox(
                    height: 200, 
                    child: ListView(
                      children: selectionList.map((item) {
                        return CheckboxListTile(
                          title: Text(item['name']),
                          value: item['selected'],
                          onChanged: (bool? val) {
                            setModalState(() => item['selected'] = val!);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          List<String> selectedNames = selectionList
                              .where((item) => item['selected'] == true)
                              .map((item) => item['name'] as String)
                              .toList();

                          setState(() {
                            final List? presetList =
                                GlobalData.userHouseData[GlobalData.currentUser]
                                    ?['presets'];

                            if (presetList != null) {
                              presetList.add({
                                "name": nameController.text,
                                "icon": Icons.auto_awesome,
                                "color": Colors.blue,
                                "targetDevices": selectedNames,
                              }.cast<String,
                                  dynamic>());
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Save Preset"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.power_settings_new),
                label: const Text("All devices off",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () {
                  _showConfirmOffDialog();
                },
              ),
            ),
          ),

          const Divider(),

          Expanded(
            child: GlobalData.currentPresets.isEmpty
                ? const Center(child: Text("No custom presets yet."))
                : ListView.builder(
                    itemCount: GlobalData.currentPresets.length,
                    itemBuilder: (context, index) {
                      final preset = GlobalData.currentPresets[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: ListTile(
                          title: Text(preset['name']),
                          trailing: const Icon(Icons.play_arrow),
                          onTap: () {
                            setState(() {
                              List<dynamic> targets =
                                  preset['targetDevices'] ?? [];

                              final List devicesList = GlobalData.userHouseData[
                                  GlobalData.currentUser]!['devices'];

                              for (var device in devicesList) {
                                if (targets.contains(device['name'])) {
                                  device['isOn'] = true;
                                } else {
                                  device['isOn'] = false;
                                }
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("${preset['name']} activated!")),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPreset,
        label: const Text("Create Preset"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showConfirmOffDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Shut Down Everything?"),
        content:
            const Text("This will turn off every single device in the house."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                final List devicesList = GlobalData
                    .userHouseData[GlobalData.currentUser]!['devices'];

                for (var device in devicesList) {
                  device['isOn'] = false;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("All devices have been turned off.")),
              );
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
