import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/share_stories_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class PostImageStoriesWidget extends StatelessWidget {
  File fileImage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          constraints: BoxConstraints(
              maxHeight: ScreenUtil().setHeight(200),
              maxWidth: double.infinity),
          height: ScreenUtil().setHeight(560),
          decoration: Decorations.boxDecorationStories(context),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(ShareObjects
                          .prefs
                          .getString(Constants.sessionProfilePictureUrl)),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context, SlideLeftRout(page: ShareStoriesWidget()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          side:
                          BorderSide(color: Theme.of(context).accentColor)),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Bạn đang nghĩ gì?',
                        style: Theme.of(context).textTheme.body1,
                      )),
                  IconButton(
                    onPressed: () async {
                      try {
                        fileImage = await ImagePicker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 100,
                            maxHeight: 1920,
                            maxWidth: 1028);
                        if (fileImage != null) {
                          Navigator.push(
                              context,
                              SlideLeftRout(
                                  page: ShareStoriesWidget(
                                    fileImage: fileImage,
                                  )));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    icon: Icon(
                      Icons.camera,
                      size: 24,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ],
              ))),
    );
  }
}
