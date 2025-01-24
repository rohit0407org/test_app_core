// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:flutter_esp_ble_prov/flutter_esp_ble_prov.dart';
//
// class ProvisioningScreen extends StatefulWidget {
//   const ProvisioningScreen({super.key});
//
//   @override
//   State<ProvisioningScreen> createState() => _ProvisioningScreenState();
// }
//
// class _ProvisioningScreenState extends State<ProvisioningScreen> {
//   final _flutterEspBleProvPlugin = FlutterEspBleProv();
//
//   final defaultPadding = 12.0;
//   final defaultDevicePrefix = 'STROM';
//
//   List<String> devices = [];
//   List<String> networks = [];
//
//   String selectedDeviceName = '';
//   String selectedSsid = '';
//   String feedbackMessage = '';
//
//   final prefixController = TextEditingController(text: 'PROV_');
//   final proofOfPossessionController = TextEditingController(text: 'abcd1234');
//   final passphraseController = TextEditingController();
//   final manualWifiNameController = TextEditingController();
//
//   Future scanBleDevices() async {
//     final prefix = prefixController.text;
//     setState(() {
//       devices = []; // Clear the devices array before scanning
//       devices.clear();
//     });
//     final scannedDevices = await _flutterEspBleProvPlugin.scanBleDevices(prefix);
//     print("these are scaned devbices ${scannedDevices}");
//     setState(() {
//       devices = scannedDevices;
//     });
//     pushFeedback('Success: scanned BLE devices');
//   }
//
//   Future scanWifiNetworks() async {
//     if (selectedDeviceName.isEmpty) {
//       pushFeedback('Error: No device selected');
//       return;
//     }
//     final proofOfPossession = proofOfPossessionController.text;
//     final scannedNetworks = await _flutterEspBleProvPlugin.scanWifiNetworks(
//         selectedDeviceName, proofOfPossession);
//     setState(() {
//       networks = scannedNetworks;
//     });
//     pushFeedback('Success: scanned WiFi on $selectedDeviceName');
//   }
//
//   Future provisionWifi() async {
//     if (selectedDeviceName.isEmpty || selectedSsid.isEmpty) {
//       pushFeedback('Error: No device or network selected');
//       return;
//     }
//     final proofOfPossession = proofOfPossessionController.text;
//     final passphrase = passphraseController.text;
//     await _flutterEspBleProvPlugin.provisionWifi(
//         selectedDeviceName, proofOfPossession, selectedSsid, passphrase);
//     pushFeedback('Success: provisioned WiFi $selectedDeviceName on $selectedSsid');
//   }
//
//   pushFeedback(String msg) {
//     setState(() {
//       feedbackMessage = '$feedbackMessage\n$msg';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('ESP BLE Provisioning Example'),
//           actions: [
//             // Refresh Button in AppBar
//
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 setState(() {
//                   devices.clear(); // Clear the devices array
//                   networks.clear(); // Clear the networks array
//                   selectedDeviceName = ''; // Reset selected device
//                   selectedSsid = ''; // Reset selected SSID
//                 });
//                 pushFeedback('Cleared devices and networks');
//               },
//             ),
//           ],
//         ),
//         bottomSheet: SafeArea(
//           child: Container(
//             width: double.infinity,
//             color: Colors.black87,
//             padding: EdgeInsets.all(defaultPadding),
//             child: SingleChildScrollView(
//               child: Text(
//                 feedbackMessage,
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.green.shade600),
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.all(defaultPadding),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextField(
//                     controller: prefixController,
//                     decoration: const InputDecoration(
//                       labelText: 'Device Prefix',
//                       hintText: 'Enter device prefix',
//                     ),
//                   ),
//                   SizedBox(height: defaultPadding),
//                   ElevatedButton(
//                     onPressed: scanBleDevices,
//                     child: const Text('Scan BLE Devices'),
//                   ),
//                   SizedBox(height: defaultPadding),
//                   const Text(
//                     'BLE Devices',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: defaultPadding),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: devices.length,
//                     itemBuilder: (context, i) {
//                       return ListTile(
//                         title: Text(
//                           devices[i],
//                           style: TextStyle(
//                             color: Colors.blue.shade700,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             selectedDeviceName = devices[i];
//                           });
//                           pushFeedback('Selected device: $selectedDeviceName');
//                         },
//                       );
//                     },
//                   ),
//                   SizedBox(height: defaultPadding),
//                   TextField(
//                     controller: proofOfPossessionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Proof of Possession',
//                       hintText: 'Enter proof of possession string',
//                     ),
//                   ),
//                   SizedBox(height: defaultPadding),
//                   ElevatedButton(
//                     onPressed: scanWifiNetworks,
//                     child: const Text('Scan Wi-Fi Networks'),
//                   ),
//                   SizedBox(height: defaultPadding),
//                   const Text(
//                     'Wi-Fi Networks',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: defaultPadding),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: networks.length,
//                     itemBuilder: (context, i) {
//                       return ListTile(
//                         title: Text(
//                           networks[i],
//                           style: TextStyle(
//                             color: Colors.green.shade700,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             selectedSsid = networks[i];
//                           });
//                           pushFeedback('Selected network: $selectedSsid');
//                         },
//                       );
//                     },
//                   ),
//                   SizedBox(height: defaultPadding),
//                   // Manual Wi-Fi Name Input Field
//                   TextField(
//                     controller: manualWifiNameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Manual Wi-Fi Name (SSID)',
//                       hintText: 'Enter Wi-Fi name if not detected',
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedSsid = value; // Update selectedSsid with manual input
//                       });
//                     },
//                   ),
//                   SizedBox(height: defaultPadding),
//                   TextField(
//                     controller: passphraseController,
//                     decoration: const InputDecoration(
//                       labelText: 'Wi-Fi Passphrase',
//                       hintText: 'Enter passphrase',
//                     ),
//                     obscureText: true,
//                   ),
//                   SizedBox(height: defaultPadding),
//                   ElevatedButton(
//                     onPressed: provisionWifi,
//                     child: const Text('Provision Wi-Fi'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }