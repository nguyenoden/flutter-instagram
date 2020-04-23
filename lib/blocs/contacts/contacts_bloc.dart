import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/contacts/contacts_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/contacts/contacts_state.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/chat_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/user_data_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;
  ChatRepository chatRepository;
  StreamSubscription subscription;

  ContactsBloc({this.userDataRepository, this.chatRepository})
      : assert(userDataRepository != null),
        assert(chatRepository != null);

  @override
  // TODO: implement initialState
  ContactsState get initialState => InitialContactsState();

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is FetchContactsEvent) {
      try {
        yield FetchingContactsState();
        subscription?.cancel();
        subscription = userDataRepository.getContact().listen((contacts) => {
              print('dispatching = $contacts'),
              add(ReceivedContactsEvent(contacts))
            });
      } on ClbException catch (exception) {
        yield ErrorState(exception);
      }
    }

    if (event is ReceivedContactsEvent) {
      yield FetchedContactsState(event.contacts);
    }

    if (event is AddContactEvent) {
      userDataRepository.getUser(event.username);
      yield* mapAddContactEventToState(event.username);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      User user = await userDataRepository.getUser(username);
      await chatRepository.createChatIdForContact(user);
      yield AddContactSuccessState();
    } on ClbException catch (exception) {
      yield AddContactFailedState(exception);
    }
  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      subscription?.cancel();
      subscription = userDataRepository
          .getContact()
          .listen((contact) => {add(ReceivedContactsEvent(contact))});
    } on ClbException catch (exception) {
      yield ErrorState(exception);
    }
  }
}
