import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esp_ble_prov/flutter_esp_ble_prov.dart';

import 'esp_provisioning_wifi_event.dart';
import 'esp_provisioning_wifi_state.dart';

class ProvisioningBloc extends Bloc<ProvisioningEvent, ProvisioningState> {
  final _flutterEspBleProvPlugin = FlutterEspBleProv();
  final Set<String> _provisionedDevices = {};

  ProvisioningBloc() : super(ProvisioningInitial()) {
    on<ScanBLEDevices>(_onScanBLEDevices);
    on<ChooseDevice>(_onChooseDevice);
    on<ScanWifiNetworks>(_onScanWifiNetworks);
    on<ChooseNetwork>(_onChooseNetwork);
    on<ProvisionWifi>(_onProvisionWifi);
  }

  Future<void> _onScanBLEDevices(
      ScanBLEDevices event, Emitter<ProvisioningState> emit) async {
    emit(BLEScanning());
    try {
      final devices = await _flutterEspBleProvPlugin.scanBleDevices(event.prefix);
      print("these are scanned devices $devices");
      final unprovisionedDevices = devices.where((device) => !_provisionedDevices.contains(device)).toList();

      emit(BLEScanned(unprovisionedDevices));
    } catch (e) {
      emit(BLEError('Failed to scan BLE devices: $e'));
    }
  }

  Future<void> _onChooseDevice(
      ChooseDevice event, Emitter<ProvisioningState> emit) async {
    emit(DeviceChosen(event.deviceName));
  }

  Future<void> _onScanWifiNetworks(
      ScanWifiNetworks event, Emitter<ProvisioningState> emit) async {
    final currentState = state;
    if (currentState is DeviceChosen) {
      emit(WifiScanning(currentState.selectedDevice));
      try {
        final networks = await _flutterEspBleProvPlugin.scanWifiNetworks(
            currentState.selectedDevice, event.proofOfPossession);
        emit(WifiScanned(currentState.selectedDevice, networks));
      } catch (e) {
        emit(WifiError('Failed to scan Wi-Fi networks: $e'));
      }
    } else {
      emit(WifiError('No device selected'));
    }
  }

  Future<void> _onChooseNetwork(
      ChooseNetwork event, Emitter<ProvisioningState> emit) async {
    final currentState = state;
    if (currentState is WifiScanned) {
      emit(NetworkChosen(currentState.selectedDevice, event.networkName));
    } else {
      emit(WifiError('No Wi-Fi networks scanned'));
    }
  }

  Future<void> _onProvisionWifi(
      ProvisionWifi event, Emitter<ProvisioningState> emit) async {
    final currentState = state;
    print("Trying to start provisioning...");
    print("Current State: $currentState");

    if (currentState is NetworkChosen) {
      print("Provisioning started for device: ${currentState.selectedDevice}");
      emit(WifiProvisioning(currentState.selectedDevice, currentState.selectedNetwork));

      try {
        // Call the provisionWifi function and await its result
        final bool? isProvisioned = await _flutterEspBleProvPlugin.provisionWifi(
          currentState.selectedDevice,
          event.proofOfPossession,
          event.ssid,
          event.passphrase,
        );

        // Check the result of the provisionWifi function
        if (isProvisioned == true) {
          _provisionedDevices.add(currentState.selectedDevice);
          print("Wi-Fi provisioned successfully!");
          emit(WifiProvisioned());
        } else {
          print("Wi-Fi provisioning failed.");
          emit(ProvisioningError('Failed to provision Wi-Fi: Device returned false'));
        }
      } catch (e) {
        print("Error during provisioning: $e");
        emit(ProvisioningError('Failed to provision Wi-Fi: $e'));
      }
    } else {
      print("No Wi-Fi network selected.");
      emit(ProvisioningError('No Wi-Fi network selected'));
    }
  }
}