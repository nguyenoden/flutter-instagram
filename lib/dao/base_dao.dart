 import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';

abstract class BaseDAO{
  void dispose();

}

abstract class BaseContactDAO extends BaseDAO{
  Future<int> createNewContacts(Contact contact);
  Future<void> getContacts();
  Future<Contact> updateContact(Contact contact);
  Future<Contact> deleteContact(Contact contact);
  Future<void> deleteAllContact();

}