import 'dart:async';
import 'dart:ffi';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/profile_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/profile_event.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/user_stories_widget.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/show_add_comment.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/show_all_comments.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/storie_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_clb_tinhban_ui_app/util/count_image_post.dart';
import 'package:flutter_clb_tinhban_ui_app/util/read_more_text.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/photo_full_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';

class PostStoriesWidget extends StatefulWidget {
  final Stories stories;
  const PostStoriesWidget(this.stories) : super();
  @override
  _PostStoriesWidgetState createState() => _PostStoriesWidgetState(stories);
}

class _PostStoriesWidgetState extends State<PostStoriesWidget> {
  final Stories stories;
  int _currentImageIndex = 0;
  bool isSave = false;
  PageController pageController;
  StreamController<Void> streamCountImage = StreamController.broadcast();
  Firestore fireStoreDb = Firestore.instance;
  StoriesProvider storiesProvider = StoriesProvider();
  bool isLiked;
  int countComments;
  int countLikes;
  StoriesBloc storiesBloc;
  List<Comment> listComments = List();
  StreamSubscription streamCountComments;
  StreamSubscription streamListComments;
  ProfileBloc profileBloc;
  _PostStoriesWidgetState(this.stories);


//  StreamSubscription streamCountLikeStories;

  @override
  void initState() {
    super.initState();
    profileBloc=BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(FetchProfileUserEvent(stories.uid));
    storiesBloc = BlocProvider.of<StoriesBloc>(context);

    pageController = PageController();
    checkLikeStories();
    checkListCommentStories();
    checkCountCommentStories();
    // checkCountLikeStories();
  }

  checkListCommentStories() async {
    streamListComments?.cancel();
    streamListComments = StoriesProvider()
        .listCommentsStories(stories.documentId)
        .listen((listComment) => listComments = listComment);
  }

  checkCountCommentStories() async {
    streamCountComments?.cancel();
    streamCountComments = StoriesProvider()
        .countCommentsStories(stories.documentId)
        .listen((count) => countComments = count);
  }

//  checkCountLikeStories() async {
//    streamCountLikeStories?.cancel();
//    streamCountLikeStories = StoriesProvider()
//        .countLikeStories(stories.documentId)
//        .listen((count) => countLikes = count);
//  }
//  checkLikeStories()async{
//    streamLikeStories?.cancel();
//    streamLikeStories = StoriesProvider()
//        .checkLikeStories(stories.documentId,ShareObjects.prefs.getString(Constants.sessionUid))
//        .listen((isLike) =>
//    isLiked = isLike);
//  }

