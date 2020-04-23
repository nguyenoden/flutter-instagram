import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/model/sub_comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';

class Comment {
  final String id;
  final String username;
  final String imageProfile;
  final int time;
  final String textComment;


  Comment(
      {this.username, this.imageProfile, this.id, this.time, this.textComment});


  @override
  String toString() {
    return 'Comment{id: $id, username: $username, imageProfile: $imageProfile, time: $time, textComment: $textComment}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["imageProfile"] = imageProfile;
    map["username"] = username;
    map["id"] = id;
    map["time"] = time;
    map["textComment"] = textComment;

    return map;
  }

  factory Comment.formFireStore(DocumentSnapshot doc) {
    Map map = doc.data;
    return Comment(
        username: map["username"],
        imageProfile: map["imageProfile"],
        id: map["id"],
        time: map["time"],
        textComment: map["textComment"]);

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
