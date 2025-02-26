// dart build build_runner build 후 실행
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:drift/drift.dart';
//drift.dart import 하면 오류 발생
import '../controllers/card_page_item_controller.dart';
import '../widgets/common/common_bottom_navigation_bar.dart';

class CardDatabaseScreen extends StatelessWidget {
  const CardDatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CardPageItemController cardPageItemController = Get.put(
      CardPageItemController(),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Card Database')),
        body: Obx(
          () => ListView.builder(
            itemCount: cardPageItemController.cardPageItems.length,
            itemBuilder: (context, index) {
              final cardPageItem = cardPageItemController.cardPageItems[index];
              return ListTile(
                title: Text(cardPageItem.title),
                subtitle: Text(cardPageItem.subtitle),
                trailing: Checkbox(
                  value: cardPageItem.isCompleted,
                  onChanged: (value) {
                    if (value != null) {
                      cardPageItemController.updateCardPageItemStatus(
                        cardPageItem,
                        value,
                      );
                    }
                  },
                ),
                onLongPress:
                    () => cardPageItemController.deleteCardPageItem(
                      cardPageItem.id,
                    ),
              );
            },
          ),
        ),
        bottomNavigationBar: const CommonBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCardItemDialog(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCardItemDialog(BuildContext context) {
    final CardPageItemController cardPageItemController = Get.find();
    final titleController = TextEditingController();
    final subTitleController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Add New Card Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: subTitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                cardPageItemController.addCardPageItem(
                  titleController.text,
                  subTitleController.text,
                );
                debugPrint(cardPageItemController.cardPageItems.toString());
                Get.back();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
