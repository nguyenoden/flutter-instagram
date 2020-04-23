import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';

abstract class ContactsEvent extends Equatable {
  ContactsEvent([List props = const <dynamic>[]]) : super();

}

class FetchContactsEvent extends ContactsEvent {
  @override
  String toString() => 'FetchContactsEvent';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

//Dispatch received contacts from stream
class ReceivedContactsEvent extends ContactsEvent {
  final List<Contact> contacts;

  ReceivedContactsEvent(this.contacts) : super([contacts]);

  @override
  String toString() => 'ReceivedContactsEvent';

  @override
  // TODO: implement props
  List<Object> get props => [contacts];
}

// add a new contact
class AddContactEvent extends ContactsEvent {
  final String username;

  AddContactEvent(this.username) : super([username]);

  @override
  String toString() => 'AddContactEvent';

  @override
  // TODO: implement props
  List<Object> get props => [username];
}
