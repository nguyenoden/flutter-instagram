//import 'package:flutter/material.dart';
//import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
//
//class AvatarCircleWidget extends StatelessWidget {
//  final User user;
//  final double isLarge;
//  final VoidCallback opTap;
//  final bool isShowNameLabel;
//  final bool isCurrentUserStory;
//  final EdgeInsetsGeometry padding;
//
//  const AvatarCircleWidget(
//      {Key key,
//      @required this.user,
//      @required this.isLarge,
//      this.opTap,
//      this.isShowNameLabel = false,
//      this.isCurrentUserStory = false,
//      this.padding =
//          const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10)})
//      : super(key: key);
//
//  static const _gradientBorderDecoration = BoxDecoration(
//      shape: BoxShape.circle,
//      gradient: SweepGradient(colors: [
//        Color(0xFF833AC5), // Purple
//        Color(0xFFF77737), // Orange
//        Color(0xFFE1306C),
//        Color(0xFFF06292),
//        Color(0xFF26C6DA), // Red-pink
//        Color(0xFFAB47BC),
//        Color(0xFF833AC5) // Red-purple
//      ]));
//  static const _whiteBorderDecoration = BoxDecoration(
//      shape: BoxShape.circle,
//      border: Border.fromBorderSide(BorderSide(
//        color: Colors.white,
//        width: 1.0,
//      )));
//  static const _greyShadowDecoration = BoxDecoration(
//      shape: BoxShape.circle,
//      boxShadow: [
//        BoxShadow(color: Colors.grey, blurRadius: 1.0, spreadRadius: 1.0)
//      ]);
//
//  @override
//  Widget build(BuildContext context) {
//    final radius = isLarge;
//    final avatar = Container(
//      width: radius * 2 + 10.0,
//      height: radius * 2 + 10.0,
//      child: Column(
//        mainAxisSize: MainAxisSize.max,
//        children: <Widget>[
//          Container(
//            width: radius * 2 + 6.0,
//            height: radius * 2 + 6.0,
//            decoration: user.stories.isEmpty ? null : _gradientBorderDecoration,
//            child: Stack(
//              alignment: Alignment.center,
//              children: <Widget>[
//                Container(
//                  decoration: _whiteBorderDecoration,
//                  child: Container(
//                    decoration: _greyShadowDecoration,
//                    child: CircleAvatar(
//                      radius: radius,
//                      backgroundImage: AssetImage(user.photoUrl),
//                    ),
//                  ),
//                ),
//                if (isCurrentUserStory && user.stories.isEmpty)
//                  Positioned(
//                    right: 2.0,
//                    bottom: 2.0,
//                    child: Container(
//                      width: 16.0,
//                      height: 16.0,
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.blue,
//                          border: Border.all(color: Colors.white)),
//                      child: Icon(
//                        Icons.add,
//                        color: Colors.white,
//                        size: 16.0,
//                      ),
//                    ),
//                  )
//              ],
//            ),
//          ),
//          if (isShowNameLabel)
//            Padding(
//              padding: EdgeInsets.only(top: 2.0),
//              child: Text(
//                isCurrentUserStory ? 'Your story' : user.name,
//                style: Theme.of(context).textTheme.subtitle,
//                textScaleFactor: 0.8,
//                maxLines: 1,
//                overflow: TextOverflow.ellipsis,
//              ),
//            )
//        ],
//      ),
//    );
//    return Padding(
//      padding: this.padding,
//      child: GestureDetector(
//        onTap: opTap,
//        child: avatar,
//      ),
//    );
//  }
//}
