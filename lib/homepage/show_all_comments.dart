import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/comments/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/show_add_comment.dart';

import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';

import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';

import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';

import 'package:outline_material_icons/outline_material_icons.dart';

class ShowAllComments extends StatefulWidget {
  final Stories stories;

  //final ValueChanged<String> onPost;

  const ShowAllComments({Key key, this.stories}) : super(key: key);

  @override
  _ShowAllCommentsState createState() => _ShowAllCommentsState(stories);
}

class _ShowAllCommentsState extends State<ShowAllComments> {
  final _textController = TextEditingController();
  bool _canPost = false;
  final Stories stories;
  List<Comment> listComment = List();

  CommentsBloc commentsBloc;

  _ShowAllCommentsState(this.stories);

  void _toggleIsLikeComment(index) {
//    setState(() => widget.comment[index].toggleLikeFor(currentUser));
  }

  @override
  void initState() {
    commentsBloc = BlocProvider.of<CommentsBloc>(context);
    commentsBloc.add(FetchCommentsEvent(stories.documentId));

    _textController.addListener(() {
      setState(() => _canPost = _textController.text.isNotEmpty);
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.colorWhite,
        appBar: appBar(),
        body: BlocBuilder<CommentsBloc, CommentsState>(
          bloc: commentsBloc,
          builder: (context, state) {
            if(state is FetchingListCommentsState){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              );
            }
            if (state is FetchedListCommentsState) {

                listComment = state.listComments;


            }
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return textTopStories();
                } else {
                  return itemComment(listComment[index - 1]);
                }
              },
              itemCount: listComment.length + 1,
              scrollDirection: Axis.vertical,
              addAutomaticKeepAlives: true,
            );
          },
        ),
        bottomNavigationBar: addComment());
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade50,
      elevation: 1.0,
      leading: IconButton(
          onPressed: () => {
            Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: Palette.colorBlack,
            size: 32,
          )),
      title: Text('Comment', style: Theme.of(context).textTheme.title),
      actions: <Widget>[
        IconButton(
            onPressed: () {},
            icon: Icon(
              OMIcons.nearMe,
              color: Palette.colorBlack,
              size: 32,
            )),
      ],
    );
  }

  Widget textTopStories() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(stories.imageProfile),
            ),
            width: 40,
            height: 40,
            padding: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor, shape: BoxShape.circle),
          ),
          title: Text(
            "${stories.textStories}",
            style: Theme.of(context).textTheme.body1,
          ),
          subtitle: Text(
            "${DateFormat('d MMM').format(DateTime.fromMillisecondsSinceEpoch(stories.timeStamp))}",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget itemComment(Comment comment) {
    return ListTile(
      leading: Container(
        child: CircleAvatar(
          radius: 30,
          backgroundImage: CachedNetworkImageProvider(
            comment.imageProfile,
          ),
        ),
        width: 40,
        height: 40,
        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor, shape: BoxShape.circle),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "${comment.textComment}",
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      subtitle: Text(
        "${DateFormat('d MMM').format(DateTime.fromMillisecondsSinceEpoch(comment.time))}",
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget addComment() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: Offset(0.0, -1.0),
            spreadRadius: 1.0)
      ]),
      child: GestureDetector(
        onTap: _showAddComment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(
                  ShareObjects.prefs
                      .getString(Constants.sessionProfilePictureUrl),
                ),
              ),
              width: 40,
              height: 40,
              padding: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor, shape: BoxShape.circle),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              'Add Comment ...',
              style: Theme.of(context).textTheme.caption,
            )),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(
                Icons.send,
                size: 24.0,
                color: Colors.grey,
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _showAddComment() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ShowAddComment(stories),
          );
        });
  }

//  void _showAddSubComment(index) {
//    showModalBottomSheet(
//        isScrollControlled: true,
//        context: context,
//        builder: (BuildContext context) {
//          return Padding(
//            padding: EdgeInsets.only(
//                bottom: MediaQuery.of(context).viewInsets.bottom),
//            child: ShowAddComment(
//              comment: widget.comment[index],
//              user: currentUser,
//              onPost: (String text) {
//                setState(() {
////                  widget.comment[index].subComment.add(SubComment(
////                    user: currentUser,
////                    timeComment: DateTime.now(),
////                    text: text,
////                    likes: [],
////                  ));
//                });
//
//                Navigator.pop(context);
//              },
//            ),
//          );
//        });
//  }
}
