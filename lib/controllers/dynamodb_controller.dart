import 'package:get/get.dart';
import '../services/dynamodb_service.dart';

class DynamoDBController extends GetxController {
  final DynamoDBService _dynamoDBService = DynamoDBService();

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxString title = ''.obs;
  RxString description = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      items.value = await _dynamoDBService.fetchItems();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createItem() async {
    try {
      if (title.value.isEmpty || description.value.isEmpty) return;

      await _dynamoDBService.createItem(title.value, description.value);
      await fetchItems();
      Get.snackbar('Success', 'Item created successfully');
      clearInputs();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create item: $e');
    }
  }

  Future<void> updateItem(String id) async {
    try {
      if (title.value.isEmpty || description.value.isEmpty) return;

      await _dynamoDBService.updateItem(id, title.value, description.value);
      await fetchItems();
      Get.snackbar('Success', 'Item updated successfully');
      clearInputs();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _dynamoDBService.deleteItem(id);
      await fetchItems();
      Get.snackbar('Success', 'Item deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete item: $e');
    }
  }

  void setEditingItem(Map<String, dynamic>? item) {
    title.value = _dynamoDBService.getItemTitle(item);
    description.value = _dynamoDBService.getItemDescription(item);
  }

  void clearInputs() {
    title.value = '';
    description.value = '';
  }
}
