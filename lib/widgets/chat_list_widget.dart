import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/chat_item_widget.dart';

class ChatListWidget extends StatefulWidget {
  final Chat chat;

   ChatListWidget(this.chat) : super();

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState(chat);
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ScrollController _scrollController = ScrollController();

  List<Message> messages = List();
  final Chat chat;


  _ChatListWidgetState(this.chat);

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      print("maxScroll currentScroll : $maxScroll : $currentScroll");
      if (maxScroll == currentScroll) {
        BlocProvider.of<ChatBloc>(context)
            .add(FetchPreviousMessageEvent(this.chat, messages.last));

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is FetchedMessageState) {
          print('Received Messages $state');
          if(state.username==chat.username){
            print(state.messages.length);
            print("state.isPrevious : ${state.isPrevious}");
            if(state.isPrevious)
              messages.addAll(state.messages);
            else
              messages=state.messages;
          }
        }
        print("messages : $messages");

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: messages.length,
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, index) => ChatItemWidget(messages[index]),
        );
      },
    );
  }
}
