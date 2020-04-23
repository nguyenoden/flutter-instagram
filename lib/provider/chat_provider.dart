import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/paths.dart';

import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';

class ChatProvider extends BaseChatProvider {
  final Firestore firestoreDb;
  StreamController<List<Conversation>> conversationStreamController;

  ChatProvider({Firestore firestoreDb})
      : firestoreDb = firestoreDb ?? Firestore.instance
          ..settings(persistenceEnabled: true);

  @override
  Future<void> createChatIdForContact(User user) async {
    String contactUid = user.documentId;
    String contactUsername = user.username;
    String uid = ShareObjects.prefs.getString(Constants.sessionUid);
    String selfUserName =
        ShareObjects.prefs.getString(Constants.sessionUsername);
    CollectionReference userCollection =
        firestoreDb.collection(Paths.usersPath);
    DocumentReference userRef = userCollection.document(uid);
    DocumentReference contactRef = userCollection.document(contactUid);
    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.data['chats'] == null ||
        userSnapshot.data['chats'][contactUsername] == null) {
      String chatId = await createChatIdForUsers(selfUserName, contactUsername);
      await userRef.setData({
        'chats': {contactUsername: chatId}
      }, merge: true);
      await contactRef.setData({
        'chats': {selfUserName: chatId}
      }, merge: true);
    }
  }

  @override
  void dispose() {
    if (conversationStreamController != null) {
      conversationStreamController.close();
    }
  }

  @override
  Future<List<Message>> getAttachments(String chatId, int type) async {
    DocumentReference chatDocRef =
        firestoreDb.collection(Paths.chatPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    final querySnapshot = await messagesCollection
        // .orderBy('timeStamp', descending: true)
        .where('type', isEqualTo: type)
        .getDocuments();
    List<Message> messageList = List();
    querySnapshot.documents
        .forEach((doc) => messageList.add(Message.fromFireStore(doc)));
    return messageList;
  }

  @override
  Stream<List<Chat>> getChat() {
    String uid = ShareObjects.prefs.getString(Constants.sessionUid);

    return firestoreDb
        .collection(Paths.usersPath)
        .document(uid)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot, List<Chat>>.fromHandlers(
            handleData: (DocumentSnapshot documentSnapshot,
                    EventSink<List<Chat>> sink) =>
                mapDocumentToChat(documentSnapshot, sink)));
  }

  void mapDocumentToChat(
      DocumentSnapshot documentSnapshot, EventSink sink) async {
    List<Chat> chats = List();
    Map data = documentSnapshot.data['chats'];
    if (data != null) {
      data.forEach((key, value) => chats.add(Chat(key, value)));
      sink.add(chats);
    }
  }

  @override
  Future<String> getChatIdByUsername(String username) async {
    String uid = ShareObjects.prefs.getString(Constants.sessionUid);
    String selfUsername =
        ShareObjects.prefs.getString(Constants.sessionUsername);
    DocumentReference userRef =
        firestoreDb.collection(Paths.usersPath).document(uid);
    DocumentSnapshot documentSnapshot = await userRef.get();
    String chatId = documentSnapshot.data['chats'][username];
    if (chatId == null) {
      chatId = await createChatIdForUsers(selfUsername, username);
      userRef.updateData({
        'chats': {username: chatId}
      });
    }

    return chatId;
  }

  Future<String> createChatIdForUsers(
      String selfUsername, String contactUsername) async {
    CollectionReference chatCollection = firestoreDb.collection(Paths.chatPath);
    CollectionReference userUidMapCollection =
        firestoreDb.collection(Paths.usernameUidMapPath);
    CollectionReference usersCollection =
        firestoreDb.collection(Paths.usersPath);
    String selfUid =
        (await userUidMapCollection.document(selfUsername).get()).data['uid'];
    String contactUid =
        (await userUidMapCollection.document(contactUsername).get())
            .data['uid'];
    print('selfUsername :$selfUsername contactUid :$contactUid');
    DocumentSnapshot selfDocRef = await usersCollection.document(selfUid).get();
    DocumentSnapshot contactDocRef =
        await usersCollection.document(contactUid).get();
    DocumentReference documentReference = await chatCollection.add({
      'members': [selfUsername, contactUsername],
      'membersData': [selfDocRef.data, contactDocRef.data]
    });
    return documentReference.documentID;
  }

  @override
  Stream<List<Conversation>> getConversation() {
    conversationStreamController = StreamController();
    conversationStreamController.sink;
    String username = ShareObjects.prefs.getString(Constants.sessionUsername);

    return firestoreDb
        .collection(Paths.chatPath)
        .where('members', arrayContains: username)
        // .orderBy('latestMessage.timeStamp', descending: true)
        .snapshots()
        .transform(
            StreamTransformer<QuerySnapshot, List<Conversation>>.fromHandlers(
                handleData: (QuerySnapshot querySnapshot,
                        EventSink<List<Conversation>> sink) =>
                    mapQueryToConversation(querySnapshot, sink)));
  }

  void mapQueryToConversation(
      QuerySnapshot querySnapshot, EventSink<List<Conversation>> sink) {
    List<Conversation> conversation = List();
    print("conversation : $conversation");
    querySnapshot.documents.forEach((document) {
      conversation.add(Conversation.fromFireStore(document));
    });
    sink.add(conversation);
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    DocumentReference chatDocRef =
        firestoreDb.collection(Paths.chatPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);

    return messagesCollection
        .orderBy('timeStamp', descending: true)
        .limit(20)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
                    mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Message> messages = List();
    for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
      messages.add(Message.fromFireStore(documentSnapshot));
    }
    sink.add(messages);
  }

  @override
  Future<List<Message>> getPreviousMessages(
      String chatId, Message prevMessage) async {
    DocumentReference chatDocRef =
        firestoreDb.collection(Paths.chatPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    DocumentSnapshot prevDocument;
    prevDocument =
        await messagesCollection.document(prevMessage.documentId).get();

    final querySnapshot = await messagesCollection
        .startAfterDocument(
            prevDocument) // start reading documents after the specified document
        .orderBy('timeStamp', descending: true)
        .limit(20)
        .getDocuments();
    List<Message> messageList = List();
    querySnapshot.documents
        .forEach((doc) => messageList.add(Message.fromFireStore(doc)));

    return messageList;
  }

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference chatDocRef =
        firestoreDb.collection(Paths.chatPath).document(chatId);
    CollectionReference messageCollection =
        chatDocRef.collection(Paths.messagesPath);
    messageCollection.add(message.toMap());
    await chatDocRef.updateData({'latestMessage': message.toMap()});
  }
}
