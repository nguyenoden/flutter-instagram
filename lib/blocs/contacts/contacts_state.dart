import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';

import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';

abstract class ContactsState extends Equatable {
  ContactsState([List props=const<dynamic>[]]):super();
}

class InitialContactsState extends ContactsState{

  @override
  String toString() =>'InitialContactsState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
class FetchingContactsState extends ContactsState{
//  final List<Contact> contacts;
//
//  FetchingContactsState(this.contacts):super([contacts]);

  @override
  String toString() =>'FetchingContactsState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
// add contacts click , show progressbar
class AddContactProgressState extends ContactsState{

  @override
  String toString() =>'AddContactProgressState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
// add contact failed
class AddContactFailedState extends ContactsState{
  final ClbException exception;

  AddContactFailedState(this.exception):super([exception]);

  @override
  String toString() =>'AddContactFailedState';

  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
// Handle errors
class ErrorState extends ContactsState{
  final ClbException exception;

  ErrorState(this.exception):super([exception]);

  @override
  String toString() =>'ErrorState';

  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
class FetchedContactsState extends ContactsState{
  final List<Contact> contacts;

  FetchedContactsState(this.contacts):super([contacts]);

  @override
  String toString() {
    return 'FetchedContactsState';
  }

  @override
  // TODO: implement props
  List<Object> get props => [contacts];
}
class AddContactSuccessState extends ContactsState{


  @override
  String toString() {
    return 'AddContactSuccessState{}';
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}