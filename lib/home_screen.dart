import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ble_device_list_screen.dart'; // For handling permissions

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP Provisioning'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BLEDeviceListScreen(),
              ),
            );
          },
          child: const Text('Start Provisioning'),
        ),
      ),
    );
  }
}