import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';

import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

import 'package:flutter_clb_tinhban_ui_app/repositories/chat_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/user_data_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:path/path.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;
  Map<String, StreamSubscription> messagesSubscriptionMap = Map();
  StreamSubscription chatsSubscription;
  String activeChatId;

  ChatBloc(
      {this.chatRepository, this.userDataRepository, this.storageRepository})
      : assert(chatRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null);

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    print(event);

    if (event is FetchChatListEvent) {
      yield* mapFetchChatListToState(event);
    }
    if (event is RegisterActiveChatEvent) {
      activeChatId = event.activeChatId;
    }
    if (event is ReceivedChatEvent) {
      yield FetchedChatListState(event.listChat);
    }
    if (event is PageChangeEvent) {
      activeChatId = event.activeChat.chatId;
      yield PageChangedState(event.index, event.activeChat);
    }
    if (event is FetchConversationDetailEvent) {
      yield* mapFetchConversationDetailEventToState(event);
    }
    if (event is FetchMessageEvent) {
      yield* mapFetchMessageEventToState(event);
    }
    if (event is FetchPreviousMessageEvent) {
      yield* mapFetchPreviousMessageEventToState(event);
    }
    if (event is ReceivedMessageEvent) {
      print("dispatching recevied message");
      yield FetchedMessageState(event.messages, event.username,
          isPrevious: false);
    }
    if (event is SendTextMessageEvent) {
      Message message = TextMessage(
          event.message,
          DateTime.now().millisecondsSinceEpoch,
          ShareObjects.prefs.getString(Constants.sessionName),
          ShareObjects.prefs.getString(Constants.sessionUsername));

      await chatRepository.sendMessage(activeChatId, message);
    }
    if (event is SendAttachEvent) {
      await mapSendAttachmentEventToState(event);
    }
    if (event is ToggleEmojiKeyboardEvent) {
      yield ToggleEmojiKeyboardState(event.showEmoojiKeyboard);
    }
  }

  Stream<ChatState> mapFetchChatListToState(FetchChatListEvent event) async* {
    try {
      chatsSubscription?.cancel();
      chatsSubscription = chatRepository
          .getChat()
          .listen((chat) => add(ReceivedChatEvent(chat)));
    } on ClbException catch (exception) {
      print(exception.errorMessage());
      yield ErrorsState(exception);
    }
  }

  Stream<ChatState> mapFetchConversationDetailEventToState(
      FetchConversationDetailEvent event) async* {
    User user = await userDataRepository.getUser(event.chat.username);
    yield FetchedContactDetailState(user, event.chat.username);
    add(FetchMessageEvent(event.chat));
  }
  Stream<ChatState> mapFetchMessageEventToState(
      FetchMessageEvent event) async* {
    try {
      yield FetchingMessageState();
      String chatId =
          await chatRepository.getChatIdByUsername(event.chat.username);
      print('chatID :$chatId');
      StreamSubscription messagesSubscription = messagesSubscriptionMap[chatId];
      messagesSubscription?.cancel();

      messagesSubscription = chatRepository.getMessage(chatId).listen(
          (messages) =>
              add(ReceivedMessageEvent(messages, event.chat.username)));
      messagesSubscriptionMap[chatId] = messagesSubscription;
    } on ClbException catch (exception) {
      print(exception.errorMessage());

      yield ErrorsState(exception);
    }
  }

  Stream<ChatState> mapFetchPreviousMessageEventToState(
      FetchPreviousMessageEvent event) async* {
    try {
      String chatId =
          await chatRepository.getChatIdByUsername(event.chat.username);

      final messages =
          await chatRepository.getPreviousMessage(chatId, event.lastMessage);

      yield FetchedMessageState(messages, event.chat.username,
          isPrevious: true);
    } on ClbException catch (exception) {
      print(exception.errorMessage());
      yield ErrorsState(exception);
    }
  }

  Future mapSendAttachmentEventToState(SendAttachEvent event) async {
    File file = event.file;
    String filename = basename(file.path);
    String url = await storageRepository.uploadFile(
        file, Paths.getAttachmentByFileType(event.fileType));
    String username = ShareObjects.prefs.getString(Constants.sessionUsername);
    String name = ShareObjects.prefs.getString(Constants.sessionName);

    Message message;
    if (event.fileType == FileType.image) {
      message = ImageMessage(
          url, filename, DateTime.now().millisecondsSinceEpoch, name, username);
    } else if (event.fileType == FileType.video) {
      message = VideoMessage(
          url, filename, DateTime.now().millisecondsSinceEpoch, name, username);
    } else {
      message = FileMessage(
          url, filename, DateTime.now().millisecondsSinceEpoch, name, username);
    }

    await chatRepository.sendMessage(activeChatId, message);
  }

  @override
  Future<Function> close() {
    chatsSubscription?.cancel();
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());

    return super.close();
  }
}
