import 'package:flutter/cupertino.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/like.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

class Post {
  final User user;
  List<Like> likes;
  List<Comment> comments;
  final DateTime timePost;
  String description;
  List<String> imgUrls;

  Post(
      {@required this.user,
      @required this.timePost,
      @required this.likes,
      @required this.comments,
      this.description,
      @required this.imgUrls});

//  bool isLikeBy(User user) {
//    return likes.any((like) => like.user.name == user.name);
//  }
//
//  void addLikeIfUnlikeFor(User user) {
//    if (!isLikeBy(user)) {
//      likes.add(Like(user: user));
//    }
//  }
//
//  void toggleLikeFor(User user) {
//    if (isLikeBy(user)) {
//      likes.removeWhere((like) => like.user.name == user.name);
//    } else {
//    addLikeIfUnlikeFor(user);
//    }
//  }
}