  checkLikeStories() async {
     var documentSnapshot = await fireStoreDb
        .collection(Paths.storiesPath)
        .document(stories.documentId)
        .collection(Paths.likePath)
        .document(ShareObjects.prefs.getString(Constants.sessionUid))
        .get();
    if (this.mounted) {
      setState(() {
        isLiked = documentSnapshot.exists ? true : false;
      });
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    isLiked
        ? storiesBloc.add(UnLikeStoriesEvent(stories.documentId))
        : storiesBloc.add(LikeStoriesEvent(stories.documentId));
    return !isLiked;
  }

  void _updateImageIndex(int index) {
    setState(() {
      _currentImageIndex = index;
      streamCountImage.sink.add(null);
    });
  }

  @override
  void dispose() {
    //streamCountLikeStories.cancel();
    streamListComments.cancel();
    pageController.dispose();
    streamCountImage.close();
    streamCountComments.cancel();
    super.dispose();
  }

  void _toggleIsSave() {
    setState(() => isSave = !isSave);
  }

  void _showAddComment() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ShowAddComment(stories),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: Decorations.boxDecorationStories(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserStoriesWidget(stories: stories),
            if (stories.imageUrl.length == 1)
              _storiesImageOne(stories.imageUrl),
            if (stories.imageUrl.length == 2)
              _storiesImageTwo(stories.imageUrl),
            if (stories.imageUrl.length == 3)
              _storiesImageThree(stories.imageUrl),
            if (stories.imageUrl.length == 4)
              _storiesImageFour(stories.imageUrl),
            if (stories.imageUrl.length > 4)
              _storiedImageSix(stories.imageUrl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: LikeButton(
                    isLiked: isLiked,
                    onTap: onLikeButtonTapped,
                    size: 28,
                    circleColor: CircleColor(
                        start: Palette.gradientStartColor,
                        end: Palette.gradientEndColor),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Palette.gradientStartColor,
                      dotSecondaryColor: Palette.gradientEndColor,
                    ),
                    likeBuilder: (bool isLiked) {
                      return isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.pinkAccent,
                              size: 28,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 28,
                            );
                    },
//                    likeCount: countLikes,
//                    countBuilder: (int count, bool isLiked, String text) {
//                      var color = isLiked ? Colors.pinkAccent : Colors.grey;
//                      Widget result;
//                      if (count == 0) {
//                        result = Text(
//                          "love",
//                          style: TextStyle(color: color),
//                        );
//                      } else
//                        result = Text(
//                          text,
//                          style: TextStyle(color: color),
//                        );
//                      return result;
//                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowAllComments(
                                stories: stories,
                              ))),
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 28,
                    color: Palette.colorBlack,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    OMIcons.nearMe,
                    size: 28,
                    color: Palette.colorBlack,
                  ),
                ),
                Spacer(),
                if (stories.imageUrl.length > 4)
                  ScrollingPageIndicator(
                    controller: pageController,
                    dotSize: 4,
                    dotColor: Colors.grey,
                    itemCount: stories.imageUrl.length,
                    dotSelectedColor: Colors.lightBlue,
                    dotSpacing: 12,
                    orientation: Axis.horizontal,
                    dotSelectedSize: 6,
                    visibleDotCount: 5,
                    visibleDotThreshold: 2,
                  ),
                Spacer(),
                IconButton(
                    onPressed: _toggleIsSave,
                    icon: isSave
                        ? Icon(
                            Icons.bookmark,
                            size: 28,
                            color: Palette.accentColorDart,
                          )
                        : Icon(
                            Icons.bookmark_border,
                            size: 28,
                            color: Colors.black,
                          ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: ReadMoreText(
                stories.textStories,
                trimLines: 1,
                colorClickableText: Colors.grey,
                trimMode: TrimMode.Line,
                trimCollapsedText: '...more',
                trimExpandedText: ' less',
                name: stories.username,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            if (listComments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ReadMoreText(
                  listComments[0].textComment,
                  trimLines: 1,
                  colorClickableText: Colors.grey,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...more',
                  trimExpandedText: ' less',
                  name: listComments[0].username,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
              child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowAllComments(
                                stories: stories,
                              ))),
                  child: Text(
                    'View all $countComments comments... ',
                    style: Theme.of(context).textTheme.caption,
                  )),
            ),
            //if (stories.latestComment != null)
            //_commentWidget(),
            _showAddBottomComment()
          ],
        ),
      ),
    );
  }

  Widget _showAddBottomComment() {
    return GestureDetector(
      onTap: _showAddComment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Palette.colorGrey.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(ShareObjects
                        .prefs
                        .getString(Constants.sessionProfilePictureUrl)),
                  ),
                  width: 30.0,
                  height: 30.0,
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Add a comment...',
                  style: Theme.of(context).textTheme.caption,
                ),
                Spacer(),
                Icon(
                  Icons.add_circle_outline,
                  size: 18.0,
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listUserComments() {
    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          child: ListView.builder(
              itemCount: listComments.length,
              itemBuilder: (BuildContext context, int index) {
                return ReadMoreText(
                  listComments[index].textComment,
                  trimLines: 1,
                  colorClickableText: Colors.grey,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...more',
                  trimExpandedText: ' less',
                  name: listComments[index].username,
                  style: Theme.of(context).textTheme.body1,
                );
              }),
        ));
  }

  Widget _storiesImageOne(List<dynamic> imageUrl) {
    return Center(
      child: ClipRRect(child: _imageWidget(imageUrl, 0)),
    );
  }

  Widget _storiesImageTwo(List<dynamic> imageUrl) {
    return Container(
      height: ScreenUtil().setHeight(1000),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: _imageWidget(imageUrl, 0)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: _imageWidget(imageUrl, 1)),
            ),
          )
        ],
      ),
    );
  }

  Widget _storiesImageThree(List<dynamic> imageUrl) {
    return Container(
      height: ScreenUtil().setHeight(1000),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: _imageWidget(imageUrl, 0)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: _imageWidget(imageUrl, 1)),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: _imageWidget(imageUrl, 2)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _storiesImageFour(List<dynamic> imageUrl) {
    return Container(
      height: ScreenUtil().setHeight(1200),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: _imageWidget(imageUrl, 0)),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: _imageWidget(imageUrl, 1)),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: _imageWidget(imageUrl, 2)),
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: _imageWidget(imageUrl, 3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storiedImageSix(List<dynamic> imageUrl) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(1000),
            child: PageView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      SlideLeftRout(
                          page: PhotoFullScreen(
                        name: stories.username,
                        tag: "${stories.textStories}",
                        url: imageUrl,
                        imageIndex: index,
                        //imageIndex: index,
                      ))),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
              onPageChanged: _updateImageIndex,
              controller: pageController,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Positioned(
              right: 10,
              top: 10,
              child: CountImagePost(
                triggerAnimationStream: streamCountImage.stream,
                index: _currentImageIndex,
                size: stories.imageUrl.length,
              )),
        ],
      ),
      // onDoubleTap: __onDoubleTapLikePhoto,
    );
  }



  Widget _imageWidget(List<dynamic> imageUrl, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          SlideLeftRout(
              page: PhotoFullScreen(
            name: stories.username,
            tag: "${stories.textStories}",
            url: imageUrl,
            imageIndex: index,
          ))),
      child: CachedNetworkImage(
        imageUrl: imageUrl[index],
        fit: BoxFit.cover,
      ),
    );
  }
}

