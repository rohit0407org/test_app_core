


abstract class ProvisioningEvent {}

class ScanBLEDevices extends ProvisioningEvent {
  final String prefix;

  ScanBLEDevices(this.prefix);
}

class ChooseDevice extends ProvisioningEvent {
  final String deviceName;

  ChooseDevice(this.deviceName);
}

class ScanWifiNetworks extends ProvisioningEvent {
  final String proofOfPossession;

  ScanWifiNetworks(this.proofOfPossession);
}

class ChooseNetwork extends ProvisioningEvent {
  final String networkName;

  ChooseNetwork(this.networkName);
}

class ProvisionWifi extends ProvisioningEvent {
  final String proofOfPossession;
  final String ssid;
  final String passphrase;

  ProvisionWifi(this.proofOfPossession, this.ssid, this.passphrase);
}