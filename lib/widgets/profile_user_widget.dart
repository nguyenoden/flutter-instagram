import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/profile_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/profile_event.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/profile/edit_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUserWidget extends StatefulWidget {
  final String uid;

  const ProfileUserWidget({Key key, this.uid}) : super(key: key);

  @override
  _ProfileUserWidgetState createState() => _ProfileUserWidgetState(uid);
}

class _ProfileUserWidgetState extends State<ProfileUserWidget> {
  final String uid;
  ProfileBloc profileBloc;
  User user;
  File fileImageCover;
  _ProfileUserWidgetState(this.uid);
  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(FetchProfileUserEvent(uid));
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        if (state is FetchedProfileUserState) {
          user = state.user;
          return Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(1200),
                      color: Theme.of(context).primaryColor,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: ScreenUtil().setHeight(1000),
                                    decoration: BoxDecoration(),
                                    child: fileImageCover != null
                                        ? Image.file(
                                            fileImageCover,
                                            fit: BoxFit.cover,
                                            scale: 1,
                                            filterQuality: FilterQuality.high,
                                          )
                                        : user.photoCoverUrl != null
                                            ? Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  user.photoCoverUrl,
                                                  scale: 1,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                Assets.placeholder,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: GestureDetector(
                                        onTap: () async {
                                          await _showDialogImageOption(context);
                                          if (fileImageCover != null) {
                                            profileBloc.add(
                                                UpdateCoverImageProfileUserEvent(
                                                    fileImageCover));
                                          }
                                        },
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 24,
                                          color: Theme.of(context).accentColor,
                                        )),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 120, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user.username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_location,
                                              color:
                                                  Theme.of(context).accentColor,
                                              size: 14,
                                            ),
                                            Text(
                                              user.location ?? 'Chưa biết',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            left: ScreenUtil().setWidth(40),
                            bottom: ScreenUtil().setHeight(70),
                            child: Container(
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    CachedNetworkImageProvider(user.photoUrl),
                              ),
                              width: 90.0,
                              height: 90.0,
                              padding: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(400),
                      child: Column(
                        children: <Widget>[
                          Text(
                            user.introductory ?? "Chưa có lời giới thiệu!",
                            style: Theme.of(context).textTheme.body1,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(60),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.people,
                                      color: Theme.of(context).accentColor,
                                      size: 24,
                                    ),
                                    Text(
                                      "Follower (0)",
                                      style: Theme.of(context).textTheme.body1,
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.photo_library,
                                      color: Theme.of(context).accentColor,
                                      size: 24,
                                    ),
                                    Text(
                                      "Photos (0)",
                                      style: Theme.of(context).textTheme.body1,
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.share,
                                      color: Theme.of(context).accentColor,
                                      size: 24,
                                    ),
                                    Text(
                                      "Share",
                                      style: Theme.of(context).textTheme.body1,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  SlideLeftRout(
                                      page: EditProfile(
                                    user: user,
                                  ))),
                              child: Container(
                                width: double.infinity,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Chỉnh sửa thông tin",
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            ),
          ),
        );
      },
    );
  }



  _showDialogImageOption(BuildContext context) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Choose source',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            children: <Widget>[
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SimpleDialogOption(
                    onPressed: () async {
                      File fileImage = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1080,
                          maxHeight: 1920);
                      if (fileImage != null) {
                        setState(() {
                          fileImageCover = fileImage;
                        });
                      }

                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.photo_library,
                          color: Theme.of(context).accentColor,
                          size: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Image gallery',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            )),
                      ],
                    )),
              ),
              SimpleDialogOption(
                  onPressed: () async {
                    File fileImage = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1920,
                        maxHeight: 1028,
                        imageQuality: 100);
                    if (fileImage != null) {
                      setState(() {
                        fileImageCover = fileImage;
                        print("fileImage : $fileImage");
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).accentColor,
                        size: 24,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Camera ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          )),
                    ],
                  )),
            ],
          );
        });
  }
}
