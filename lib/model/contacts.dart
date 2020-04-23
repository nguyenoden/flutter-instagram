import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:sqflite/sqflite.dart';

class Contact {
  final String name;
  final String username;
  final String documentId;
  final String photoUrl;
  final String chatId;
  final bool favourite;

  Contact(this.documentId, this.name, this.username, this.photoUrl, this.chatId,
      {this.favourite});

  factory Contact.fromFirestore(DocumentSnapshot doc, String chatId) {
    Map data = doc.data;
    return Contact(doc.documentID, data['name'], data['username'],
        data['photoUrl'], chatId);
  }

  @override
  String toString() {
    return 'Contact{documentId: $documentId,name: $name, username: $username,  photoUrl: $photoUrl, chatId: $chatId}';
  }

  String getFirstName() => username.split(' ')[0];

  String getLastName() {
    List names = username.split(' ');
    return names.length > 1 ? names[1] : '';
  }

  factory Contact.fromConversation(Conversation conversation) {
    return Contact(
        conversation.user.documentId,
        conversation.user.name,
        conversation.user.username,
        conversation.user.photoUrl,
        conversation.chatId);
  }

  // create a Contact from JSON Data

  factory Contact.fromDataBaseSql(Map<String, dynamic> jsonData) {
    return Contact(jsonData['documentId'], jsonData['name'],
        jsonData['username'], jsonData['photoUrl'], jsonData['chatId']);
  }
// Convert our Contact to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJsonData() => {
        "documentId": this.documentId,
        "name": this.name,
        "username": this.username,
        "photoUrl": this.photoUrl,
        "chatId": this.chatId
      };
}
