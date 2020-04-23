import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  ChatEvent();
  @override
  List<Object> get props => null;
}

class FetchChatListEvent extends ChatEvent {
  @override
  String toString() => "FetchChatListEvent";
}

class ReceivedChatEvent extends ChatEvent {
  final List<Chat> listChat;

  ReceivedChatEvent(this.listChat) : super();
  @override
  List<Object> get props => [listChat];

  @override
  String toString() => "ReceivedChatEvent";
}

class FetchConversationDetailEvent extends ChatEvent {
  final Chat chat;

  FetchConversationDetailEvent(this.chat) : super();

  @override
  String toString() => "FetchConversationDetailEvent";

  @override
  List<Object> get props => [chat];
}

class FetchMessageEvent extends ChatEvent {
  final Chat chat;

  FetchMessageEvent(this.chat) : super();

  @override
  List<Object> get props => [chat];

  @override
  String toString() => "FetchMessageEvent";
}

class FetchPreviousMessageEvent extends ChatEvent {
  final Chat chat;
  final Message lastMessage;

  FetchPreviousMessageEvent(this.chat, this.lastMessage) : super();
  @override
  List<Object> get props => [chat, lastMessage];

  @override
  String toString() => "FetchPreviousMessageEvent";
}

class ReceivedMessageEvent extends ChatEvent {
  final List<Message> messages;
  final String username;

  ReceivedMessageEvent(this.messages, this.username) : super();
  @override
  List<Object> get props => [messages, username];

  @override
  String toString() => "ReceivedMessageEvent";
}

class SendTextMessageEvent extends ChatEvent {
  final String message;

  SendTextMessageEvent(this.message) : super();
  @override
  List<Object> get props => [message];

  @override
  String toString() => "SendTextMessageEvent";
}

class SendAttachEvent extends ChatEvent {
  final String chatId;
  final File file;
  final FileType fileType;

  SendAttachEvent(this.chatId, this.file, this.fileType) : super();
  @override
  List<Object> get props => [chatId, file, fileType];
  @override
  String toString() => "SendAttachEvent";
}

class PageChangeEvent extends ChatEvent {
  final int index;
  final Chat activeChat;

  PageChangeEvent(this.index, this.activeChat) : super();
  @override
  List<Object> get props => [index, activeChat];
  @override
  String toString() => "PageChangeEvent";
}

class RegisterActiveChatEvent extends ChatEvent {
  final String activeChatId;

  RegisterActiveChatEvent(this.activeChatId);
  @override
  List<Object> get props => [activeChatId];
  @override
  String toString() => "RegisterActiveChatEvent { aciveChatId: $activeChatId}";
}

class ToggleEmojiKeyboardEvent extends ChatEvent {
  final bool showEmoojiKeyboard;

  ToggleEmojiKeyboardEvent(this.showEmoojiKeyboard);
  @override
  List<Object> get props => [showEmoojiKeyboard];
  @override
  String toString() => "ToggleEmojiKeyboardEvent";
}
