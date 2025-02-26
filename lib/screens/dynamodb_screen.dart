import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dynamodb_controller.dart';
import '../services/dynamodb_service.dart';
import '../widgets/common/common_bottom_navigation_bar.dart';

class DynamoDBScreen extends StatelessWidget {
  final DynamoDBController controller = Get.put(DynamoDBController());
  final DynamoDBService _dynamoDBService = DynamoDBService();

  void showItemDialog(BuildContext context, {Map<String, dynamic>? item}) {
    controller.setEditingItem(item);
    final titleController = TextEditingController(text: controller.title.value);
    final descriptionController = TextEditingController(
      text: controller.description.value,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(item == null ? 'Create Item' : 'Update Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) => controller.title.value = value,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) => controller.description.value = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.clearInputs();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (item == null) {
                    controller.createItem();
                  } else {
                    controller.updateItem(item['id'].s);
                  }
                  Navigator.pop(context);
                },
                child: Text(item == null ? 'Create' : 'Update'),
              ),
            ],
          ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(_dynamoDBService.getItemTitle(item)),
        subtitle: Text(_dynamoDBService.getItemDescription(item)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => showItemDialog(context, item: item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.deleteItem(item['id'].s),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DynamoDB Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchItems,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text('No items found. Add some items!'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchItems,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.items.length,
            itemBuilder:
                (context, index) =>
                    _buildListItem(controller.items[index], context),
          ),
        );
      }),
      bottomNavigationBar: const CommonBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
