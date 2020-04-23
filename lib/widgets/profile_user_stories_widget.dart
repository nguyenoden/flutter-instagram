import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:flutter_clb_tinhban_ui_app/blocs/stories/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/post_stories_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/profile_user_photo_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProfileUserStoriesWidget extends StatefulWidget {
  final String uid;

  const ProfileUserStoriesWidget({Key key, this.uid}) : super(key: key);

  @override
  _ProfileUserStoriesWidgetState createState() =>
      _ProfileUserStoriesWidgetState(uid);
}

class _ProfileUserStoriesWidgetState extends State<ProfileUserStoriesWidget> {
  final String uid;
  StoriesBloc storiesBloc;
  ScrollController scrollController;
  List<Stories> listStories;
  List<String> listPhotos = List();

  @override
  void initState() {
    listPhotos.clear();
    storiesBloc = BlocProvider.of<StoriesBloc>(context);
    storiesBloc.add(FetchStoriesUserEvent(uid));
    scrollController = ScrollController();
    super.initState();
  }


  _ProfileUserStoriesWidgetState(this.uid);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, StoriesState>(
      bloc: storiesBloc,
      builder: (context, state) {
        if (state is FetchedStoriesUserState) {
          listStories = state.listStories;
          listPhotos.clear();
          for (int i = 0; i <listStories.length; i++) {
            listStories[i].imageUrl.forEach((url) => listPhotos.add(url));
          }

          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // scrollDirection: Axis.vertical,
              controller: scrollController,
              itemCount: listStories.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ProfileUserPhotoWidget(listPhotos: listPhotos,);
                } else {
                  return AnimationConfiguration.synchronized(
                      duration: Duration(milliseconds: 150),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: PostStoriesWidget(listStories[index]),
                        ),
                      ));
                }
              });
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(Theme
                .of(context)
                .accentColor),
          ),
        );
      },
    );
  }
}
