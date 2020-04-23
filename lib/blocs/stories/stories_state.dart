import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StoriesState extends Equatable {
  const StoriesState();
}

class InitialStoriesState extends StoriesState {
  @override
  List<Object> get props => [];
}
class FetchedListUserState extends StoriesState{
  final List<User> listUser;

  FetchedListUserState(this.listUser);
  @override
  // TODO: implement props
  List<Object> get props => [listUser];

}
class FetchingListUserState extends StoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchingListUserState{}';
  }
}

class FetchedListStoriesState extends StoriesState {
  final List<Stories> listStories;
  FetchedListStoriesState(this.listStories);
  @override
  // TODO: implement props
  List<Object> get props => [listStories];
  @override
  String toString() {
    return 'FetchedListStoriesState{listStories: $listStories}';
  }
}
class FetchingListStoriesState extends StoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];
  @override
  String toString() {
    return 'FetchingListStoriesState{}';
  }
}

class ErrorStoriesState extends StoriesState{
  final Exception exception;
  ErrorStoriesState(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
  @override
  String toString() {
    return 'ErrorStoriesState{error: $exception}';
  }

}
class InProgressStoriesState extends StoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'InProgressState{}';
  }
}
class InProgressFinishStoriesState extends StoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'InProgressFinishState{}';
  }
}


class FetchedListCommentsStoriesState extends StoriesState {
  final List<Comment> listComments;

  FetchedListCommentsStoriesState(this.listComments);

  @override
  // TODO: implement props
  List<Object> get props => [listComments];

  @override
  String toString() {
    return 'FetchedCommentsState{listComments: $listComments}';
  }
}
class CheckLikeStoriesState extends StoriesState{
  final bool checkLike;

  CheckLikeStoriesState(this.checkLike);
  @override
  // TODO: implement props
  List<Object> get props => [checkLike];

}
class FetchedStoriesUserState extends StoriesState {
  final List<Stories> listStories;

  FetchedStoriesUserState(this.listStories);

  @override
  String toString() {
    return 'FetchedStoriesUserState{listStories: $listStories}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [listStories];
}

