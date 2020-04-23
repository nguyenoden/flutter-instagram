
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';



class SubComment {
  final UserBase user;
  final List<UserBase> likes;
  final int  time;
 final  String textComment;

  SubComment(
      {@required this.user,
      @required this.time,
      @required this.textComment,
      @required this.likes});

  @override
  String toString() {
    return 'SubComment{user: $user, likes: $likes, time: $time, textComment: $textComment}';
  }
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map();
    map["user"]=user;
    map["likes"]=likes;
    map["time"]=time;
    map["textComment"]=textComment;
    return map;
  }
  factory SubComment.formFireStore(DocumentSnapshot doc) {
    Map map = doc.data;

    return SubComment(
        user: map["user"],
        likes: map["likes"],
        time: map["time"],
        textComment: map["textComment"],
        );
  }


//  bool isLikeBy(User user) {
//    return likes.any((like) => like.user.name == user.name);
//  }
//
//  void toggleLikeFor(User user) {
//    if (isLikeBy(user)) {
//      likes.removeWhere((likes) => likes.user.name == user.name);
//    } else {
//      likes.add(Like(user: user));
//    }
//  }
}
