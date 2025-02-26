import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/common/common_bottom_navigation_bar.dart';

class CardModel {
  final String title;
  final String subtitle;

  CardModel({required this.title, required this.subtitle});
}

class CardListController extends GetxController {
  var cardList = <CardModel>[].obs;

  void appendCard() {
    cardList.add(
      CardModel(
        title: 'Card ${cardList.length + 1}',
        subtitle: 'This is ${cardList.length + 1}',
      ),
    );
  }

  void removeCard(int index) {
    cardList.removeAt(index);
  }
}

/*
class CardTrailingWidget extends StatelessWidget {
  const CardTrailingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              cardSetting(context);
            },
            icon: const Icon(Icons.settings),
          ),
          SizedBox(height: 4),
          Icon(Icons.signal_cellular_alt),
          SizedBox(height: 4),
          IconButton(
            onPressed: () {
              final cardList = Get.find<CardListController>().cardList;
              final index = cardList.indexWhere(
                (card) => card.title == card.title,
              );
              final selectedCard = cardList[index];
              debugPrint('Selected card title: ${selectedCard.title}');
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void cardSetting(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Card Settings'),
          content: Text('This is the card settings'),
        );
      },
    );
  }
}
*/
class CardListScreen extends StatelessWidget {
  const CardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardListController = Get.put(CardListController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Card List')),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Card List'),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cardListController.appendCard();
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Obx(
                      () => Column(
                        children:
                            cardListController.cardList
                                .map(
                                  (card) => Card(
                                    child: ListTile(
                                      title: Text(card.title),
                                      subtitle: Text(card.subtitle),
                                      //trailing: CardTrailingWidget(),
                                      trailing: SizedBox(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                //cardSetting(context);
                                              },
                                              icon: Icon(Icons.settings),
                                            ),
                                            SizedBox(height: 4),
                                            Icon(Icons.signal_cellular_alt),
                                            SizedBox(height: 4),
                                            IconButton(
                                              onPressed: () {
                                                final index = cardListController
                                                    .cardList
                                                    .indexOf(card);
                                                cardListController.removeCard(
                                                  index,
                                                );
                                                debugPrint(
                                                  'Card tapped: ${card.title}',
                                                );
                                                debugPrint(
                                                  'Card index: $index',
                                                );
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        debugPrint(
                                          'Card tapped: ${card.title}',
                                        );
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CommonBottomNavigationBar(),
      ),
    );
  }
}
