// import 'package:flutter/material.dart';
// material.dart와 drift.dart 동시에 사용하면 오류 발생
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
//import 'dart:developer' as developer;

part 'card_db_items.g.dart';

class CardPageItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get subtitle => text()();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [CardPageItems])
class CardPageDatabase extends _$CardPageDatabase {
  CardPageDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<CardPageItem>> getAllCardPageItems() =>
      select(cardPageItems).get();
  Stream<List<CardPageItem>> watchAllCardPageItems() =>
      select(cardPageItems).watch();
  Future<int> createCardPageItem(CardPageItemsCompanion cardPageItem) =>
      into(cardPageItems).insert(cardPageItem);
  Future<bool> updateCardPageItem(CardPageItem cardPageitem) =>
      update(cardPageItems).replace(cardPageitem);
  Future<int> deleteCardPageItem(int id) =>
      (delete(cardPageItems)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    //developer.log('Database folder: ${dbFolder.path}');

    // 파일 이름은 프로그램마다 다르게 지정해야함
    final file = File(p.join(dbFolder.path, 'card_page_items.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}

// 모두 작성해야 part 파일이 생성됨
