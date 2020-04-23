import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';

import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';

import 'package:flutter_clb_tinhban_ui_app/widgets/chat_app_bar.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/chat_list_widget.dart';

// ignore: must_be_immutable
class ConversationPage extends StatefulWidget {
  Chat chat;
  Contact contact;

  ConversationPage({this.chat, this.contact});

  @override
  _ConversationPageState createState() => _ConversationPageState(chat, contact);
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin {
  Contact contact;
  Chat chat;
  ChatBloc chatBloc;

  _ConversationPageState(this.chat, this.contact);

  @override
  void initState() {
    super.initState();
    if (contact != null) chat = Chat(contact.username, contact.chatId);

    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchConversationDetailEvent(chat));
    print("ContacAppBar: $contact");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: <Widget>[
        Container(
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.only(top: 100),
            child: ChatListWidget(chat)),
        SizedBox.fromSize(
          size: Size.fromHeight(100),
          child: ChatAppBar(contact: contact, chat: chat),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
