import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserStoriesState extends Equatable {}

class InitialUserStoriesState extends UserStoriesState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
class FetchedListUserState extends UserStoriesState{
  final List<User> listUser;

  FetchedListUserState(this.listUser);
  @override
  // TODO: implement props
  List<Object> get props => [listUser];

}
class FetchingListUserState extends UserStoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchingListUserState{}';
  }

}
class ErrorStoriesState extends UserStoriesState{
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
