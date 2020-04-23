import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => null;
}

class ClickedGoogleLoggedIn extends AuthenticationEvent {
  @override
  String toString() {
    return 'ClickedGoogleLogin';
  }
}

class ClickedFaceBookLoggedIn extends AuthenticationEvent {
  @override
  String toString() {
    return 'ClickedFaceBookLoggedIn';
  }
}

class AppLaunched extends AuthenticationEvent {
  @override
  String toString() {
    return 'AppLaunched';
  }
}

class LoggedIn extends AuthenticationEvent {
  final FirebaseUser user;
  LoggedIn(this.user);
  @override
  List<Object> get props => [user];
  @override
  String toString() {
    return 'LoggedIn :{ user: $user}';
  }
}

class PickedProfilePicture extends AuthenticationEvent {
  final File fileImage;
  PickedProfilePicture(this.fileImage);
  @override
  String toString() => 'PickedProfilePicture: {fileImage: $fileImage}';
  @override
  List<Object> get props => [fileImage];
}

class SaveProfile extends AuthenticationEvent {
  final File profileImage;
  final int age;
  final String username;
  SaveProfile(this.profileImage, this.age, this.username) : super();
  @override
  List<Object> get props => [profileImage, age, username];

  @override
  String toString() {
    return 'SaveProfile: {profileImage: $profileImage, age: $age, username: $username}';
  }
}

class ClickedLogout extends AuthenticationEvent {
  @override
  String toString() => 'ClickedLogout';
}
