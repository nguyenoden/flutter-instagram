import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileUserFollowerWidget extends StatefulWidget {

  @override
  _ProfileUserFollowerWidgetState createState() => _ProfileUserFollowerWidgetState();
}

class _ProfileUserFollowerWidgetState extends State<ProfileUserFollowerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(300),
        decoration: Decorations.boxDecorationStories(context),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Follower (1)",
                      style: Theme.of(context).textTheme.body1),
                  Text("Xem tất cả",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize:
                        ScreenUtil().setSp(35, allowFontScalingSelf: true),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 40,
                      //backgroundImage: file!=null?FileImage(file):null,
                    ),
                    width: 60.0,
                    height: 60.0,
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

