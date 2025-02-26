import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../controllers/ble_controller.dart';
import './ble_device_screen.dart';
import '../widgets/common/common_bottom_navigation_bar.dart';

class BleScanScreen extends StatelessWidget {
  BleScanScreen({super.key});

  final BleController controller = Get.put(BleController());

  Widget _buildDeviceList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.scanResults.length,
        itemBuilder: (context, index) {
          final result = controller.scanResults[index];
          return ListTile(
            title: Text(
              result.device.platformName.isEmpty
                  ? 'Unknown Device'
                  : result.device.platformName,
            ),
            subtitle: Text(result.device.id.toString()),
            trailing: Text('${result.rssi} dBm'),
            onTap: () {
              Get.to(() => BleDeviceScreen(device: result.device));
              /*
              if (result.device.platformName == "Bie V2G PilotEmu") {
                Get.to(() => BieV2gPilotScreen(device: result.device));
              } else {
                Get.to(() => BleDeviceScreen(device: result.device));
              }
              */
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Scanner')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () =>
                  controller.scanResults.isEmpty
                      ? const Center(child: Text('No devices found'))
                      : _buildDeviceList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CommonBottomNavigationBar(),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed:
              controller.isScanning.value
                  ? controller.stopScan
                  : controller.startScan,
          child: Icon(controller.isScanning.value ? Icons.stop : Icons.search),
        ),
      ),
    );
  }
}
