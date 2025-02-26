import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../widgets/common/common_bottom_navigation_bar.dart';

class CountController extends GetxController {
  var count = 0.obs;

  void increment() => count++;
}

class IntegerListGenerator extends GetxController {
  //List<int> integerList = List<int>.empty().obs;
  var integerList = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateIntegerList();
    debugPrint('integerList type: ${integerList.runtimeType}');
  }

  generateIntegerList() {
    integerList.value = List.generate(100, (index) => Random().nextInt(1000));
  }
}

class HomeScreen extends StatelessWidget {
  //class HomeScreen extends GetView<IntegerListGenerator> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final countController = Get.put(CountController());
    final integerListGenerator = Get.put(IntegerListGenerator());

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tou have pushed the button this many times:'),
            Obx(() => Text('${countController.count}')),
              
            ElevatedButton(
              onPressed: () => integerListGenerator.generateIntegerList(),
              child: const Text('Generate new integer list'),
            ),
            Expanded(
              child: Center(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: integerListGenerator.integerList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          integerListGenerator.integerList[index].toString(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CommonBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => countController.increment(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
