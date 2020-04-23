import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/storage_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/stories_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/clb_exception.dart';
import './bloc.dart';

class UserStoriesBloc extends Bloc<UserStoriesEvent, UserStoriesState> {
  final StoriesRepository storiesRepository;
  final StorageRepository storageRepository;
  StreamSubscription streamSubscription;
  Map<String, StreamSubscription> storiesStreamSubscriptionMap = Map();

  UserStoriesBloc(this.storiesRepository, this.storageRepository)
      : assert(storiesRepository != null),
        assert(storageRepository != null);
  @override
  UserStoriesState get initialState => InitialUserStoriesState();

  @override
  Stream<UserStoriesState> mapEventToState(
    UserStoriesEvent event,
  ) async* {
    if (event is FetchListUserEvent) {
      yield* mapFetchListUserToState(event);
    }
    if (event is ReceivedListUserEvent) {
      yield FetchedListUserState(event.listUser);
    }

  }
  Stream<UserStoriesState> mapFetchListUserToState(
      FetchListUserEvent event) async* {
    try {
      streamSubscription?.cancel();
      streamSubscription = storiesRepository
          .getListUser()
          .listen((user) => add(ReceivedListUserEvent(user)));
    } on ClbException  catch (exception) {
      print(exception);
      yield ErrorStoriesState(exception);
    }
  }
}
