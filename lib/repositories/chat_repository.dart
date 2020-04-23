
import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/conversation.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/base_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/provider/chat_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/base_repository.dart';

class ChatRepository extends BaseRepository {

  BaseChatProvider chatProvider = ChatProvider();

  Stream<List<Conversation>> getConversation() =>
      chatProvider.getConversation();

  Stream<List<Chat>> getChat() => chatProvider.getChat();

  Stream<List<Message>> getMessage(String chatId) =>
      chatProvider.getMessages(chatId);

  Future<List<Message>> getPreviousMessage(String chatId,
      Message prevMessage) =>
      chatProvider.getPreviousMessages(chatId, prevMessage);

  Future<List<Message>> getAttachments(String chatId, int type) =>
      chatProvider.getAttachments(chatId, type);

  Future<void> sendMessage(String chatId, Message message) =>
      chatProvider.sendMessage(chatId, message);

  Future<String> getChatIdByUsername(String username) =>
      chatProvider.getChatIdByUsername(username);

  Future<void> createChatIdForContact(User user) =>
      chatProvider.createChatIdForContact(user);

  @override
  void dispose() {
    // TODO: implement dispose
  }


}