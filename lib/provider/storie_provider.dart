import 'dart:async';
import 'dart:io';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';

import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';


class StoriesProvider extends BaseStoriesProvider {
  final Firestore fireStoreDb;

  StoriesProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance
          ..settings(persistenceEnabled: true);

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<void> sendStories(Stories stories, String docId) async {
    DocumentReference documentReference =
        fireStoreDb.collection(Paths.storiesPath).document(docId);
    documentReference.setData(stories.toMap());
  }

  Stream<List<User>> getListUser() {
    CollectionReference collectionReference =
        fireStoreDb.collection(Paths.usersPath);
    return collectionReference.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<User>> sink) =>
                    mapDocumentToUser(querySnapshot, sink)));
  }

  void mapDocumentToUser(QuerySnapshot querySnapshot, EventSink sink) {
    print("documentSnapshot: ${querySnapshot.documents}");
    List<User> listUser = List();
    if (querySnapshot != null) {
      querySnapshot.documents
          .forEach((doc) => listUser.add(User.fromFireStore(doc)));
    }
    print(" ${listUser.length}");
    sink.add(listUser);
  }

  @override
  Stream<List<Stories>> getListStories() {
    CollectionReference collectionReference =
        fireStoreDb.collection(Paths.storiesPath);
    return collectionReference
        .orderBy("timeStamp", descending: true)
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
  Future<void> sendComment(Comment comment, String docId) async {
    DocumentReference documentReference = fireStoreDb
        .collection(Paths.storiesPath)
        .document(docId)
        .collection(Paths.commentPath)
        .document();
    documentReference.setData(comment.toMap());

    DocumentReference docref =
        fireStoreDb.collection(Paths.storiesPath).document(docId);
    docref.updateData({"latestComment": comment.toMap()});
  }

  @override
  Stream<List<Comment>> getListComments(String docId) {
    CollectionReference collectionReference = fireStoreDb
        .collection(Paths.storiesPath)
        .document(docId)
        .collection(Paths.commentPath);

    return collectionReference
        .orderBy('time', descending: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Comment>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Comment>> sink) =>
                    mapQuerySnapshotToComments(querySnapshot, sink)));
  }

  mapQuerySnapshotToComments(QuerySnapshot querySnapshot, EventSink sink) {
    List<Comment> listComments = List();
    if (querySnapshot != null) {
      querySnapshot.documents.forEach(
          (comments) => listComments.add(Comment.formFireStore(comments)));
    }
    sink.add(listComments);
  }

  @override
  Future<void> likeStories(String docId, UserBase userBase) async {
    try {
      DocumentReference documentReference =
          fireStoreDb.collection(Paths.storiesPath).document(docId);
      documentReference.updateData({"like": userBase.toMap()});
      CollectionReference collectionReference = fireStoreDb
          .collection(Paths.storiesPath)
          .document(docId)
          .collection(Paths.likePath);
      collectionReference.document(userBase.id).setData(userBase.toMap());
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Future<void> unLikeStories(String docId, UserBase userBase) async {
    try {
      var documentReference = await fireStoreDb
          .collection(Paths.storiesPath)
          .document(docId)
          .collection(Paths.likePath)
          .document(userBase.id)
          .get();
      documentReference.reference.delete();
//      var documentReference = fireStoreDb
//          .collection(Paths.storiesPath)
//          .document(docId)
//          .collection(Paths.likePath)
//          .where("id", isEqualTo: userBase.id);
//      documentReference.getDocuments().then((querySnapshot) {
//        querySnapshot.documents.forEach((doc) {
//          doc.reference.delete();
//        });
//      });
    } catch (exception) {
      print(exception);
    }
  }


  @override
  Stream<int> countCommentsStories(String docId) {
    var collectionReference = fireStoreDb
        .collection(Paths.storiesPath)
        .document(docId)
        .collection(Paths.commentPath);
    return collectionReference
        .snapshots(includeMetadataChanges: true)
        .transform(StreamTransformer.fromHandlers(
            handleData: (QuerySnapshot querySnapshot, EventSink<int> sink) =>
                sink.add(querySnapshot.documents.length)));
  }

  @override
  Stream<List<Comment>> listCommentsStories(String docId) {
    var collectionReference = fireStoreDb
        .collection(Paths.storiesPath)
        .document(docId)
        .collection(Paths.commentPath);
    return collectionReference
        .orderBy("time", descending: true)
       // .where('id',isEqualTo:ShareObjects.prefs.getString(Constants.sessionUid))
        .limit(1)
        .snapshots(includeMetadataChanges: true)
        .transform(StreamTransformer.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Comment>> sink) =>
                    mapQuerySnapshotToListComment(querySnapshot, sink)));
  }

  mapQuerySnapshotToListComment(QuerySnapshot querySnapshot, EventSink sink) {
    List<Comment> listComments = List();
    if (querySnapshot != null) {
      querySnapshot.documents.forEach(
          (comments) => listComments.add(Comment.formFireStore(comments)));
    }
    sink.add(listComments);
  }

  @override
  Stream<int> countLikeStories(String docId) {
    var collectionReference = fireStoreDb
        .collection(Paths.storiesPath)
        .document(docId)
        .collection(Paths.likePath);
    return collectionReference
        .snapshots(includeMetadataChanges: true)
        .transform(StreamTransformer.fromHandlers(
        handleData: (QuerySnapshot querySnapshot, EventSink<int> sink) =>
            sink.add(querySnapshot.documents.length)));
  }

  @override
  Future<Uint8List> getFileImageShare(String imageUrl) async{
        var request = await HttpClient().getUrl(Uri.parse(imageUrl));
       var response = await request.close();
        Uint8List fileImage = await consolidateHttpClientResponseBytes(response);

    return fileImage;
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
                mapQuerySnapshotToStoriesUser(querySnapshot, sink)));

  }
  mapQuerySnapshotToStoriesUser(QuerySnapshot querySnapshot, EventSink sink) {
    List<Stories> listStories = List();
    if (querySnapshot != null) {
      querySnapshot.documents.forEach(
              (stories) => listStories.add(Stories.fromFireStore(stories)));
    }
    sink.add(listStories);
  }

//  Stream<bool> checkLikeOrUnLikeStories(String docId){
//    var documentReference = fireStoreDb
//        .collection(Paths.storiesPath)
//        .document(docId)
//        .collection(Paths.likePath).document(ShareObjects.prefs.getString(Constants.sessionUid));
//
//    return documentReference.snapshots(includeMetadataChanges: true).transform(
//        StreamTransformer.fromHandlers(
//            handleData: (DocumentSnapshot documentSnapshot, EventSink<bool> sink) =>
//                sink.add(documentSnapshot.exists)));
//
//  }





}
