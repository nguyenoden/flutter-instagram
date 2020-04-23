import 'dart:async';
import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/util/heart_icon_animator.dart';

import 'package:photo_view/photo_view.dart';

class ImageFullScreen extends StatefulWidget {
  final String url;
  final String tag;
  final String name;

  const ImageFullScreen({Key key, this.url, this.tag, this.name}) : super(key: key);

  @override
  _ImageFullScreenState createState() => _ImageFullScreenState(url,tag,name);
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  final String url;
  final String tag;
  final String name;
   final StreamController<Void> _streamController = StreamController.broadcast();

  _ImageFullScreenState(this.url, this.tag,this.name);
  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: <Widget>[
            PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.url),
              loadFailedChild: Center(
                child: Icon(Icons.error),
              ),
              maxScale: PhotoViewComputedScale.covered * 2,
              minScale: PhotoViewComputedScale.contained * 0.8,
              loadingChild: Center(child: CircularProgressIndicator()),
            ),
            Positioned(
                left: 20,
                top: 20,
                child: GestureDetector(
                  onTap:() =>Navigator.pop(context),
                  child: Container(
                      width:24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Palette.colorWhite,
                        border: Border.all(color: Theme.of(context).accentColor,width: 1),
                        shape: BoxShape.circle
                      ),
                      child: Center(child: Icon(Icons.close,color: Theme.of(context).accentColor,size: 16,))),
                )
            ),
            Positioned(
              left: 40,
              bottom: 20,
              child: HearIconAnimation(
                // isLike: posts.isLikeBy(currentUser),
                color: Palette.colorWhite,
                size: 24,
                triggerAnimationStream: _streamController.stream,
                //  opTap: _toggleIsLike,
              )
            ),
            Positioned(
              right: 40,
              bottom: 20,
              child: Icon(Icons.info_outline,color: Palette.colorWhite,size:24,),
            )
          ],
        ),
      ),
    );
  }
}
