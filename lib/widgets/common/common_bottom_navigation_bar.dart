import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  const CommonBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'CardList'),
        BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'CardDB'),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud_queue),
          label: 'DynamoDB',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bluetooth),
          label: 'BLE Scan',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Get.toNamed('/home');
        } else if (index == 1) {
          Get.toNamed('/card_list');
        } else if (index == 2) {
          Get.toNamed('/card_database');
        } else if (index == 3) {
          Get.toNamed('/dynamodb');
        } else if (index == 4) {
          Get.toNamed('/ble_scan');
        }
      },
    );
  }
}
