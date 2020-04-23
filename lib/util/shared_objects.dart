import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ShareObjects {
  static CachedSharedPreferences prefs;

  /*
  Supporting only android fow now
   */
  static downloadFile(String fileUrl, String fileName) async {
    print("Constants.downloadsDirPath: ${Constants.downloadsDirPath}");

    await FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: Constants.downloadsDirPath,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true);
  }

  static int getTypeFromFileType(FileType fileType) {
    if (fileType == FileType.image)
      return 1;
    else if (fileType == FileType.video)
      return 2;
    else
      return 3;
  }

  static Future<File> getThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: Constants.cacheDirPath,
      imageFormat: ImageFormat.WEBP,
      quality: 30,
    );
    final file = File(thumbnail);
    print("file: $file");
    return file;
  }
}

class CachedSharedPreferences {
  static SharedPreferences sharedPreferences;
  static CachedSharedPreferences instance;
  static final cachedKeyList = {
    Constants.firstRun,
    Constants.sessionUid,
    Constants.sessionUsername,
    Constants.sessionName,
    Constants.sessionProfilePictureUrl,
    Constants.configDarkMode,
    Constants.configMessagePaging,
    Constants.configMessagePeek,
  };
  static final sessionKeyList = {
    Constants.sessionName,
    Constants.sessionUid,
    Constants.sessionUsername,
    Constants.sessionProfilePictureUrl
  };

  static Map<String, dynamic> map = Map();

  static Future<CachedSharedPreferences> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool(Constants.firstRun) == null ||
        sharedPreferences.get(Constants.firstRun)) {
      // if first run, then set these values
      await sharedPreferences.setBool(Constants.configDarkMode, false);
      await sharedPreferences.setBool(Constants.configMessagePaging, false);
      await sharedPreferences.setBool(Constants.configImageCompression, true);
      await sharedPreferences.setBool(Constants.configMessagePeek, true);
      await sharedPreferences.setBool(Constants.firstRun, false);
    }
    for (String key in cachedKeyList) {
      map[key] = sharedPreferences.get(key);
    }
    if (instance == null) instance = CachedSharedPreferences();
    return instance;
  }

  String getString(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getString(key);
  }

  bool getBool(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getBool(key);
  }

  Future<bool> setString(String key, String value) async {
    bool result = await sharedPreferences.setString(key, value);
    print(result);
    if (result) map[key] = value;
    return result;
  }

  Future<bool> setBool(String key, bool value) async {
    bool result = await sharedPreferences.setBool(key, value);
    if (result) map[key] = value;
    return result;
  }

  Future<void> clearAll() async {
    await sharedPreferences.clear();
    map = Map();
  }

  Future<void> clearSession() async {
    await sharedPreferences.remove(Constants.sessionProfilePictureUrl);
    await sharedPreferences.remove(Constants.sessionUsername);
    await sharedPreferences.remove(Constants.sessionUid);
    await sharedPreferences.remove(Constants.sessionName);
    map.removeWhere((k, v) => (sessionKeyList.contains(k)));
  }
}
