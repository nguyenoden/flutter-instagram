import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommentsState extends Equatable {}

class InitialCommentsState extends CommentsState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchedListCommentsState extends CommentsState {
  final List<Comment> listComments;

  FetchedListCommentsState(this.listComments);

  @override
  // TODO: implement props
  List<Object> get props => [listComments];

  @override
  String toString() {
    return 'FetchedCommentsState{listComments: $listComments}';
  }
}

class FetchingListCommentsState extends CommentsState {
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchingCommentState{}';
  }
}
class ErrorCommentsState extends CommentsState{
  final Exception exception;
  ErrorCommentsState(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
  @override
  String toString() {
    return 'ErrorStoriesState{error: $exception}';
  }

}
