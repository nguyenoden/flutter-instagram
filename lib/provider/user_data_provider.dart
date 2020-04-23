import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';
import 'package:flutter_clb_tinhban_ui_app/dao/contacts_dao.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';

class UserDataProvider extends BaseUserDataProvider {
  final Firestore fireStoreDb;

  UserDataProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Future<void> addContact(String username) async {
    // TODO: implement addContact
    User contactUser = await getUser(username);
    // create a node with the username provider in the contact collection
    CollectionReference collectionReference =
        fireStoreDb.collection(Paths.usersPath);
    DocumentReference documentReference = collectionReference
        .document(ShareObjects.prefs.getString(Constants.sessionUid));
    // await to fetch user detail of the username provider anh set data
    final documentSnapshot = await documentReference.get();
    List<String> contacts = documentSnapshot.data['contacts'] != null
        ? List.from(documentSnapshot.data['contacts'])
        : List();
    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    }
    // add Contact
    contacts.add(username);
    await documentReference.setData({'contacts': contacts}, merge: true);
    // contacts should be added in the contactList of both the user. Adding to the second user here
    String sessionUsername =
        ShareObjects.prefs.getString(Constants.sessionUsername);
    DocumentReference contactRef =
        collectionReference.document(contactUser.documentId);
    final contactSnapshot = await contactRef.get();
    contacts = contactSnapshot.data['contacts'] != null
        ? List.from(contactSnapshot.data['contacts'])
        : List();
    if (contacts.contains(sessionUsername)) {
      throw ContactAlreadyExistsException;
    }
    contacts.add(sessionUsername);
    await contactRef.setData({'contacts': contacts}, merge: true);
  }

  @override
  Stream<List<Contact>> getContacts() {
    CollectionReference userRef = fireStoreDb.collection(Paths.usersPath);
    DocumentReference ref =
        userRef.document(ShareObjects.prefs.getString(Constants.sessionUid));

    return ref.snapshots().transform(
        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(
            handleData: (documentSnapshot, sink) =>
                mapDocumentToContact(userRef, ref, documentSnapshot, sink)));
  }

  void mapDocumentToContact(CollectionReference userRef, DocumentReference ref,
      DocumentSnapshot documentSnapshot, Sink sink) async {
    List<String> contacts;
    if (documentSnapshot.data['contacts'] == null ||
        documentSnapshot.data['chats'] == null) {
      //ref.updateData({'contacts':[]});
      contacts = List();
    } else {
      contacts = List.from(documentSnapshot.data['contacts']);
    }
    ContactsDAO contactsDAO = ContactsDAO();
    List<Contact> contactsList = List();
    Map chats = documentSnapshot.data['chats'];

    for (String username in contacts) {
      String uid = await getUidByUsername(username);

      DocumentSnapshot contactsSnapshot = await userRef.document(uid).get();
      contactsSnapshot.data['chatId'] = chats[username];
      print("contactsSnapshot : ${contactsSnapshot.data['chatId'].toString()}");

      contactsList
          .add(Contact.fromFirestore(contactsSnapshot, chats[username]));
    }

    contactsList.sort((a, b) => a.username.compareTo(b.username));
    print('contactsList $contactsList');
    sink.add(contactsList);
  }

  @override
  Future<String> getUidByUsername(String username) async {
    // get reference to the mapping using username
    DocumentReference ref =
        fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot != null && snapshot.exists && snapshot.data['uid'] != null) {
      return snapshot.data['uid'];
    } else {
      throw UsernamMappingUndefinedException();
    }
  }

  @override
  Future<User> getUser(String username) async {
    String uid = await getUidByUsername(username);

    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid);
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot != null && snapshot.exists) {
      return User.fromFireStore(snapshot);
    } else {
      throw UserNotException();
    }
  }

  @override
  Future<bool> isProfileComplete(String uid) async {
    // TODO: implement isProfileComplete
    DocumentReference ref = fireStoreDb
        .collection(Paths.usersPath)
        .document(ShareObjects.prefs.getString(Constants.sessionUid));
    final DocumentSnapshot currentDocument = await ref.get();

    // check if exits, if yes then check if username and age field
    // are there or not. If not then profile incomplete else complete

    final bool isProfileComplete = currentDocument != null &&
        currentDocument.exists &&
        currentDocument.data.containsKey('photoUrl') &&
        currentDocument.data.containsKey('username') &&
        currentDocument.data.containsKey('age');
    print(isProfileComplete);
    if (isProfileComplete) {
      await ShareObjects.prefs.setString(
          Constants.sessionUsername, currentDocument.data['username']);
      await ShareObjects.prefs
          .setString(Constants.sessionName, currentDocument.data['name']);
      await ShareObjects.prefs.setString(
          Constants.sessionProfilePictureUrl, currentDocument.data['photoUrl']);
    }

    return isProfileComplete;
  }

  @override
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    // TODO: implement saveDetailsFromGoogleAuth
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(user.uid);
    final bool userExits =
        !await ref.snapshots().isEmpty; // check if user exits or not
    var data = {
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
    };
    // if user entry exist then we would not want to override the photo url
    if (!userExits) {
      data['photoUrl'] = user.photoUrl;
    }
    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();
    await ShareObjects.prefs
        .setString(Constants.sessionUsername, user.displayName);
    return User.fromFireStore(currentDocument);
  }

  @override
  Future<User> saveProfileDetail(
      String uid, String profileImageUrl, int age, String username) async {
    String uid = ShareObjects.prefs.getString(Constants.sessionUid);
    // get a reference to the map
    DocumentReference mapReference =
        fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
    var mapData = {'uid': uid};
    // map the uid to the username
    mapReference.setData(mapData);
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid);
    var data = {'photoUrl': profileImageUrl, 'age': age, 'username': username};
    await ref.setData(data, merge: true); // set the photoUrl ,age,username
    final DocumentSnapshot currentDocument =
        await ref.get(); // get updated data back from firestore
    await ShareObjects.prefs.setString(Constants.sessionUsername, username);
    await ShareObjects.prefs.setString(
        Constants.sessionProfilePictureUrl, currentDocument.data['photoUrl']);
    return User.fromFireStore(
        currentDocument); // create a user object and return it
  }

  @override
  Future<void> updateProfilePicture(String profilePictureUrl) async {
    String uid = ShareObjects.prefs.getString(Constants.sessionUid);
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid);
    var data = {'photoUrl': profilePictureUrl};
    await ref.setData(data, merge: true);
  }

  Stream<User> getProfileUser(String uid) {
    DocumentReference profileUserDocRef =
        fireStoreDb.collection(Paths.usersPath).document(uid);

    return profileUserDocRef.snapshots().transform(
        StreamTransformer<DocumentSnapshot, User>.fromHandlers(
            handleData:
                (DocumentSnapshot documentSnapshot, EventSink<User> sink) =>
                    mapDocumentToMessage(documentSnapshot, sink)));
  }

  void mapDocumentToMessage(
      DocumentSnapshot documentSnapshot, EventSink sink) async {
    print(documentSnapshot);
    sink.add(User.fromFireStore(documentSnapshot));
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<void> updateProfileUser(Map mapUser) {
    DocumentReference documentReference = fireStoreDb
        .collection(Paths.usersPath)
        .document(ShareObjects.prefs.getString(Constants.sessionUid));
    documentReference.updateData(mapUser);
    return null;
  }

  @override
  Stream<List<Stories>> getStoriesUser(String uid) {
    CollectionReference collectionReference =
        fireStoreDb.collection(Paths.storiesPath);
    return collectionReference
        .where("uid",isEqualTo: uid)
        //.orderBy("uid")
        .limit(20)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Stories>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Stories>> sink) =>
                    mapQuerySnapshotToStories(querySnapshot, sink)));

  }
  mapQuerySnapshotToStories(QuerySnapshot querySnapshot, EventSink sink) {
    List<Stories> listStories = List();
    if (querySnapshot != null) {
      querySnapshot.documents.forEach(
          (stories) => listStories.add(Stories.fromFireStore(stories)));
    }
    sink.add(listStories);
  }

  @override
  Future<List<String>> getPhotoProfileUser(String uid) async {




    return null;
  }


}
