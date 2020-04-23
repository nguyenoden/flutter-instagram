import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/messages/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/chat_row_widget.dart';

class ConversationListWidget extends StatefulWidget {
  @override
  _ConversationListWidgetState createState() => _ConversationListWidgetState();
}

class _ConversationListWidgetState extends State<ConversationListWidget> {
  MessagesBloc messagesBloc;
  List<Conversation> conversation = List();

  @override
  void initState() {
    super.initState();
    messagesBloc = BlocProvider.of<MessagesBloc>(context);
    messagesBloc.add(FetchMessagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      builder: (context, state) {
        if (state is FetchingMessagesState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FetchedMessagesState) {
          conversation = state.conversations;
          print("conversation : $conversation");
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: conversation.length,
            itemBuilder: (context, index) =>
                ChatRowWidget(conversation[index]));
      },
    );
  }
}
