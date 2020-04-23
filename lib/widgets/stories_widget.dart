import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/stories_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/stories_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/stories_state.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/post_stories_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
class StoriesWidget extends StatefulWidget {
  @override
  _StoriesWidgetState createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  ScrollController _scrollController;
  StoriesBloc storiesBloc;
  List<Stories> listStories = List();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    storiesBloc = BlocProvider.of<StoriesBloc>(context);
    storiesBloc.add(FetchListStoriesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, StoriesState>(
        bloc: storiesBloc,
        builder: (context, state) {
          if (state is FetchedListStoriesState) {
            listStories = state.listStories;
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // addAutomaticKeepAlives: true,
                itemCount: listStories.length,
                controller: _scrollController,
                //scrollDirection: Axis.vertical,
                itemBuilder: (ctx, i) {
                  return AnimationConfiguration.synchronized(
                      duration: Duration(milliseconds: 150),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: PostStoriesWidget(listStories[i]),
                        ),
                      ));
                });
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme
                      .of(context)
                      .accentColor),
            ),
          );
        });
  }
}
