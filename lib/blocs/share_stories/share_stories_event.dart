import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShareStoriesEvent extends Equatable {
}
class InitialShareStoriesEvent extends ShareStoriesEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'InitialShareStoriesEvent{}';
  }
}
class SendShareStoriesEvent extends ShareStoriesEvent {
  final String textStories;
  final List<File> listImage;
  final String location;
  final int timePost;
  final List<Comment> listComment;

  SendShareStoriesEvent(
      this.textStories, this.listImage, this.location, this.timePost,this.listComment);

  @override
  // TODO: implement props
  List<Object> get props => [textStories, listImage, location, timePost,listComment];

  @override
  String toString() {
    return 'SendShareStoriesEvent{textStories: $textStories, listImage: $listImage, location: $location, timePost: $timePost,listComment:$listComment}';
  }
}

class ShareButtonEvent extends ShareStoriesEvent{
  final String imageUrl;

  ShareButtonEvent(this.imageUrl);
  @override
  // TODO: implement props
  List<Object> get props => [imageUrl];

  @override
  String toString() {
    return 'ShareButtonEvent{}';
  }
}
class ReceivedImageShareEvent extends ShareStoriesEvent{
  final  Uint8List fileImage;

  ReceivedImageShareEvent(this.fileImage);
  @override
  // TODO: implement props
  List<Object> get props => [fileImage];

  @override
  String toString() {
    return 'ShareButtonEvent{}';
  }
}
