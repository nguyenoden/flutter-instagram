import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/data.dart';

import 'package:flutter_clb_tinhban_ui_app/model/sub_comment.dart';
import 'package:flutter_clb_tinhban_ui_app/util/heart_icon_animator.dart';
import 'package:flutter_clb_tinhban_ui_app/util/read_more_text.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;

  const CommentWidget(this.comment);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  void _toggleIsLikeComment() {
//    setState(() => widget.comment.toggleLikeFor(currentUser));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: ReadMoreText(
                   'nguyen',
                    trimLines: 2,
                    colorClickableText: Colors.grey,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...more',
                    trimExpandedText: ' less',
                    name: 'nguyen'),
              ),
              Expanded(
                flex: 1,
                child: HearIconAnimation(
                 // isLike: widget.comment.isLikeBy(currentUser),
                  size: 14.0,
                  opTap: _toggleIsLikeComment,
                ),
              ),
            ],
          ),
//          if (widget.comment.subComment.isNotEmpty)
//            Column(
//              children: widget.comment.subComment
//                  .map((SubComment c) => SubCommentWidget(c))
//                  .toList(),
//            )
        ],
      ),
    );
  }
}

class SubCommentWidget extends StatefulWidget {
  final SubComment subComment;

  const SubCommentWidget(this.subComment);

  @override
  _SubCommentWidgetState createState() => _SubCommentWidgetState();
}

class _SubCommentWidgetState extends State<SubCommentWidget> {
  void _toggleIsLikeComment() {
//    setState(() => widget.subComment.toggleLikeFor(currentUser));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 17,
            child: ReadMoreText(
                "nguyen",
                trimLines: 2,
                colorClickableText: Colors.grey,
                trimMode: TrimMode.Line,
                trimCollapsedText: '...more',
                trimExpandedText: ' less',
                name: 'nguyen'),
          ),
          Expanded(
            flex: 2,
            child: HearIconAnimation(
              //isLike: widget.subComment.isLikeBy(currentUser),
              size: 14.0,
              opTap: _toggleIsLikeComment,
            ),
          ),
        ],
      ),
    );
  }
}
