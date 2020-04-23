import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';

abstract class BaseProvider {
  void dispose();
}

abstract class BaseUserDataProvider extends BaseProvider {
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);

  Future<User> saveProfileDetail(
      String uid, String profileImageUrl, int age, String username);

  Future<bool> isProfileComplete(String uid);

  Stream<List<Contact>> getContacts();

  Future<void> addContact(String username);

  Future<User> getUser(String username);

  Future<String> getUidByUsername(String username);

  Future<void> updateProfilePicture(String profilePictureUrl);
  Stream<User> getProfileUser(String uid);

 Future<void> updateProfileUser(Map mapUser);

  Stream<List<Stories>>getStoriesUser(String uid) ;

  Future<List<String>>getPhotoProfileUser(String uid);
}

abstract class BaseStorageProvider extends BaseProvider {
  Future<String> uploadFile(File file, String path);
}

abstract class BaseChatProvider extends BaseProvider {
  Stream<List<Conversation>> getConversation();

  Stream<List<Message>> getMessages(String chatId);

  Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage);

  Future<List<Message>> getAttachments(String chatId, int type);

  Stream<List<Chat>> getChat();

  Future<void> sendMessage(String chatId, Message message);

  Future<void> getChatIdByUsername(String username);

  Future<void> createChatIdForContact(User user);
}

abstract class BaseDeviceStorageProvider extends BaseProvider {}

abstract class BaseAuthenticationProvider extends BaseProvider {
  Future<FirebaseUser> signInWithGoogle();

  Future<void> signOut();

  Future<FirebaseUser> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<FirebaseUser> signInWithFacebook();
}
abstract class BaseStoriesProvider extends BaseProvider{
  Future <void> sendStories(Stories stories,String docId );
  Stream<List<User>> getListUser();

  Stream<List<Stories>> getListStories();

  Future<void> sendComment(Comment comment,String docId);

  Stream<List<Comment>>getListComments(String docId);

  Future<void>likeStories(String docId,UserBase uid) ;

 Future<void> unLikeStories(String docId, UserBase uid);


 Stream<int> countCommentsStories(String docId) ;
 Stream<List<Comment>> listCommentsStories(String docId);
 Stream<int> countLikeStories(String docId);

  Future<Uint8List>getFileImageShare(String imageUrl);

  Stream<List<Stories>>getStoriesUser(String uid);

}
