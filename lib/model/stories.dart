
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/model/comment.dart';


class Stories {
  final String documentId;
  final String uid;
  final String username;
  final String imageProfile;
  final String textStories;
  final List<dynamic> fileImage;
  final String location;
  final int timeStamp;
  final Map latestComment;
  final List<dynamic> imageUrl;
  final Map like;

 const Stories({this.documentId, this.uid,this.username, this.imageProfile, this.textStories, this.fileImage, this.location,
    this.timeStamp, this.latestComment, this.imageUrl, this.like});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['documentId'] = documentId;
    map['uid'] = uid;
    map['username']=username;
    map['imageProfile']=imageProfile;
    map['textStories'] = textStories;
    map['fileImage'] = fileImage;
    map['location'] = location;
    map['timeStamp'] = timeStamp;
    map['latestComment'] = latestComment;
    map['imageUrl'] = imageUrl;
    map['like'] = like;
    return map;
  }

  factory Stories.fromFireStore(DocumentSnapshot doc){
    Map map = doc.data;
    return Stories(
      documentId: map['documentId'],
      uid: map['uid'],
      username: map['username'],
      imageProfile: map['imageProfile'],
      textStories: map['textStories'],
      fileImage: map['fileImage'],
      location: map['location'],
      timeStamp: map['timeStamp'],
      latestComment: map['latestComment'],
      imageUrl: map['imageUrl'],
      like: map['like'],
    );
  }

}
