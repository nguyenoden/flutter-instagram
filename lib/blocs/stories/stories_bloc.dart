import 'dart:async';
import 'dart:math';


import 'package:bloc/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';

import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/stories_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import './bloc.dart';
class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final StoriesRepository storiesRepository;
  final StorageRepository storageRepository;
  StreamSubscription streamSubscription;
  Map<String, StreamSubscription> storiesStreamSubscriptionMap = Map();

  StoriesBloc(this.storiesRepository, this.storageRepository)
      : assert(storiesRepository != null),
        assert(storageRepository != null);

  @override
  StoriesState get initialState => InitialStoriesState();

  @override
  Stream<StoriesState> mapEventToState(
    StoriesEvent event,
  ) async* {
    print(event);
    if (event is FetchListStoriesEvent) {
      yield FetchingListStoriesState();
      yield* mapFetchListStoriesToState(event);

    }
    if (event is ReceivedListStoriesEvent) {
      yield FetchedListStoriesState(event.listStories);
    }
    if (event is LikeStoriesEvent) {
      await likeStories(event);
    }
    if( event is UnLikeStoriesEvent){
      await unLikeStories(event);
    }
    if (event is FetchStoriesUserEvent) {

      yield* mapFetchStoriesUserToState(event);
    }
    if (event is ReceivedStoriesUserEvent) {
      yield FetchedStoriesUserState(event.listStories);
    }
  }
  Stream<StoriesState> mapFetchStoriesUserToState(
      FetchStoriesUserEvent event) async* {
    try {
      streamSubscription?.cancel();
      streamSubscription = storiesRepository
          .getStoriesUser(event.uidDoc)
          .listen((stories) => add(ReceivedStoriesUserEvent(stories)));
    } on ClbException catch (exception) {
      print(exception);
    }
  }



  Stream<StoriesState> mapFetchListStoriesToState(
      FetchListStoriesEvent event) async* {
    try {
      streamSubscription?.cancel();
      streamSubscription = storiesRepository
          .getListStories()
          .listen((stories) => add(ReceivedListStoriesEvent(stories)));
    } on ClbException catch (exception) {
      print(exception);
      yield ErrorStoriesState(exception);
    }
  }

  Future<void> likeStories(LikeStoriesEvent event) async {
    UserBase userBase = UserBase(
        userName: ShareObjects.prefs.getString(Constants.sessionUsername),
        imageUrl:
            ShareObjects.prefs.getString(Constants.sessionProfilePictureUrl),
        id: ShareObjects.prefs.getString(Constants.sessionUid));

    await storiesRepository.likeStories(
      event.docId,userBase
    );
  }
  Future<void> unLikeStories(UnLikeStoriesEvent event) async {
    UserBase userBase = UserBase(
        userName: ShareObjects.prefs.getString(Constants.sessionUsername),
        imageUrl:
        ShareObjects.prefs.getString(Constants.sessionProfilePictureUrl),
        id: ShareObjects.prefs.getString(Constants.sessionUid));

    await storiesRepository.unLikeStories(
        event.docId,userBase
    );
  }
  Stream<bool>checkLikeStories( CheckLikeStoriesEvent event)async*{

    UserBase userBase = UserBase(
        userName: ShareObjects.prefs.getString(Constants.sessionUsername),
        imageUrl:
        ShareObjects.prefs.getString(Constants.sessionProfilePictureUrl),
        id: ShareObjects.prefs.getString(Constants.sessionUid));


  }


  @override
  Future<Function> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
