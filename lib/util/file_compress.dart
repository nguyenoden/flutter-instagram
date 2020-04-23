import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileCompress {
  final _flutterVideoCompress = FlutterVideoCompress();
  Future<File> imageCompress(var file) async {
    String tempPath;
    final tempDir = await getApplicationDocumentsDirectory();
    await Directory(tempDir.path + '/' + 'dir')
        .create(recursive: true)
        .then((Directory directory) {
      tempPath = directory.path;
    });
    File fileCompress = File('$tempPath/image_compress.jpg');
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 720,
      minHeight: 1280,
      quality: 80,
      rotate: 0,
    );
    await fileCompress.writeAsBytes(result, flush: true, mode: FileMode.write);
    return fileCompress;
  }

  Future<File> profileImageCompress(File file) async {
    String tempPath;
    final tempDir = await getApplicationDocumentsDirectory();
    await Directory(tempDir.path + '/' + 'dir')
        .create(recursive: true)
        .then((Directory directory) {
      tempPath = directory.path;
    });
    File fileCompress = File('$tempPath/image_compress.jpg');
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 300,
      minHeight: 300,
      quality: 90,
      rotate: 0,
    );
    await fileCompress.writeAsBytes(result, flush: true, mode: FileMode.write);
    return fileCompress;
  }

  Future<File> convertVideoToGif(File file) async {
    final fileGif = await _flutterVideoCompress.convertVideoToGif(
      file.path,
      startTime: 0, // default(0)
      duration: 5, // default(-1)
      // endTime: -1 // default(-1)
    );
    return fileGif;
  }

  Future<MediaInfo> compressVideo(File file) async {
    final info = await _flutterVideoCompress.compressVideo(
      file.path,
      quality:
          VideoQuality.DefaultQuality, // default(VideoQuality.DefaultQuality)
      deleteOrigin: false, // default(false)
    );
    return info;
  }
}
