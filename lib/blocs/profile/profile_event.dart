import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}
class InitialProfileEvent extends ProfileEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'InitialProfileEvent{}';
  }
}

class FetchProfileUserEvent extends ProfileEvent {
  final String uid;

  FetchProfileUserEvent(this.uid);

  @override
  // TODO: implement props
  List<Object> get props => [uid];

  @override
  String toString() {
    return 'FetchProfileUserEvent{uid: $uid}';
  }
}

class ReceivedProfileUserEvent extends ProfileEvent {
  final User user;

  ReceivedProfileUserEvent(this.user);

  @override
  // TODO: implement props
  List<Object> get props => [user];

  @override
  String toString() {
    return 'ReceviedProfileUserEvent{user: $user}';
  }
}

class UpdateProfileUserEvent extends ProfileEvent {
  final String name;
  final String username;
  final num age;
  final File photoUrl;
  final String photoCurrentUrl;
  final num phoneNumber;
  final String sex;
  final String introductory;
  final String location;
  final String dateOfBirth;


  UpdateProfileUserEvent(this.name, this.username, this.age, this.photoUrl,
      this.phoneNumber, this.sex, this.dateOfBirth, this.photoCurrentUrl, this.introductory, this.location);

  @override
  // TODO: implement props
  List<Object> get props => [name, username, age, photoUrl, phoneNumber, sex,photoCurrentUrl,introductory,location];

  @override
  String toString() {
    return 'UpdateProfileUserEvent{name: $name, username: $username, age: $age, photoUrl: $photoUrl, photoCurrentUrl: $photoCurrentUrl, phoneNumber: $phoneNumber, sex: $sex, introductory: $introductory, location: $location, dateOfBirth: $dateOfBirth}';
  }
}
class UpdateCoverImageProfileUserEvent extends ProfileEvent{
  final File coverImageProfile;

  UpdateCoverImageProfileUserEvent(this.coverImageProfile);

  @override
  // TODO: implement props
  List<Object> get props => [coverImageProfile];

  @override
  String toString() {
    return 'UpdateCoverImageProfileUserEvent{listImage: $coverImageProfile}';
  }
}
class FetchStoriesUserEvent extends ProfileEvent{
  final String uidDoc;

  FetchStoriesUserEvent(this.uidDoc);
  @override
  // TODO: implement props
  List<Object> get props => [uidDoc];

  @override
  String toString() {
    return 'FetchStoriesUserEvent{uidDoc: $uidDoc}';
  }
}
class ReceivedStoriesUserEvent extends ProfileEvent{
  final List<Stories> listStories;

  ReceivedStoriesUserEvent(this.listStories);

  @override
  // TODO: implement props
  List<Object> get props => [listStories];

  @override
  String toString() {
    return 'ReceivedStoriesUserEvent{listStories: $listStories}';
  }
}
class FetchPhotoProfileUser extends ProfileEvent{
  final String uid;

  FetchPhotoProfileUser(this.uid);
  @override
  // TODO: implement props
  List<Object> get props => [uid];

  @override
  String toString() {
    return 'FetchPhotoProfileUser{uid: $uid}';
  }
}
