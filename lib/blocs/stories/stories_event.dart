import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StoriesEvent extends Equatable {
  const StoriesEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchListUserEvent extends StoriesEvent{
  @override
  String toString() {
    return 'FetchListUserEvent{}';
  }
}
class ReceivedListUserEvent extends StoriesEvent{
  final List<User> listUser;

  ReceivedListUserEvent(this.listUser);

  @override
  // TODO: implement props
  List<Object> get props => [listUser];

  @override
  String toString() {
    return 'ReceivedListUserEvent{listUser: $listUser}';
  }
}
class FetchListStoriesEvent extends StoriesEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchListStoriesEvent{}';
  }
}
class ReceivedListStoriesEvent extends StoriesEvent{
 final  List<Stories> listStories;
  ReceivedListStoriesEvent(this.listStories);
  @override
  // TODO: implement props
  List<Object> get props => [listStories];

 @override
  String toString() {
    return 'ReceivedListStoriesEvent{listStories: $listStories}';
 }
}


class FetchDetailCommentsEvent extends StoriesEvent {
  final List<Comment> listComments;

  FetchDetailCommentsEvent(this.listComments);

  @override
  List<Object> get props => [listComments];

  @override
  String toString() {
    return 'FetchDetailCommentsEvent{listComments: $listComments}';
  }
}
class ReceivedDetailCommentEvent extends StoriesEvent{
  final List<Comment> listComment;
  ReceivedDetailCommentEvent(this.listComment);
  @override
  // TODO: implement props
  List<Object> get props => null;
  @override
  String toString() {
    return 'ReceivedDetailCommentEvent{listComment: $listComment}';
  }
}
class FetchCommentsStoriesEvent extends StoriesEvent{
  final String docId;
  FetchCommentsStoriesEvent(this.docId);
  @override
  List<Object> get props =>[docId];
  @override
  String toString() {
    return 'FetchCommentsEvent{}';
  }
}
class LikeStoriesEvent extends StoriesEvent{
  final String docId;


  LikeStoriesEvent(this.docId, );
  @override
  // TODO: implement props
  List<Object> get props => [docId];

  @override
  String toString() {
    return 'LikeStoriesEvent{docId: $docId}';
  }
}
class UnLikeStoriesEvent extends StoriesEvent{
  final String docId;


  UnLikeStoriesEvent(this.docId);
  @override
  // TODO: implement props
  List<Object> get props => [docId];

  @override
  String toString() {
    return 'UnLikeStoriesEvent{docId: $docId}';
  }
}
class CheckLikeStoriesEvent extends StoriesEvent{
  final String docId;

  CheckLikeStoriesEvent(this.docId);
  @override
  // TODO: implement props
  List<Object> get props => [docId];

  @override
  String toString() {
    return 'CheckLikeStoriesEvent{docId: $docId}';
  }
}
class FetchStoriesUserEvent extends StoriesEvent{
  final String uidDoc;

  FetchStoriesUserEvent(this.uidDoc);
  @override
  // TODO: implement props
  List<Object> get props => [uidDoc];

  @override
  String toString() {
    return 'FetchStoriesUserEvent{uidDoc: $uidDoc}';
  }
}
class ReceivedStoriesUserEvent extends StoriesEvent{
  final List<Stories> listStories;

  ReceivedStoriesUserEvent(this.listStories);

  @override
  // TODO: implement props
  List<Object> get props => [listStories];

  @override
  String toString() {
    return 'ReceivedStoriesUserEvent{listStories: $listStories}';
  }
}


