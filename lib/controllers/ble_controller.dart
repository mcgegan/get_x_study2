import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleController extends GetxController {
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;
  final RxBool isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to scanning state changes
    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning.value = scanning;
    });
  }

  void startScan() async {
    scanResults.clear();
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results;
      });
    } catch (e) {
      print('Error scanning: $e');
    }
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
  }
}
