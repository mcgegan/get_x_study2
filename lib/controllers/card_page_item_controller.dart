import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import '../database/card_db_items.dart';

class CardPageItemController extends GetxController {
  final CardPageDatabase database = CardPageDatabase();
  final RxList<CardPageItem> cardPageItems = <CardPageItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    database.watchAllCardPageItems().listen((cardPageItemList) {
      cardPageItems.value = cardPageItemList;
    });
  }

  Future<void> addCardPageItem(String title, String subtitle) async {
    await database.createCardPageItem(
      CardPageItemsCompanion(
        title: drift.Value(title),
        subtitle: drift.Value(subtitle),
      ),
    );
  }

  Future<void> updateCardPageItemStatus(
    CardPageItem cardPageItem,
    bool isCompleted,
  ) async {
    await database.updateCardPageItem(
      cardPageItem.copyWith(isCompleted: isCompleted),
    );
  }

  Future<void> deleteCardPageItem(int id) async {
    await database.deleteCardPageItem(id);
  }

  @override
  void onClose() {
    database.close();
    super.onClose();
  }

  //CardPageItemController({required this.database});
}
