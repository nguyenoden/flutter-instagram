import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/dao/base_dao.dart';
import 'package:flutter_clb_tinhban_ui_app/database/contacts_database.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';

class ContactsDAO extends BaseContactDAO {

  final dbContacts=ContactsDataBase.db;


  @override
  Future<int> createNewContacts(Contact contact) async {
    final db= await dbContacts.database;
    print("contact $contact");
    print("contact.toJsonData() ${contact.toJsonData()}");
    var result= db.insert(Constants.contactTable, contact.toJsonData());
    print('result $result');

    return result;
  }


  @override
  Future<void> deleteAllContact() {
    // TODO: implement deleteAllContact
    return null;
  }

  @override
  Future<Contact> deleteContact(Contact contact) {
    // TODO: implement deleteContact
    return null;
  }

  @override
  Future<void> getContacts() {
    // TODO: implement getContacts
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<Contact> updateContact(Contact contact) {
    // TODO: implement updateContact
    return null;
  }


}
