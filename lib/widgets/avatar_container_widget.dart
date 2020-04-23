import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/styles.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progressive_image/progressive_image.dart';

class AvatarContainerWidget extends StatelessWidget {
  final User user;
  final int totalPosts;
  final BuildContext context;

  const AvatarContainerWidget(
      {Key key, this.user, this.totalPosts = 0, this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.photoUrl == null) {
      return SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setHeight(300),
                  height: ScreenUtil().setHeight(440),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlueAccent,
                      image: DecorationImage(
                          image: user.photoUrl != null
                              ? CachedNetworkImageProvider(user.photoUrl)
                              : AssetImage(Assets.placeholder),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(colors: [
                         Palette.gradientStartColor, // Orange
                         Palette.gradientEndColor,
                        ])),
                    child: Center(
                      child: Text(
                        '$totalPosts',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  left: 10,
                  child: Text(
                    '${user.username}',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
