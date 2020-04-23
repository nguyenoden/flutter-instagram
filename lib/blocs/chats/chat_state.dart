import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState() : super();
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class InitialChatState extends ChatState {}

class FetchedChatListState extends ChatState {
  final List<Chat> chatList;

  FetchedChatListState(this.chatList) : super();
  @override
  // TODO: implement props
  List<Object> get props => [chatList];
  @override
  String toString() => "FetchedChatListState";
}

class FetchedMessageState extends ChatState {
  final List<Message> messages;
  final String username;
  final isPrevious;

  FetchedMessageState(this.messages, this.username, {this.isPrevious})
      : super();

  @override
  List<Object> get props => [messages, username, isPrevious];
  @override
  String toString() =>
      'FetchedMessagesState {messages: ${messages.length}, username: $username, isPrevious: $isPrevious}';
}

class FetchingMessageState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => null;

  @override
  String toString() => "FetchingMessageState";
}

class ErrorsState extends ChatState {
  final Exception exception;

  ErrorsState(this.exception) : super();

  @override
  String toString() => "ErrorsState";

  @override
  List<Object> get props => [exception];
}

class FetchedContactDetailState extends ChatState {
  final User user;
  final String username;

  FetchedContactDetailState(this.user, this.username) : super();
  @override
  // TODO: implement props
  List<Object> get props => [user, username];

  @override
  String toString() => "FetchedContactDetailState";
}

class PageChangedState extends ChatState {
  final int index;
  final Chat activeChat;

  PageChangedState(this.index, this.activeChat) : super();
  @override
  // TODO: implement props
  List<Object> get props => [index, activeChat];

  @override
  String toString() => "PageChangedState";
}

class ToggleEmojiKeyboardState extends ChatState {
  final bool showEmojiKeyboard;

  ToggleEmojiKeyboardState(this.showEmojiKeyboard);
  @override
  // TODO: implement props
  List<Object> get props => [showEmojiKeyboard];

  @override
  String toString() => "ToggleEmojiKeyboardState";
}
