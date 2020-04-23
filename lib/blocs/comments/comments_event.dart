import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommentsEvent extends Equatable{



  CommentsEvent();
}
class FetchCommentsEvent extends CommentsEvent{
 final String docId;
 FetchCommentsEvent(this.docId);
 @override
 List<Object> get props =>[docId];


  @override
  String toString() {
    return 'FetchCommentsEvent{}';
  }

}
class ReceivedListCommentsEvent extends CommentsEvent{
  final List<Comment> listComments;

  ReceivedListCommentsEvent(this.listComments);

  @override
  String toString() {
    return 'ReceivedListStoriesEvent{listComments: $listComments}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [listComments];
}
class SendCommentEvent extends CommentsEvent {
  final String textComment;
  final String docId;

  SendCommentEvent(this.textComment, this.docId);

  @override
  List<Object> get props => [textComment,docId];

  @override
  String toString() {
    return 'SendCommentEvent{textComment: $textComment}';
  }

}