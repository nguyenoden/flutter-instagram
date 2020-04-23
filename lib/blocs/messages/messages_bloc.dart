import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/chat_repository.dart';
import './bloc.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepository chatRepository;

  MessagesBloc(this.chatRepository);

  @override
  MessagesState get initialState => InitialMessagesState();

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    print(event);
    if (event is FetchMessagesEvent) {
      yield FetchingMessagesState();
      chatRepository
          .getConversation()
          .listen((conversation) => add(ReceivedMessagesEvent(conversation)));
    }
    if (event is ReceivedMessagesEvent) {
      yield FetchingMessagesState();
      yield FetchedMessagesState(event.conversations);
    }
  }
}
