import 'package:file_picker/file_picker.dart';

class Paths {
/*
* Firebase  path
* */
  static const String profilePicturePath = 'profile_pictures';
  static const String imageAttachmentPath = 'images';
  static const String videoAttachmentPath = 'videos';
  static const String fileAttachmentPath = 'files';
  static const String usersPath = '/users';
  static const String contactsPath = 'contacts';
  static const String usernameUidMapPath = '/username_uid_map';
  static const String chatPath = '/chats';
  static const String chat_messages = '/chat_messages';
  static const String messagesPath = 'messages';
  static const String storiesPath='/stories';
  static const String commentPath='comments';
  static const String likePath='likes';
  static const String imageStoriesPath='image_stories';

  static String getAttachmentByFileType(FileType fileType) {
    if (fileType == FileType.image)
      return imageAttachmentPath;
    else if (fileType == FileType.video)
      return videoAttachmentPath;
    else
      return fileAttachmentPath;
  }
}
