import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/profile_user_follower_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/profile_user_photo_widget.dart';

import 'package:flutter_clb_tinhban_ui_app/widgets/profile_user_stories_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/profile_user_widget.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({Key key, this.uid}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(uid);
}

class _ProfileState extends State<Profile> {
  final String uid;
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _ProfileState(this.uid);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: <Widget>[
              ProfileUserWidget(uid: uid,),
              ProfileUserFollowerWidget(),
             // ProfileUserPhotoWidget(),
              ProfileUserStoriesWidget(uid: uid,)
        ],
      )),
    );
  }
}
