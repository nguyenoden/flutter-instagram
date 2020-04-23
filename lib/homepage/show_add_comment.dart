import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/comments/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/database/contacts_database.dart';

import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';

import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';

class ShowAddComment extends StatefulWidget {
  final Stories stories;
  const ShowAddComment(this.stories);

  @override
  _ShowAddCommentState createState() => _ShowAddCommentState(stories);
}

class _ShowAddCommentState extends State<ShowAddComment> {
  final Stories stories;
  final textController = TextEditingController();
  CommentsBloc commentsBloc;
  StoriesBloc storiesBloc;
  bool _canPost = false;

  _ShowAddCommentState(this.stories);

  @override
  void initState() {
    storiesBloc = BlocProvider.of<StoriesBloc>(context);
    commentsBloc = BlocProvider.of<CommentsBloc>(context);
    textController.addListener(() {
      setState(() => _canPost = textController.text.isNotEmpty);
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                  child: Text(
                    ' Đang trả lời ',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(ShareObjects
                        .prefs
                        .getString(Constants.sessionProfilePictureUrl)),
                  ),
                  width: 40.0,
                  height: 40.0,
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.caption,
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: _canPost
                      ? () => {
                              commentsBloc.add(SendCommentEvent(
                                  textController.text, stories.documentId)),

                              storiesBloc.add(FetchCommentsStoriesEvent( stories.documentId)),
                              Navigator.pop(context),
                             // storiesBloc.add(FetchListStoriesEvent());
                          }
                      : null,
                  child: _canPost
                      ? Icon(
                          Icons.send,
                          color: Colors.blue,
                          size: 24,
                        )
                      : Icon(
                          Icons.send,
                          color: Colors.grey,
                          size: 24,
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
