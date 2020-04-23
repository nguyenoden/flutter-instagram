//import 'package:flutter/material.dart';
//import 'package:flutter_clb_tinhban_ui_app/model/data.dart';
//import 'package:flutter_clb_tinhban_ui_app/model/sub_comment.dart';
//import 'package:flutter_clb_tinhban_ui_app/widgets/avatar_circle_widget.dart';
//import 'package:flutter_clb_tinhban_ui_app/util/heart_icon_animator.dart';
//import 'package:flutter_clb_tinhban_ui_app/util/read_more_text.dart';
//
//class ShowAllSubComment extends StatefulWidget {
//  final SubComment subComment;
//
//  const ShowAllSubComment({this.subComment});
//
//  @override
//  _ShowAllSubCommentState createState() => _ShowAllSubCommentState();
//}
//
//class _ShowAllSubCommentState extends State<ShowAllSubComment> {
//  void _toggleIsLikeSubComment() {
////    setState(() =>
//////        widget.subComment.toggleLikeFor(currentUser)
////    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.only(right: 10, left: 10),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Expanded(
//            flex: 2,
//            child: AvatarCircleWidget(
//             // user: widget.subComment.user,
//              isLarge: 14.0,
//            ),
//          ),
//          Expanded(
//            flex: 8,
//            child: Padding(
//              padding: const EdgeInsets.only(top: 10),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  ReadMoreText(
//                   'nguyen',
//                    trimLines: 4,
//                    colorClickableText: Colors.grey,
//                    trimMode: TrimMode.Line,
//                    trimCollapsedText: '...more',
//                    trimExpandedText: ' less',
//                    name: 'nguyen',
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(top: 10),
//                    child: Row(
//                      children: <Widget>[
//                        Text(
//                          '14 giờ',
//                          style: TextStyle(color: Colors.grey),
//                        ),
//                        SizedBox(
//                          width: 30,
//                        ),
//                        Text(
//                          '10 lượt thích',
//                          style: TextStyle(color: Colors.grey),
//                        ),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ),
//          Expanded(
//            flex: 1,
//            child: Padding(
//              padding: const EdgeInsets.only(top: 20),
//              child: HearIconAnimation(
//               // isLike: widget.subComment.isLikeBy(currentUser),
//                size: 14.0,
//                opTap: _toggleIsLikeSubComment,
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
