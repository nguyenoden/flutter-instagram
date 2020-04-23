import 'dart:io';

import 'package:flutter_clb_tinhban_ui_app/model/message.dart';

class VideoWrapper {
  final File file; // thumbnail for video
  final VideoMessage videoMessage;

  VideoWrapper(this.file, this.videoMessage);
}
