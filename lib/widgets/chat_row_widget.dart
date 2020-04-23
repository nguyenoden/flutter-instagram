import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/styles.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/conversation_page_slide.dart';
import 'package:intl/intl.dart';

class ChatRowWidget extends StatelessWidget {
  final Conversation conversation;

  const ChatRowWidget(this.conversation) : super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () => Navigator.push(
          context,
          SlideLeftRout(
              page: ConversationPageSlide(
            startContact: Contact.fromConversation(conversation),
          ))),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                          conversation.user.photoUrl),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        conversation.user.username,
                        style: Theme.of(context).textTheme.body1,
                      ),
                      messageContent(context, conversation.latestMessage),
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat('kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            conversation.latestMessage.timeStamp)),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  messageContent(context, Message latestMessage) {
    if (latestMessage is TextMessage)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.colorGrey,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Text(
            latestMessage.text,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    if (latestMessage is ImageMessage) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.colorGrey,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.camera_alt,
            size: 10,
            color: Palette.colorGrey,
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            'Photo',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    }
    if (latestMessage is VideoMessage) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.colorGrey,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.videocam,
            size: 10,
            color: Palette.colorGrey,
          ),
          Text(
            'Video',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    }
    if (latestMessage is FileMessage) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.colorGrey,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.attach_file,
            size: 10,
            color: Palette.colorGrey,
          ),
          Text(
            'File',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    }
  }
}
