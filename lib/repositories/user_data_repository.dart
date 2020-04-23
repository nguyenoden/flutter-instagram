import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/user_data_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/base_repository.dart';

class UserDataRepository extends BaseRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromGoogle(FirebaseUser user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
          String uid, String profileImageUrl, int age, String username) =>
      userDataProvider.saveProfileDetail(uid, profileImageUrl, age, username);

  Future<bool> isProfileComplete(String uid) =>
      userDataProvider.isProfileComplete(uid);

  Stream<List<Contact>> getContact() => userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<User> getUser(String username) => userDataProvider.getUser(username);

  Future<void> updateProfilePicture(String profilePictureUrl) =>
      userDataProvider.updateProfilePicture(profilePictureUrl);

  Stream<User> getProfileUser(String uid) =>
      userDataProvider.getProfileUser(uid);
  Stream<List<Stories>> getStoriesUser(String uid)=>userDataProvider.getStoriesUser(uid);

  Future<void> updateProfileUser(Map mapUser) =>
      userDataProvider.updateProfileUser(mapUser);

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future<List<String>>getPhotoProfileUser(String uid)=>userDataProvider.getPhotoProfileUser(uid);

}
