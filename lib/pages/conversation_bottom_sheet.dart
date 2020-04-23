import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/styles.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/chat_row_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/conversation_list_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/navigation_pill_widget.dart';

class ConversationBottomSheet extends StatefulWidget {
  @override
  _ConversationBottomSheetState createState() =>
      _ConversationBottomSheetState();
}

class _ConversationBottomSheetState extends State<ConversationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            GestureDetector(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  NavigationPillWidget(),
                  Center(
                    child: Text(
                      'Message',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              onVerticalDragEnd: (details) {
                print('Dragged Down');
                if (details.primaryVelocity > 50) {
                  Navigator.pop(context);
                }
              },
            ),
            ConversationListWidget(),
          ],
        ),
      ),
    );
  }
}
