import 'package:flutter/material.dart';

import 'package:flutter_clb_tinhban_ui_app/widgets/post_image_stories_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/stories_top_user_widget.dart';

import 'package:flutter_clb_tinhban_ui_app/widgets/stories_widget.dart';


class StoriesPage extends StatefulWidget {
  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  _scrollToTop() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//        backgroundColor: Colors.black12,
//        appBar: PreferredSize(
//          preferredSize: Size.fromHeight(50.0),
//          child: AppBar(
//            elevation: 1,
//            centerTitle: true,
//            title: Text(
//              ' Test ',
//              style: Theme.of(context).textTheme.title,
//            ),
//          ),
//        ),
        body: ListView(
          controller: scrollController,
          shrinkWrap: true,
          children: <Widget>[
            PostImageStoriesWidget(),
            StoriesTopUserWidget(),
            StoriesWidget()
          ],
        ),
      ),
    );
//    return Scaffold(
//        backgroundColor: Colors.black12,
//        appBar: PreferredSize(
//          preferredSize: Size.fromHeight(50.0),
//          child: AppBar(
//            elevation: 1,
//            centerTitle: true,
//            title: Text(
//              ' Test ',
//              style: Theme.of(context).textTheme.title,
//            ),
//          ),
//        ),
//        body: BlocConsumer<StoriesBloc, StoriesState>(
//            bloc: storiesBloc,
//            listener: (context, state) {
//              if (state is FetchedListStoriesState) {
//                listStories = state.listStories;
//              }
//
//            },
//            builder: (context, state) {
//              if (state is FetchingListStoriesState) {
//                return Center(
//                  child: CircularProgressIndicator(
//                    valueColor: AlwaysStoppedAnimation<Color>(
//                        Theme.of(context).accentColor),
//                  ),
//                );
//              }
//              return ListView.builder(
//                key: localKey,
//                addAutomaticKeepAlives: true,
//                itemCount: listStories.length + 2,
//                controller: _scrollController,
//                scrollDirection: Axis.vertical,
//                itemBuilder: (ctx, i) {
//                  if (i == 0) {
//                    return postStoriesWidget();
//                  }
//                  if (i == 1) {
//                    return TopUserStoriesWidget();
//                  } else {
//                    return AnimationConfiguration.synchronized(
//                        duration: Duration(milliseconds: 150),
//                        child: SlideAnimation(
//                          verticalOffset: 50.0,
//                          child: FadeInAnimation(
//                            child: PostStoriesWidget(listStories[i - 2]),
//                          ),
//                        ));
//                  }
//                },
//              );
//            }));
  }
//  Widget postStoriesWidget() {
//    return Padding(
//      padding: const EdgeInsets.all(5.0),
//      child: Container(
//          constraints: BoxConstraints(
//              maxHeight: ScreenUtil().setHeight(200),
//              maxWidth: double.infinity),
//          height: ScreenUtil().setHeight(560),
//          decoration: Decorations.boxDecorationStories(context),
//          child: Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Container(
//                    child: CircleAvatar(
//                      radius: 30,
//                      backgroundImage: CachedNetworkImageProvider(ShareObjects
//                          .prefs
//                          .getString(Constants.sessionProfilePictureUrl)),
//                    ),
//                    width: 50.0,
//                    height: 50.0,
//                    padding: EdgeInsets.all(1.0),
//                    decoration: BoxDecoration(
//                        color: Theme.of(context).accentColor,
//                        shape: BoxShape.circle),
//                  ),
//                  SizedBox(
//                    width: 20,
//                  ),
//                  FlatButton(
//                      onPressed: () {
//                        Navigator.push(
//                            context, SlideLeftRout(page: ShareStoriesWidget()));
//                      },
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(30)),
//                          side:
//                              BorderSide(color: Theme.of(context).accentColor)),
//                      color: Theme.of(context).primaryColor,
//                      child: Text(
//                        'Bạn đang nghĩ gì?',
//                        style: Theme.of(context).textTheme.body1,
//                      )),
//                  IconButton(
//                    onPressed: () async {
//                      try {
//                        fileImage = await ImagePicker.pickImage(
//                            source: ImageSource.camera,
//                            imageQuality: 100,
//                            maxHeight: 1920,
//                            maxWidth: 1028);
//                        if (fileImage != null) {
//                          Navigator.push(
//                              context,
//                              SlideLeftRout(
//                                  page: ShareStoriesWidget(
//                                fileImage: fileImage,
//                              )));
//                        }
//                      } catch (e) {
//                        print(e);
//                      }
//                    },
//                    icon: Icon(
//                      Icons.camera,
//                      size: 24,
//                      color: Theme.of(context).accentColor,
//                    ),
//                  )
//                ],
//              ))),
//    );
//  }
}
