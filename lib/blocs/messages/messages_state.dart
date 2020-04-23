import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessagesState extends Equatable {
  const MessagesState();
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class InitialMessagesState extends MessagesState {}

class FetchingMessagesState extends MessagesState {
  @override
  String toString() => "FetchingMessagesState";
}

class FetchedMessagesState extends MessagesState {
  final List<Conversation> conversations;

  FetchedMessagesState(this.conversations);

  @override
  String toString() => "FetchedMessagesState";

  @override
  List<Object> get props => [conversations];
}
