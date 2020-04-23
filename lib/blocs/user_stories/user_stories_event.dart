import 'package:equatable/equatable.dart';

import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserStoriesEvent extends Equatable{
  const UserStoriesEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchListUserEvent extends UserStoriesEvent{
  @override
  String toString() {
    return 'FetchListUserEvent{}';
  }
}
class ReceivedListUserEvent extends UserStoriesEvent{
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
class LikeStoriesEvent extends UserStoriesEvent{
  final String uid;

  LikeStoriesEvent(this.uid);
  @override
  // TODO: implement props
  List<Object> get props => [uid];

  @override
  String toString() {
    return 'LikeStoriesEvent{uid: $uid}';
  }
}
class UnLikeStoriesEvent extends UserStoriesEvent{
  final String uid;

  UnLikeStoriesEvent(this.uid);
  @override
  // TODO: implement props
  List<Object> get props => [uid];


  @override
  String toString() {
    return 'UnLikeStoriesEvent{uid: $uid}';
  }
}
