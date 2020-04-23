import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:intl/intl.dart';

abstract class Message {
  int timeStamp;
  String senderName;
  String senderUsername;
  bool isSelf;
  String documentId;

  Message(this.timeStamp,
      this.senderName,
      this.senderUsername,);

  Map<String, dynamic> toMap();

  factory Message.fromFireStore(DocumentSnapshot doc) {
    final int type = doc.data['type'];
    Message message;
    switch (type) {
      case 0:
        message = TextMessage.fromFireStore(doc);
        break;
      case 1:
        message = ImageMessage.fromFireStore(doc);
        break;
      case 2:
        message = VideoMessage.fromFireStore(doc);
        break;
      case 3:
        message = FileMessage.fromFireStore(doc);
    }
    message.isSelf = ShareObjects.prefs.getString(Constants.sessionUsername) ==
        message.senderUsername;
    message.documentId=doc.documentID;
    return message;
  }

  factory Message.fromMap(Map data){
    final int type = data['type'];
    Message message;
    switch (type) {
      case 0:
        message = TextMessage.fromMap(data);
        break;
      case 1:
        message = ImageMessage.fromMap(data);
        break;
      case 2:
        message = VideoMessage.fromMap(data);
        break;
      case 3:
        message = FileMessage.fromMap(data);
    }
    message.isSelf = ShareObjects.prefs.getString(Constants.sessionUsername) ==
        message.senderUsername;
    return message;
  }


}

class FileMessage extends Message {
  String fileUrl;
  String fileName;

  FileMessage(this.fileUrl, this.fileName, int timeStamp, String senderName,
      String senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory FileMessage.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return FileMessage.fromMap(data);
  }

  factory FileMessage.fromMap(Map data) {
    return FileMessage(data['fileUrl'], data['fileName'], data['timeStamp'],
        data['senderName'], data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['fileUrl'] = fileUrl;
    map['fileName'] = fileName;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 3;
    return map;
  }
}

class VideoMessage extends Message {
  String videoUrl;
  String fileName;

  VideoMessage(this.videoUrl, this.fileName, int timeStamp, String senderName,
      String senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory VideoMessage.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return VideoMessage.fromMap(data);
  }

  factory VideoMessage.fromMap(Map data) {
    return VideoMessage(data['videoUrl'], data['fileName'], data['timeStamp'],
        data['senderName'], data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['videoUrl'] = videoUrl;
    map['filename'] = fileName;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 2;

    return map;
  }
}

class ImageMessage extends Message {
  String imageUrl;
  String fileName;

  ImageMessage(this.imageUrl, this.fileName, int timeStamp, String senderName,
      String senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory ImageMessage.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return ImageMessage.fromMap(data);
  }

  factory ImageMessage.fromMap(Map data) {
    return ImageMessage(data['imageUrl'], data['fileName'], data['timeStamp'],
        data['senderName'], data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['imageUrl'] = imageUrl;
    map['fileName'] = fileName;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 1;

    return map;
  }
}

class TextMessage extends Message {
  String text;
  TextMessage(this.text,int timeStamp, String senderName,
      String senderUsername)
      : super(timeStamp, senderName, senderUsername);


  factory TextMessage.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return TextMessage.fromMap(data);
  }

  factory TextMessage.fromMap(Map data) {
    return TextMessage(data['text'], data['timeStamp'], data['senderName'],
        data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['text'] = text;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 0;
    return map;
  }
}
