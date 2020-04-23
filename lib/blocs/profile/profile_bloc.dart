import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';

import 'package:flutter_clb_tinhban_ui_app/provider/user_data_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';

import 'package:flutter_clb_tinhban_ui_app/repositories/user_data_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';
import 'package:flutter_clb_tinhban_ui_app/util/file_compress.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserDataRepository userDataRepository;
  final UserDataProvider userDataProvider;
  final StorageRepository storageRepository;
  StreamSubscription streamSubscription;

  ProfileBloc(
      this.userDataRepository, this.userDataProvider, this.storageRepository)
      : assert(userDataRepository != null),
        assert(userDataProvider != null),
        assert(storageRepository != null);

  @override
  ProfileState get initialState => InitialProfileState();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is InitialProfileEvent) {
      yield InitialProfileState();
    }
    if (event is FetchProfileUserEvent) {
      //yield FetchingStoriesUserState();
      yield* mapFetchProfileUserToState(event);
    }
    if (event is ReceivedProfileUserEvent) {
      yield FetchedProfileUserState(event.user);
    }
    if (event is UpdateProfileUserEvent) {
      yield InProgressState();
      await updateProfileUser(event);
      yield FinishProgressState();
    }
    if (event is UpdateCoverImageProfileUserEvent) {
      await updateCoverImageProfileUser(event);
    }
    if (event is FetchPhotoProfileUser) {

    await getPhotoProfileUser(event);
    }
//    if (event is ReceivedStoriesUserEvent) {
//      yield FetchedStoriesUserState(event.listStories);
//    }
  }

  Stream<ProfileState> mapFetchStoriesUserToState(
      FetchStoriesUserEvent event) async* {
    try {
      streamSubscription?.cancel();
      streamSubscription = userDataRepository
          .getStoriesUser(event.uidDoc)
          .listen((stories) => add(ReceivedStoriesUserEvent(stories)));
    } on ClbException catch (exception) {
      print(exception);
    }
  }

  Stream<ProfileState> mapFetchProfileUserToState(
      FetchProfileUserEvent event) async* {
    try {
      streamSubscription?.cancel();
      streamSubscription = userDataRepository
          .getProfileUser(event.uid)
          .listen((user) => add(ReceivedProfileUserEvent(user)));
    } on ClbException catch (exception) {
      print("exception : $exception");
    }
  }

  Future<void> updateProfileUser(UpdateProfileUserEvent event) async {
    String profilePictureUrl;
    Map<String, dynamic> mapUser = Map();
    if (event.photoUrl != null) {
      File profileImageCompress =
          await FileCompress().profileImageCompress(event.photoUrl);

      profilePictureUrl = await storageRepository.uploadFile(
          profileImageCompress, Paths.profilePicturePath);
      ShareObjects.prefs.setString(Constants.sessionProfilePictureUrl, profilePictureUrl);
    }
    mapUser["username"] = event.username ?? "";
    mapUser["name"] = event.name ?? "";
    mapUser["age"] = event.age;
    mapUser["photoUrl"] = profilePictureUrl ?? event.photoCurrentUrl ?? "";
    mapUser["phoneNumber"] = event.phoneNumber;
    mapUser["sex"] = event.sex ?? "";
    mapUser["dateOfBirth"] = event.dateOfBirth;
    mapUser["location"] = event.location ?? "";
    mapUser["introductory"] = event.introductory ?? "";

    await userDataRepository.updateProfileUser(mapUser);
  }

  Future<void> updateCoverImageProfileUser(
      UpdateCoverImageProfileUserEvent event) async {
    String coverImageProfileUrl;
    Map<String, dynamic> map = Map();
    if (event.coverImageProfile != null) {
      File coverImageProfileCompress =
          await FileCompress().imageCompress(event.coverImageProfile);
      coverImageProfileUrl = await storageRepository.uploadFile(
          coverImageProfileCompress, Paths.profilePicturePath);
    }
    map["photoCoverUrl"] = coverImageProfileUrl;
    await userDataRepository.updateProfileUser(map);
  }

  Future<void>getPhotoProfileUser(FetchPhotoProfileUser event) async{
    List<String> listPhotoUrl;
    listPhotoUrl= await userDataRepository.getPhotoProfileUser(event.uid);

  }
}
