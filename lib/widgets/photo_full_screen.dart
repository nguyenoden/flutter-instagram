import 'dart:async';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/share_stories/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/util/heart_icon_animator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';

class PhotoFullScreen extends StatefulWidget {
  final List<dynamic> url;
  final String tag;
  final String name;
  final int imageIndex;

  const PhotoFullScreen(
      {Key key, this.url, this.tag, this.name, this.imageIndex})
      : super(key: key);

  @override
  _PhotoFullScreenState createState() =>
      _PhotoFullScreenState(url, tag, name, imageIndex);
}

class _PhotoFullScreenState extends State<PhotoFullScreen> {
  final List<dynamic> url;
  final String tag;
  final String name;
  final StreamController<Void> _streamController = StreamController.broadcast();
  PageController pageController;
  final int imageIndex;
  ShareStoriesBloc shareStoriesBloc;

  _PhotoFullScreenState(this.url, this.tag, this.name, this.imageIndex);

  int shareIndex = 0;

  @override
  void initState() {
    shareStoriesBloc = BlocProvider.of<ShareStoriesBloc>(context);
    pageController = PageController(initialPage: imageIndex, keepPage: false);

    super.initState();
  }

  void _updateImageIndex(int index) {
    setState(() {
      shareIndex = index;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: BlocListener<ShareStoriesBloc, ShareStoriesState>(
              listener: (context, state) {
                if (state is ShareImageForApplicationState) {
                  Share.file(
                      'ESYS AMLOG', 'amlog.jpg', state.fileImage, 'image/jpg');
                }
              },
              child: Stack(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      PhotoViewGallery.builder(
                        backgroundDecoration: BoxDecoration(color: Colors.black),
                        pageController: pageController,
                        onPageChanged: _updateImageIndex,
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider: CachedNetworkImageProvider(url[index]),
                            initialScale: PhotoViewComputedScale.contained * 1,
                            heroAttributes: PhotoViewHeroAttributes(tag: url[index]),
                          );
                        },
                        itemCount: url.length,
                        loadingBuilder: (context, event) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              value: event == null
                                  ? 0
                                  : event.cumulativeBytesLoaded /
                                      event.expectedTotalBytes,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: ScreenUtil().setWidth(1000),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: HearIconAnimation(
                                    // isLike: posts.isLikeBy(currentUser),
                                    color: Palette.colorWhite,
                                    size: 24,
                                    triggerAnimationStream: _streamController.stream,
                                    //  opTap: _toggleIsLike,
                                  ),
                                ),
                                ScrollingPageIndicator(
                                  controller: pageController,
                                  dotSize: 4,
                                  dotColor: Colors.grey,
                                  itemCount: url.length,
                                  dotSelectedColor: Theme.of(context).accentColor,
                                  dotSpacing: 12,
                                  orientation: Axis.horizontal,
                                  dotSelectedSize: 6,
                                  visibleDotCount: 5,
                                  visibleDotThreshold: 2,
                                ),
                                IconButton(
                                    onPressed: () async => {
                                          shareStoriesBloc
                                              .add(ShareButtonEvent(url[imageIndex]))
                                        },
                                    icon: Icon(
                                      Icons.share,
                                      color: Palette.colorWhite,
                                      size: 24,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: Palette.colorWhite,
                                  border: Border.all(
                                      color: Theme.of(context).accentColor, width: 1),
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                color: Theme.of(context).accentColor,
                                size: 16,
                              ))),
                        ),
                      ),
                    ],
                  ),

                  BlocBuilder<ShareStoriesBloc, ShareStoriesState>(
                    bloc: shareStoriesBloc,
                    builder: (context,state){
                      if( state is InProgressShareStoriesState){
                        return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                 strokeWidth: 2.0 ,

                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Loading image..',
                                  style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12),
                                )
                              ],
                            ));
                      }
                      return SizedBox();
                    },
                  )


                ],
              )
          )
      ),
    );
  }

  Future<void> share(dynamic imageUrl) async {
//    var request = await HttpClient().getUrl(Uri.parse(imageUrl));
//    var response = await request.close();
//    Uint8List bytes = await consolidateHttpClientResponseBytes(response);

//    await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
  }
}
