import 'package:flutter/material.dart';
import '../database.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  int _viewMode = 0;
  String? _selectedRoom;

  void _showAddDeviceDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Device"),
        content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Device Name")),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  final List? devicesList = GlobalData
                      .userHouseData[GlobalData.currentUser]?['devices'];

                  if (devicesList != null) {
                    devicesList.add({
                      "name": nameController.text,
                      "room": null,
                      "isOn": false,
                      "isFav": false
                    }.cast<String, dynamic>());
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showCreateRoomDialog() {
    final roomController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Room"),
        content: TextField(
            controller: roomController,
            decoration: const InputDecoration(hintText: "Room Name")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (roomController.text.isNotEmpty) {
                setState(() {
                  GlobalData.userHouseData[GlobalData.currentUser]!['rooms']
                      .add(roomController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ungrouped = GlobalData.currentDevices
        .where((d) => d['room'] == null)
        .toList()
        .cast<Map<String, dynamic>>();

    return Scaffold(
      body: Column(
        
        children: [
          if (_selectedRoom == null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _topButton("Rooms", _viewMode == 0, () {
                  setState(() {
                    _viewMode = 0;
                    _selectedRoom =
                        null;
                  });
                }),
                const SizedBox(width: 8),
                _topButton("Ungrouped", _viewMode == 1, () {
                  setState(() {
                    _viewMode = 1;
                    _selectedRoom =
                        null;
                  });
                }),
                const SizedBox(width: 8),
                _topButton("All", _viewMode == 2, () {
                  setState(() {
                    _viewMode = 2;
                    _selectedRoom =
                        null;
                  });
                }),
              ],
            ),
          ),
          Expanded(child: _buildCurrentView(ungrouped)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _viewMode == 2 ? _showAddDeviceDialog : _showCreateRoomDialog,
        child: Icon(_viewMode == 2 ? Icons.add : Icons.add_home_work),
      ),
    );
  }

  Widget _buildCurrentView(List<Map<String, dynamic>> ungrouped) {
    if (_selectedRoom != null) {
      return _buildRoomDetailContent(_selectedRoom!);
    }

    if (_viewMode == 0) return _buildRoomList();
    if (_viewMode == 1) return _buildUngroupedList(ungrouped);
    return _buildAllDevicesList();
  }

  Widget _buildAllDevicesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: GlobalData.currentDevices.length,
      itemBuilder: (context, index) {
        final device = GlobalData.currentDevices[index];
        return Card(
          child: SwitchListTile(
            secondary: Icon(Icons.circle,
                color: (device['isOn'] ?? false) ? Colors.green : Colors.grey),
            title: Text(device['name']),
            subtitle: Row(
              children: [
                Text(device['room'] ?? "Unassigned"),
                const Spacer(),
                IconButton(
                  icon: Icon(
                      (device['isFav'] ?? false)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange),
                  onPressed: () => setState(
                      () => device['isFav'] = !(device['isFav'] ?? false)),
                ),
              ],
            ),
            value: device['isOn'] ?? false,
            onChanged: (v) => setState(() => device['isOn'] = v),
          ),
        );
      },
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      itemCount: GlobalData.currentRooms.length,
      itemBuilder: (context, index) {
        String roomName = GlobalData.currentRooms[index];
        return ListTile(
          title: Text(roomName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() {
              _selectedRoom = roomName;
            });
          },
        );
      },
    );
  }

  Widget _buildUngroupedList(List<Map<String, dynamic>> devices) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(devices[index]['name']),
          subtitle: const Text("Tap to assign room"),
          onTap: () async {
            String? selectedRoom = await showDialog<String>(
                context: context,
                builder: (context) => SimpleDialog(
                      title: const Text('Select a Room'),
                      children: GlobalData.currentRooms
                          .map((room) => SimpleDialogOption(
                                onPressed: () => Navigator.pop(context, room),
                                child: Text(room),
                              ))
                          .toList(),
                    ));

            if (selectedRoom != null) {
              setState(() => devices[index]['room'] = selectedRoom);
            }
          },
        );
      },
    );
  }

  Widget _topButton(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isActive ? Colors.blue : Colors.grey[200],
          foregroundColor: isActive ? Colors.white : Colors.black,
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildRoomDetailContent(String roomName) {
    final devices = GlobalData.currentDevices
        .where((d) => d['room'] == roomName)
        .toList()
        .cast<Map<String, dynamic>>();

    return Column(
      
      children: [
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedRoom = null),
          ),
          title: Text(roomName,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return Card(
                child: SwitchListTile(
                  title: Text(device['name']),
                  value: device['isOn'] ?? false,
                  onChanged: (v) => setState(() => device['isOn'] = v),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RoomDetailPage extends StatefulWidget {
  final String roomName;
  final List<Map<String, dynamic>> devices;
  const RoomDetailPage(
      {super.key, required this.roomName, required this.devices});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomName)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.devices.length,
        itemBuilder: (context, index) {
          final device = widget.devices[index];
          return Card(
            child: SwitchListTile(
              secondary: Icon(Icons.circle,
                  color:
                      (device['isOn'] ?? false) ? Colors.green : Colors.grey),
              title: Text(device['name']),
              value: device['isOn'] ?? false,
              onChanged: (bool value) => setState(() => device['isOn'] = value),
              subtitle: Row(
                children: [
                  const Text("Favorite: "),
                  IconButton(
                    icon: Icon(
                        (device['isFav'] ?? false)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.orange),
                    onPressed: () => setState(
                        () => device['isFav'] = !(device['isFav'] ?? false)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
