import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/bottom_sheet_fixed.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/image_full_screen.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/video_player_chewie_widget.dart';
import 'package:intl/intl.dart';
import 'package:progressive_image/progressive_image.dart';

class ChatItemWidget extends StatelessWidget {
  final Message message;

  ChatItemWidget(this.message);

  @override
  Widget build(BuildContext context) {
    final isSelf = message.isSelf;
    return Container(
      child: Column(
        children: <Widget>[
          _buildMessageContainer(isSelf, message, context),
          _buildTimeStamp(isSelf, message, context),
        ],
      ),
    );
  }

  _buildMessageContainer(bool isSelf, Message message, BuildContext context) {
    double lrEdgeInset = 1.0;
    double tbEdgeInset = 1.0;
    if (message is TextMessage) {
      lrEdgeInset = 15.0;
      tbEdgeInset = 10.0;
    }
    return Row(
      mainAxisAlignment:
          isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: _buildMessageContent(isSelf, message, context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInset, tbEdgeInset, lrEdgeInset, tbEdgeInset),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
          constraints: BoxConstraints(maxWidth: 200.0),
          decoration: BoxDecoration(
              color: isSelf
                  ? Palette.selfMessageBackgroundColor
                  : Palette.otherMessageBackgroundColor,
              borderRadius: BorderRadius.circular(8.0)),
        )
      ],
    );
  }

  _buildMessageContent(bool isSelf, Message message, BuildContext context) {
    if (message is TextMessage) {
      return Text(
        message.text,
        style: TextStyle(
            color:
                isSelf ? Palette.colorBlack : Palette.colorBlack),
      );
    } else if (message is ImageMessage) {
      return GestureDetector(
        onTap: () => Navigator.push(
            context,
            SlideLeftRout(
                page: ImageFullScreen(
              tag: 'ImageMessage ${message.documentId}',
              url: message.imageUrl,
            ))),
        child: Hero(
          tag: 'ImageMessage ${message.documentId}',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: ProgressiveImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage(Assets.placeholder),
                  thumbnail: NetworkImage(message.imageUrl),
                  image: NetworkImage(message.imageUrl),
                  width: 100,
                  height: 100)),
        ),
      );
    } else if (message is VideoMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  width: 100,
                  color: Theme.of(context).primaryColor,
                  height: 60,
                ),
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.videocam,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                          fontSize: 14,
                          color: isSelf
                              ? Palette.colorBlack
                              : Palette.colorBlack),
                    )
                  ],
                )
              ],
            ),
            Container(
              height: 40,
              child: IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: isSelf
                      ? Palette.colorBlack
                      : Palette.colorBlack,
                ),
                onPressed: () => showVideoPlayer(context, message.videoUrl),
              ),
            )
          ],
        ),
      );
    } else if (message is FileMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  color: Theme.of(context).accentColor,
                  height: 60.0,
                ),
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.insert_drive_file,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      ' FILE',
                      style: TextStyle(
                          fontSize: 14,
                          color: isSelf
                              ? Palette.colorBlack
                              : Palette.colorBlack),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 40,
              child: IconButton(
                onPressed: () => ShareObjects.downloadFile(
                    message.fileUrl, message.fileName),
                icon: Icon(
                  Icons.file_download,
                  color: isSelf
                      ? Palette.colorBlack
                      : Palette.colorBlack,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  _buildTimeStamp(bool isSelf, Message message, BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: isSelf ? 5.0 : 0.0,
              right: isSelf ? 0.0 : 5.0,
              top: 5.0,
              bottom: 5.0),
          child: Text(
            DateFormat('kk:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(message.timeStamp)),
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }

  void showVideoPlayer(parentContext, String videoUrl) async {
    print("videoUrl:$videoUrl");
    await showModalBottomSheetApp(
        context: parentContext,
        builder: (BuildContext bc) => VideoPlayerChewieWidget(
              videoUrl: videoUrl,
            ));
  }
}
