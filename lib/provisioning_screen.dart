import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/esp_provisioning_wifi_bloc.dart';
import 'bloc/esp_provisioning_wifi_state.dart';

class ProvisioningScreen extends StatelessWidget {
  const ProvisioningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provisioning'),
      ),
      body: BlocConsumer<ProvisioningBloc, ProvisioningState>(
        listener: (context, state) {
          if (state is WifiProvisioned) {
            // Show snackbar when provisioning is successful
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wi-Fi provisioned successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back to the BLE device list screen
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is ProvisioningError) {
            // Show snackbar for errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WifiProvisioning) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Provisioning in progress...'),
                ],
              ),
            );
          } else  if(state is ProvisioningError){
            return Center(child: Text('${state.message}'));
          }
          return SizedBox();
        },
      ),
    );
  }
}