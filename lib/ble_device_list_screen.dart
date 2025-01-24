import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/esp_provisioning_wifi_bloc.dart';
import 'bloc/esp_provisioning_wifi_event.dart';
import 'bloc/esp_provisioning_wifi_state.dart';
import 'wifi_network_list_screen.dart'; // Import the Wi-Fi network list screen

class BLEDeviceListScreen extends StatefulWidget {
  const BLEDeviceListScreen({super.key});

  @override
  State<BLEDeviceListScreen> createState() => _BLEDeviceListScreenState();
}

class _BLEDeviceListScreenState extends State<BLEDeviceListScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically start BLE scan when the screen is opened
    // Delay the BLE scan until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the ProvisioningBloc and start the BLE scan
      context.read<ProvisioningBloc>().add(ScanBLEDevices('STROM_'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select BLE Device'),
      ),
      body: BlocConsumer<ProvisioningBloc, ProvisioningState>(
        listener: (context, state) {
          // Show SnackBar for errors
          if (state is ProvisioningError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BLEScanning) {
            return const Center(child: Text('Scanning for BLE devices...'));
          } else if (state is BLEScanned) {
            if(state.devices.isEmpty){
              return const Center(child: Text("Bluetooth Devices Not Found"));
            }
            return ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.devices[index], style: TextStyle(color: Colors.black)),
                  onTap: () {
                    // Navigate to Wi-Fi network list screen
                    context.read<ProvisioningBloc>().add(ChooseDevice(state.devices[index]));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WifiNetworkListScreen(),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Waiting to start BLE scan...'));
          }
        },
      ),
    );
  }
}