import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/photo_full_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerPhotoWidget extends StatelessWidget {
  final photoUrl;


  const ContainerPhotoWidget({Key key, this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: Container(
        width: ScreenUtil().setHeight(250),
        height: ScreenUtil().setHeight(250),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.lightBlueAccent,
            image: DecorationImage(
                image: photoUrl != null
                    ? CachedNetworkImageProvider(photoUrl)
                    : AssetImage(Assets.placeholder),
                fit: BoxFit.cover)),
      ),
    );
  }
}
