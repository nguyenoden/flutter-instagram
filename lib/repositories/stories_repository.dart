import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/storie_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/base_repository.dart';

class StoriesRepository extends BaseRepository {
  BaseStoriesProvider storiesProvider = StoriesProvider();
  Future<void> sendStories(Stories stories,String docId) => storiesProvider.sendStories(stories, docId);
  Stream<List<Stories>> getListStories() => storiesProvider.getListStories();
  Future<void> sendComment(Comment comment,String docId)=>storiesProvider.sendComment(comment,docId);
  Stream<List<User>>getListUser() =>storiesProvider.getListUser();
  Stream<List<Comment>> getListComments( String docId) => storiesProvider.getListComments(docId);
  Future<void> likeStories(String docId,UserBase userBase)=>storiesProvider.likeStories(docId,userBase);
  Future<void> unLikeStories(String docId,UserBase userBase)=>storiesProvider.unLikeStories(docId,userBase);

  Future<Uint8List> getFileImageShare( String imageUrl)=>storiesProvider.getFileImageShare(imageUrl);
  Stream<List<Stories>> getStoriesUser(String uid)=>storiesProvider.getStoriesUser(uid);


  @override
  void dispose() {
    // TODO: implement dispose
  }




}
