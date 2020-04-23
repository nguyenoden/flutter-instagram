import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/home_clb.dart';
import 'package:flutter_clb_tinhban_ui_app/messager/messages_page.dart';
import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/conversation_bottom_sheet.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/conversation_page.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/input_widget.dart';

class ConversationPageSlide extends StatefulWidget {
  final Contact startContact;

  const ConversationPageSlide({this.startContact});

  @override
  _ConversationPageSlideState createState() =>
      _ConversationPageSlideState(startContact);
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  PageController pageController = PageController();
  final Contact startContact;
  ChatBloc chatBloc;
  List<Chat> chatList = List();
  bool isFirstLaunch = true;
  bool configMessagePeek = true;

  _ConversationPageSlideState(this.startContact);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchChatListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldState,
        body: Column(
          children: <Widget>[
            BlocListener<ChatBloc, ChatState>(
              bloc: chatBloc,
              listener: (bc, state) {
                if (isFirstLaunch && chatList.isNotEmpty) {
                  isFirstLaunch = false;
                  for (int i = 0; i < chatList.length; i++) {
                    if (startContact.username == chatList[i].username) {
                      BlocProvider.of<ChatBloc>(context)
                          .add(PageChangeEvent(i, chatList[i]));
                      pageController.jumpToPage(i);
                    }
                  }
                }
              },
              child: Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is FetchedChatListState)
                      chatList = state.chatList;
                    return PageView.builder(
                        pageSnapping: true,
                        controller: pageController,
                        itemCount: chatList.length,
                        onPageChanged: (index) =>
                            BlocProvider.of<ChatBloc>(context)
                                .add(PageChangeEvent(index, chatList[index])),
                        itemBuilder: (bc, index) => ConversationPage(
                              chat: chatList[index],
                            ));
                  },
                ),
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
              return GestureDetector(
                  child: InputWidget(),
                  onPanUpdate: (details) {
                    if (details.delta.dy < 0) {
                      _scaffoldState.currentState
                          .showBottomSheet<Null>((BuildContext context) {
                        return ConversationBottomSheet();
                      });
                    }
                  });
            })
          ],
        ),
      ),
    );
  }
}
