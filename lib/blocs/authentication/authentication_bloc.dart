import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_state.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/authentication_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/user_data_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/file_compress.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  AuthenticationBloc(
      {this.authenticationRepository,
      this.userDataRepository,
      this.storageRepository})
      : assert(authenticationRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    print(event);
    if (event is AppLaunched) {
      yield* mapAppLaunchToState();
    }
    if (event is ClickedGoogleLoggedIn) {
      yield* mapClickedGoogleLoggedInToSate();
    }
    if ((event is ClickedFaceBookLoggedIn)) {
      yield* mapClickFaceBookLoggedInToState();
    }
    if (event is LoggedIn) {
      yield* mapLoggedInToSate(event.user);
    }
    if (event is PickedProfilePicture) {
      yield ReceivedProfilePicture(event.fileImage);
    }
    if (event is SaveProfile) {
      yield* mapSaveProfileToSate(
          event.profileImage, event.age, event.username);
    }
    if (event is ClickedLogout) {
      yield* mapLoggedOutToSate();
    }
  }

  Stream<AuthenticationState> mapAppLaunchToState() async* {
    try {
      yield AuthInProgress();
      final isSignedIn = await authenticationRepository.isLoggedIn();
      if (isSignedIn) {
        final user = await authenticationRepository.getCurrent();
        bool isProfileComplete =
            await userDataRepository.isProfileComplete(user.uid);
        if (isProfileComplete) {
          yield ProfileUpdated();
        } else {
          yield Authenticated(user);
          add(LoggedIn(user));
        }
      } else {
        yield UnAuthenticated();
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapClickedGoogleLoggedInToSate() async* {
    yield AuthInProgress(); // show progress bar
    try {
      // show the google auth prompt and wait for user selection, retrieve the selected account
      FirebaseUser firebaseUser =
          await authenticationRepository.signInWithGoogle();

      // check if the user's profile is complete
      bool isProfileComplete =
          await userDataRepository.isProfileComplete(firebaseUser.uid);
      if (isProfileComplete) {
        //if profile is complete go to home page
        yield ProfileUpdated();
      } else {
        // else yield the authenticated state and redirect to profile page to complete profile.
        yield Authenticated(firebaseUser);
        add(LoggedIn(firebaseUser));
      }
    } catch (error) {
      print(error);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapClickFaceBookLoggedInToState() async* {
    yield AuthInProgress(); // show progress bar
    try {
      // show the google auth prompt and wait for user selection, retrieve the selected account
      FirebaseUser firebaseUser =
          await authenticationRepository.signInWithFacebook();
      // check if the user's profile is complete
      bool isProfileComplete =
          await userDataRepository.isProfileComplete(firebaseUser.uid);
      if (isProfileComplete) {
        //if profile is complete go to home page
        yield ProfileUpdated();
      } else {
        // else yield the authenticated state and redirect to profile page to complete profile.
        yield Authenticated(firebaseUser);
        add(LoggedIn(firebaseUser));
      }
    } catch (error) {
      print(error);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapLoggedInToSate(
      FirebaseUser firebaseUser) async* {
    yield ProfileUpdateInProgress();
    User user = await userDataRepository.saveDetailsFromGoogle(firebaseUser);
    yield PreFillData(user);
  }

  Stream<AuthenticationState> mapSaveProfileToSate(
      File profileImage, int age, String username) async* {
    yield ProfileUpdateInProgress();
    String profilePictureUrl;

    if (profileImage != null) {
      File profileImageCompress =
          await FileCompress().profileImageCompress(profileImage);

      String url = await storageRepository.uploadFile(
          profileImageCompress, Paths.profilePicturePath);
      profilePictureUrl = url;
    }
    FirebaseUser user = await authenticationRepository.getCurrent();
    await userDataRepository.saveProfileDetails(
        user.uid, profilePictureUrl, age, username);
    yield ProfileUpdated();
  }

  Stream<AuthenticationState> mapLoggedOutToSate() async* {
    yield UnAuthenticated();
    authenticationRepository.signOut();
  }
}
