import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/conversation_page_slide.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/single_conversation_page.dart';

// ignore: must_be_immutable
class ContactRowWidget extends StatelessWidget {
  final Contact contact;

  ContactRowWidget({Key key, @required this.contact}) : super(key: key);
  bool configMessagePaging = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, SlideLeftRout(page: SingleConversationPage(contact))),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
        child: Row(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        CachedNetworkImageProvider(contact.photoUrl),
                  ),
                  width: 50.0,
                  height: 50.0,
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contact.username,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    Text(
                      contact.name,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
