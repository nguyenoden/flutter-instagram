import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/conversation_page.dart';

class SingleConversationPage extends StatefulWidget {
  final Contact contact;

  SingleConversationPage(this.contact);

  @override
  _SingleConversationPageState createState() =>
      _SingleConversationPageState(this.contact);
}

class _SingleConversationPageState extends State<SingleConversationPage>
    with SingleTickerProviderStateMixin {
  final Contact contact;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ChatBloc chatBloc;
  bool isFirstLaunch = true;
  bool configMessagePeek = true;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(RegisterActiveChatEvent(contact.chatId));
  }

  _SingleConversationPageState(this.contact);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Expanded(
              child: ConversationPage(
                contact: contact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
