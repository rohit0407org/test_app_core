import 'package:equatable/equatable.dart';

abstract class ProvisioningState extends Equatable {
  const ProvisioningState();

  @override
  List<Object> get props => [];
}

class ProvisioningInitial extends ProvisioningState {}

class BLEScanning extends ProvisioningState {}

class BLEScanned extends ProvisioningState {
  final List<String> devices;

  const BLEScanned(this.devices);

  @override
  List<Object> get props => [devices];
}

class BLEError extends ProvisioningState {
  final String message;

  const BLEError(this.message);

  @override
  List<Object> get props => [message];
}

class DeviceChosen extends ProvisioningState {
  final String selectedDevice;

  const DeviceChosen(this.selectedDevice);

  @override
  List<Object> get props => [selectedDevice];
}

class WifiScanning extends ProvisioningState {
  final String selectedDevice;

  const WifiScanning(this.selectedDevice);

  @override
  List<Object> get props => [selectedDevice];
}

class WifiScanned extends ProvisioningState {
  final String selectedDevice;
  final List<String> networks;

  const WifiScanned(this.selectedDevice, this.networks);

  @override
  List<Object> get props => [selectedDevice, networks];
}

class WifiError extends ProvisioningState {
  final String message;

  const WifiError(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkChosen extends ProvisioningState {
  final String selectedDevice;
  final String selectedNetwork;

  const NetworkChosen(this.selectedDevice, this.selectedNetwork);

  @override
  List<Object> get props => [selectedDevice, selectedNetwork];
}

class WifiProvisioning extends ProvisioningState {
  final String selectedDevice;
  final String selectedNetwork;

  const WifiProvisioning(this.selectedDevice, this.selectedNetwork);

  @override
  List<Object> get props => [selectedDevice, selectedNetwork];
}

class WifiProvisioned extends ProvisioningState {}

class ProvisioningError extends ProvisioningState {
  final String message;

  const ProvisioningError(this.message);

  @override
  List<Object> get props => [message];
}