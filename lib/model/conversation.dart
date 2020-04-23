import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';

import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';


class Conversation{
  String chatId;
  User user;
  Message latestMessage;

  Conversation(this.chatId, this.user, this.latestMessage);

  @override
  String toString() =>'{user=$user,chatId=$chatId,latestMessage=$latestMessage}';

  factory Conversation.fromFireStore( DocumentSnapshot doc){
    Map<String,dynamic> data=doc.data;
    List<String> members=List.from(data['members']);
    String selfUsername=ShareObjects.prefs.getString(Constants.sessionUsername);
    User contact;
    for(int i=0; i<members.length;i++){
      if(members[i]!=selfUsername){
        final userDetails=Map<String,dynamic>.from((data['membersData'])[i]);
        contact=User.fromMap(userDetails);

      }
    }
    return Conversation(doc.documentID,contact,Message.fromMap(Map.from(data['latestMessage'])));
  }

}