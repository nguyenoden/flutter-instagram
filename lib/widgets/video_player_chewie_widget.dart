import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerChewieWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerChewieWidget({Key key, this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerChewieWidgetState createState() =>
      _VideoPlayerChewieWidgetState(this.videoUrl);
}

class _VideoPlayerChewieWidgetState extends State<VideoPlayerChewieWidget> {
  final videoUrl;

  _VideoPlayerChewieWidgetState(this.videoUrl);

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(videoUrl);
    chewieController = ChewieController(
        materialProgressColors: ChewieProgressColors(
            playedColor: Colors.grey,
            backgroundColor: Colors.white,
            bufferedColor: Colors.lightBlueAccent,
            handleColor: Colors.black87),
        videoPlayerController: videoPlayerController,
        aspectRatio: 1 / 1,
        autoInitialize: true,
        autoPlay: true,
        looping: false);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }
}
