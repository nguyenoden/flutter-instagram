import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/messages/messages_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/messages/messages_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/messages/messages_state.dart';

import 'package:flutter_clb_tinhban_ui_app/config/styles.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/chat_row_widget.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  MessagesBloc messagesBloc;
  List<Conversation> conversation = List();

  @override
  void initState() {
    messagesBloc = BlocProvider.of<MessagesBloc>(context);
    messagesBloc.add(FetchMessagesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              centerTitle: true,
              pinned: true,
              expandedHeight: 50,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Messages',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                if (state is FetchingMessagesState) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else if (state is FetchedMessagesState) {
                  conversation = state.conversations;
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => ChatRowWidget(conversation[index]),
                      childCount: conversation.length),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
