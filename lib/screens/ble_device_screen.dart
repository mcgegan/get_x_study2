import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const BleDeviceScreen({super.key, required this.device});

  @override
  State<BleDeviceScreen> createState() => _BleDeviceScreenState();
}

class _BleDeviceScreenState extends State<BleDeviceScreen> {
  bool _isConnected = false;
  List<BluetoothService> _services = [];

  @override
  void initState() {
    super.initState();
    _connectToDevice();
  }

  Future<void> _connectToDevice() async {
    try {
      await widget.device.connect();
      setState(() {
        _isConnected = true;
      });

      // Discover services after connection
      _services = await widget.device.discoverServices();
      setState(() {});
    } catch (e) {
      print('Connection error: $e');
    }
  }

  Future<void> _disconnectFromDevice() async {
    try {
      await widget.device.disconnect();
      setState(() {
        _isConnected = false;
        _services = [];
      });
    } catch (e) {
      print('Disconnection error: $e');
    }
  }

  Widget _buildServiceList() {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return ExpansionTile(
          title: Text('Service: ${service.uuid}'),
          children:
              service.characteristics.map((characteristic) {
                return ListTile(
                  title: Text('Characteristic: ${characteristic.uuid}'),
                  subtitle: Text('Properties: ${characteristic.properties}'),
                  onTap: () {
                    // Handle characteristic interaction
                  },
                );
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.device.name.isEmpty ? 'Unknown Device' : widget.device.name,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Connection Status'),
            subtitle: Text(_isConnected ? 'Connected' : 'Disconnected'),
            trailing: ElevatedButton(
              onPressed:
                  _isConnected ? _disconnectFromDevice : _connectToDevice,
              child: Text(_isConnected ? 'Disconnect' : 'Connect'),
            ),
          ),
          Expanded(
            child:
                _services.isEmpty
                    ? const Center(child: Text('No services discovered'))
                    : _buildServiceList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }
}
