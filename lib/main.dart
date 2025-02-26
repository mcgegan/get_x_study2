import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/home_screen.dart';
import 'screens/card_list_screen.dart';
import 'screens/card_database_screen.dart';
import 'screens/dynamodb_screen.dart';
import 'screens/ble_scan_screen.dart';

void main() {
  //runApp(GetMaterialApp(home: MainApp()));
  runApp(
    GetMaterialApp(
      home: HomeScreen(),
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/card_list', page: () => CardListScreen()),
        GetPage(name: '/card_database', page: () => CardDatabaseScreen()),
        GetPage(name: '/dynamodb', page: () => DynamoDBScreen()),
        GetPage(name: '/ble_scan', page: () => BleScanScreen()),
      ],
    ),
  );
}
