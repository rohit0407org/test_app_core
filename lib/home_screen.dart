import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ble_device_list_screen.dart'; // For handling permissions

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<void> _requestPermissions(BuildContext context) async {
    // Request necessary permissions (e.g., location, Bluetooth)
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Navigate to BLE device list screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BLEDeviceListScreen(),
        ),
      );
    } else {
      // Show error if permissions are denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissions are required to proceed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP Provisioning'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _requestPermissions(context),
          child: const Text('Start Provisioning'),
        ),
      ),
    );
  }
}