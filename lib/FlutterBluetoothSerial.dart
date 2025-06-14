part of flutter_bluetooth_serial;

class FlutterBluetoothSerial {
  // Plugin
  static const String namespace = 'flutter_bluetooth_serial';

  static FlutterBluetoothSerial _instance = new FlutterBluetoothSerial._();

  static FlutterBluetoothSerial get instance => _instance;

  static final MethodChannel _methodChannel =
      const MethodChannel('$namespace/methods');

  // Function used as pairing request handler.
  Function? _pairingRequestHandler;

  FlutterBluetoothSerial._() {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'handlePairingRequest':
          if (_pairingRequestHandler != null) {
            return _pairingRequestHandler!(
                BluetoothPairingRequest.fromMap(call.arguments));
          }
          break;

        default:
          throw 'unknown common code method - not implemented';
      }
    });
  }

  /* Status */
  /// Checks is the Bluetooth interface avaliable on host device.
  Future<bool?> get isAvailable async =>
      await _methodChannel.invokeMethod('isAvailable');

  /// Describes is the Bluetooth interface enabled on host device.
  Future<bool?> get isEnabled async =>
      await _methodChannel.invokeMethod('isEnabled');

  /// Checks is the Bluetooth interface enabled on host device.
  @Deprecated('Use `isEnabled` instead')
  Future<bool?> get isOn async => await _methodChannel.invokeMethod('isOn');

  static final EventChannel _stateChannel =
      const EventChannel('$namespace/state');

  /// Allows monitoring the Bluetooth adapter state changes.
  Stream<BluetoothState> onStateChanged() => _stateChannel
      .receiveBroadcastStream()
      .map((data) => BluetoothState.fromUnderlyingValue(data));

  /// State of the Bluetooth adapter.
  Future<BluetoothState> get state async => BluetoothState.fromUnderlyingValue(
      await _methodChannel.invokeMethod('getState'));

  /// Returns the hardware address of the local Bluetooth adapter.
  ///
  /// Does not work for third party applications starting at Android 6.0.
  Future<String?> get address => _methodChannel.invokeMethod("getAddress");

  /// Returns the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// Does not work for third party applications starting at Android 6.0.
  Future<String?> get name => _methodChannel.invokeMethod("getName");

  /// Sets the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// Valid Bluetooth names are a maximum of 248 bytes using UTF-8 encoding,
  /// although many remote devices can only display the first 40 characters,
  /// and some may be limited to just 20.
  ///
  /// Does not work for third party applications starting at Android 6.0.
  Future<bool?> changeName(String name) =>
      _methodChannel.invokeMethod("setName", {"name": name});

  /* Adapter settings and general */
  /// Tries to enable Bluetooth interface (if disabled).
  /// Probably results in asking user for confirmation.
  Future<bool?> requestEnable() async =>
      await _methodChannel.invokeMethod('requestEnable');

  /// Tries to disable Bluetooth interface (if enabled).
  Future<bool?> requestDisable() async =>
      await _methodChannel.invokeMethod('requestDisable');

  /// Opens the Bluetooth platform system settings.
  Future<void> openSettings() async =>
      await _methodChannel.invokeMethod('openSettings');

  /* Discovering and bonding devices */
  /// Checks bond state for given address (might be from system cache).
  Future<BluetoothBondState> getBondStateForAddress(String address) async {
    return BluetoothBondState.fromUnderlyingValue(await _methodChannel
        .invokeMethod('getDeviceBondState', {"address": address}));
  }

  /// Starts outgoing bonding (pairing) with device with given address.
  /// Returns true if bonded, false if canceled or failed gracefully.
  ///
  /// `pin` or `passkeyConfirm` could be used to automate the bonding process,
  /// using provided pin or confirmation if necessary. Can be used only if no
  /// pairing request handler is already registered.
  ///
  /// Note: `passkeyConfirm` will probably not work, since 3rd party apps cannot
  /// get `BLUETOOTH_PRIVILEGED`

  // Add static forwarding methods for public API
  static Stream<BluetoothDiscoveryResult> startDiscovery() => instance._startDiscovery();
  static Future<List<BluetoothDevice>> getBondedDevices() => instance._getBondedDevices();
  static Future<bool?> bondDeviceAtAddress(String address, {String? pin, bool? passkeyConfirm}) => instance._bondDeviceAtAddress(address, pin: pin, passkeyConfirm: passkeyConfirm);
  static Future<bool?> removeDeviceBondWithAddress(String address) => instance._removeDeviceBondWithAddress(address);
  static void setPairingRequestHandler(Future<dynamic> Function(BluetoothPairingRequest request)? handler) => instance._setPairingRequestHandler(handler);
  static Future<int?> requestDiscoverable(int durationInSeconds) => instance._requestDiscoverable(durationInSeconds);
  static Future<bool?> get isDiscoverable => instance._isDiscoverable();

  // Instance methods (rename the original public methods to private)
  Stream<BluetoothDiscoveryResult> _startDiscovery() => /* original startDiscovery code */ startDiscovery();
  Future<List<BluetoothDevice>> _getBondedDevices() => /* original getBondedDevices code */ getBondedDevices();
  Future<bool?> _bondDeviceAtAddress(String address, {String? pin, bool? passkeyConfirm}) => /* original bondDeviceAtAddress code */ bondDeviceAtAddress(address, pin: pin, passkeyConfirm: passkeyConfirm);
  Future<bool?> _removeDeviceBondWithAddress(String address) => /* original removeDeviceBondWithAddress code */ removeDeviceBondWithAddress(address);
  void _setPairingRequestHandler(Future<dynamic> Function(BluetoothPairingRequest request)? handler) => /* original setPairingRequestHandler code */ setPairingRequestHandler(handler);
  Future<int?> _requestDiscoverable(int durationInSeconds) => /* original requestDiscoverable code */ requestDiscoverable(durationInSeconds);
  Future<bool?> _isDiscoverable() => /* original isDiscoverable code */ isDiscoverable;
}