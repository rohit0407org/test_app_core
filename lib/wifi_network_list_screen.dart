import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/esp_provisioning_wifi_bloc.dart';
import 'bloc/esp_provisioning_wifi_event.dart';
import 'bloc/esp_provisioning_wifi_state.dart';
import 'provisioning_screen.dart'; // Import the provisioning screen

class WifiNetworkListScreen extends StatefulWidget {
  const WifiNetworkListScreen({super.key});

  @override
  State<WifiNetworkListScreen> createState() => _WifiNetworkListScreenState();
}

class _WifiNetworkListScreenState extends State<WifiNetworkListScreen> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Wi-Fi Network'),
      ),
      body: BlocBuilder<ProvisioningBloc, ProvisioningState>(
        builder: (context, state) {
          if (state is DeviceChosen) {
            // Start Wi-Fi scan when the screen loads
            context.read<ProvisioningBloc>().add(ScanWifiNetworks('abcd1234'));
            return const Center(child: CircularProgressIndicator());
          } else if (state is WifiScanning) {
            return const Center(child: Text('Scanning for Wi-Fi networks...'));
          } else if (state is WifiScanned) {
            return Column(
              children: [
                // Display the selected device
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Selected Device: ${state.selectedDevice}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // List of Wi-Fi networks
                Expanded(
                  child: ListView.builder(
                    itemCount: state.networks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.networks[index]),
                        onTap: () {
                          // Auto-fill the SSID field when a network is selected
                          _ssidController.text = state.networks[index];

                          // // Dispatch the ChooseNetwork event
                          // context.read<ProvisioningBloc>().add(
                          //   ChooseNetwork(state.networks[index]),
                          // );
                        },
                      );
                    },
                  ),
                ),
                // SSID and Password Input Fields
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _ssidController,
                        decoration: const InputDecoration(
                          labelText: 'Wi-Fi SSID',
                          hintText: 'Enter Wi-Fi SSID',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Wi-Fi Password',
                          hintText: 'Enter Wi-Fi password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final ssid = _ssidController.text.trim();
                          final password = _passwordController.text.trim();

                          if (ssid.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid SSID.'),
                              ),
                            );
                            return;
                          }
                          context.read<ProvisioningBloc>().add(ChooseNetwork(ssid));
                          // Trigger Wi-Fi provisioning
                          context.read<ProvisioningBloc>().add(
                            ProvisionWifi(
                              'abcd1234', // Proof of possession
                              ssid, // SSID
                              password, // Password
                            ),
                          );

                          // Navigate to the provisioning screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProvisioningScreen(),
                            ),
                          );
                        },
                        child: const Text('Connect to Wi-Fi'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }else if(state is NetworkChosen){

          } else if (state is ProvisioningError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if(state is WifiError) {
            return const Center(child: Text('WIFI ERROR'));
          }
          return SizedBox();
        },
      ),
    );
  }
}