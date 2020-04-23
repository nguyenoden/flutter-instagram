import 'dart:io';

import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final contactTable = Constants.contactTable;
String id="id";
String documentId="documentId";
String name="name";
String username="username";
String chatId="chatId";
String photoUrl="photoUrl";

class ContactsDataBase {
  // create a singleton
  ContactsDataBase._();

  static final ContactsDataBase db = ContactsDataBase._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await createDatabase();
      return _database;
    }
  }

  createDatabase() async {
    Directory documentDir = await getApplicationDocumentsDirectory();

    String path = join(documentDir.path, Constants.contactDB);
    var database = await openDatabase(path,version: 2,onCreate: initDB,onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  initDB(Database database, int version) async {
    //Get the location of our app directory. This is where file for our app
    //and only our app, are stored. Files in this directory are deleted
    // when the app is deleted
  return await database.execute('CREATE TABLE $contactTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $documentId TEXT, '
      '$name TEXT, $username TEXT, $photoUrl TEXT, $chatId TEXT)');
  }

}