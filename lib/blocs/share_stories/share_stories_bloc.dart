import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/stories_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/file_compress.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:path/path.dart';
import './bloc.dart';

class ShareStoriesBloc extends Bloc<ShareStoriesEvent, ShareStoriesState> {
  final StoriesRepository storiesRepository;
  final StorageRepository storageRepository;
   Firestore firestore=Firestore.instance;

  ShareStoriesBloc(this.storiesRepository, this.storageRepository)
      : assert(storiesRepository != null),
        assert(storageRepository != null);

  @override
  ShareStoriesState get initialState => InitialShareStoriesState();

  @override
  Stream<ShareStoriesState> mapEventToState(
    ShareStoriesEvent event,
  ) async* {
    if (event is InitialShareStoriesEvent) {
      yield InitialShareStoriesState();
    }
    if (event is SendShareStoriesEvent) {
      yield InProgressShareStoriesState();
      await sendShareStories(event);
      yield InProgressFinishShareStoriesState();
    }
    if(event is ShareButtonEvent){
      yield InProgressShareStoriesState();
      await getFileImageShare(event);

    }
    if(event is ReceivedImageShareEvent){
      yield ShareImageForApplicationState(event.fileImage);
    }
  }

  Future<void> sendShareStories(SendShareStoriesEvent event) async {
    Stories stories;
    List<String> listStringImage = List();
    List<String> imageUrl = List();
    List<File> imageCompress = List();
    if (event.listImage.isNotEmpty) {
      List<File> listFile = event.listImage;
      for (int i = 0; i < listFile.length; i++) {
        listStringImage.add(basename(listFile[i].path));
        assert(listFile[i] != null);
        imageCompress.add(await FileCompress().imageCompress(listFile[i]));
        assert(imageCompress[i] != null);
        imageUrl.add(await storageRepository.uploadFile(
            imageCompress[i], Paths.imageStoriesPath));
      }
    }
    DocumentReference documentReference=firestore.collection(Paths.storiesPath).document();
    stories = Stories(
      documentId: documentReference.documentID,
      uid: ShareObjects.prefs.getString(Constants.sessionUid),
      username: ShareObjects.prefs.getString(Constants.sessionUsername),
      imageProfile: ShareObjects.prefs.getString(Constants.sessionProfilePictureUrl),
      textStories: event.textStories,
      fileImage: listStringImage,
      location: event.location,
      timeStamp: event.timePost,
      latestComment: null,
      imageUrl: imageUrl,
      like: null,
    );
    await storiesRepository.sendStories(stories,documentReference.documentID);
  }
  Future<void> getFileImageShare(ShareButtonEvent event)async{
    Uint8List fileImage= await storiesRepository.getFileImageShare(event.imageUrl);
    add(ReceivedImageShareEvent(fileImage));
  }


}


