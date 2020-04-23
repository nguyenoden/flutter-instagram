import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class InitialProfileState extends ProfileState {
  @override
  List<Object> get props => [];
}

class FetchingProfileUserState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchingProfileUserState{}';
  }
}

class FetchedProfileUserState extends ProfileState {
  final User user;

  FetchedProfileUserState(this.user);

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class FetchedStoriesUserState extends ProfileState {
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

class FetchingStoriesUserState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchingStoriesUserState{}';
  }
}

class InProgressState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'InProgressState{}';
  }
}

class FinishProgressState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'FinishProgressState{}';
  }
}
