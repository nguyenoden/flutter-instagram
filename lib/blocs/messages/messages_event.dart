import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => null;
}

class FetchMessagesEvent extends MessagesEvent {
  @override
  String toString() => "FetchMessagesEvent";
}

class ReceivedMessagesEvent extends MessagesEvent {
  final List<Conversation> conversations;

  ReceivedMessagesEvent(this.conversations);

  @override
  String toString() => "ReceivedMessagesEvent";

  @override
  List<Object> get props => [conversations];
}
