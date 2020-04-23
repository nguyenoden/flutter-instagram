class Chat{
  String username;
  String  chatId;

  Chat(this.username, this.chatId);

  @override
  String toString() {
    return 'Chat{username: $username, chatId: $chatId}';
  }
}