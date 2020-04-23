import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => null;
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() {
    return 'Uninitialized';
  }
}

class AuthInProgress extends AuthenticationState {
  @override
  String toString() {
    return 'AuthInprogress';
  }
}

class Authenticated extends AuthenticationState {
  final FirebaseUser user;
  Authenticated(this.user);
  @override
  List<Object> get props => [user];
  @override
  String toString() {
    return 'Authenticated : { user: $user}';
  }
}

class UnAuthenticated extends AuthenticationState {
  @override
  String toString() {
    return 'UnAuthenticated';
  }
}

class ReceivedProfilePicture extends AuthenticationState {
  final File fileImage;
  ReceivedProfilePicture(this.fileImage);
  @override
  toString() => 'ReceivedProfilePicture : {fileimage: $fileImage}';
  @override
  List<Object> get props => [fileImage];
}

class ProfileUpdated extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdated';
}

class ProfileUpdateInProgress extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class PreFillData extends AuthenticationState {
  final User user;

  PreFillData(this.user);

  @override
  String toString() => 'PreFillData : {user: $user}';

  @override
  List<Object> get props => [user];
}
