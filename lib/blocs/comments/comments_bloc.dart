import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/stories_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import './bloc.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final StoriesRepository storiesRepository;
  final StorageRepository storageRepository;
  StreamSubscription streamSubscription;
  Map<String, StreamSubscription> storiesStreamSubscriptionMap = Map();

  CommentsBloc(this.storiesRepository, this.storageRepository)
      : assert(storiesRepository != null),
        assert(storageRepository != null);

  @override
  CommentsState get initialState => InitialCommentsState();

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
   if(event is FetchCommentsEvent){
     yield FetchingListCommentsState();
     yield* mapFetchListCommentsToState(event);

   }
   if(event is ReceivedListCommentsEvent){
     yield FetchedListCommentsState(event.listComments);
   }
   if (event is SendCommentEvent) {
     await sendComment(event);
   }
  }
  Stream <CommentsState> mapFetchListCommentsToState(FetchCommentsEvent event)async* {
    try {
      streamSubscription?.cancel();
      streamSubscription = storiesRepository
          .getListComments(event.docId)
          .listen((comments) => add(ReceivedListCommentsEvent(comments)));

    } on ClbException catch (exception) {
      print(exception);
      yield ErrorCommentsState(exception);
    }



  }
  Future<void> sendComment(SendCommentEvent event) async {
    Comment comment = Comment(
      id: ShareObjects.prefs.getString(Constants.sessionUid),
      imageProfile:
      ShareObjects.prefs.getString(Constants.sessionProfilePictureUrl),
      username: ShareObjects.prefs.getString(Constants.sessionUsername),
      textComment: event.textComment,
      time: DateTime.now().millisecondsSinceEpoch,);
    storiesRepository.sendComment(comment,event.docId);
  }
  @override
  Future<Function> close() {
    streamSubscription.cancel();
    return super.close();
  }
}

