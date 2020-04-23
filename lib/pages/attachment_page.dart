import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/attachments/attachment_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/attachments/attachment_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/attachments/attachment_state.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';

import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/video_wrapper.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/bottom_sheet_fixed.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/image_full_screen.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/video_player_chewie_widget.dart';

import 'package:intl/intl.dart';
import 'package:progressive_image/progressive_image.dart';

class AttachmentPage extends StatefulWidget {
  final String chatId;
  final FileType fileType;

  AttachmentPage(this.chatId, this.fileType);

  @override
  _AttachmentPageState createState() =>
      _AttachmentPageState(this.chatId, this.fileType);
}

class _AttachmentPageState extends State<AttachmentPage>
    with SingleTickerProviderStateMixin {
  final String chatId;
  final FileType initialFileType;
  List<ImageMessage> photos;
  List<VideoWrapper> videos;
  List<FileMessage> files;

  AttachmentBloc attachmentsBloc;
  String tempThumbnailPath;
  TabController tabController;

  _AttachmentPageState(this.chatId, this.initialFileType);

  @override
  void initState() {
    super.initState();
    attachmentsBloc = BlocProvider.of<AttachmentBloc>(context);
    int initialTab = ShareObjects.getTypeFromFileType(
        initialFileType); // get the initial index of tab. 0/1/2
    tabController =
        TabController(initialIndex: initialTab - 1, length: 3, vsync: this);
    tabController.addListener(() {
      int index = tabController.index;
      if (index == 0 &&
          photos ==
              null) // if photos are not initialized and we're on the first tab then trigger a fetch event for photos
        attachmentsBloc.add(FetchAttachmentEvent(FileType.image, chatId));
      else if (index == 1 &&
          videos ==
              null) // if videos are not initialized and we're on the second tab then  trigger a fetch event for videos
        attachmentsBloc.add(FetchAttachmentEvent(FileType.video, chatId));
      else if (index == 2 &&
          files ==
              null) //if files are not initialized and we're on the third tab then trigger a fetch event for files
        attachmentsBloc.add(FetchAttachmentEvent(FileType.any, chatId));
    });
    attachmentsBloc.add(FetchAttachmentEvent(
        initialFileType, chatId)); // triggers at the very start.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  expandedHeight: 180.0,
                  pinned: true,
                  elevation: 0,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Attachments",
                        style: Theme.of(context).textTheme.title),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(icon: Icon(Icons.photo), text: "Photos"),
                      Tab(icon: Icon(Icons.videocam), text: "Videos"),
                      Tab(icon: Icon(Icons.insert_drive_file), text: "Files"),
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: [
                buildPhotosGrid(),
                buildVideosGrid(),
                buildFilesGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildPhotosGrid() {
    return BlocBuilder<AttachmentBloc, AttachmentState>(
        builder: (context, state) {
      print('Received : $state');
      if (state is FetchedAttachmentState && state.fileType == FileType.image) {
        photos = List();
        state.attachment.forEach((msg) {
          if (msg is ImageMessage) {
            photos.add(msg);
          }
        });
      }
      print('photos : $photos');
      if (photos == null)
        return Center(
            child:
                CircularProgressIndicator()); // if uninit, show a progress bar
      else if (photos.length == 0) {
        // if init and the photos array size is 0
        return Center(
            child: Text(
          'No Photos',
          style: Theme.of(context).textTheme.body2,
        ));
      }
      return GridView.count(
        //otherwise show a grid of photos
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children:
            List.generate(photos.length, (index) => imageItem(context, index)),
      );
    });
  }

  buildVideosGrid() {
    return BlocBuilder<AttachmentBloc, AttachmentState>(
        builder: (context, state) {
      print('Received $state');
      if (state is FetchedVideoState) {
        videos = state.video;
      }
      print("videos : $videos");
      if (videos == null) // if uninit, then show a progress bar
        return Center(child: CircularProgressIndicator());
      else if (videos.length == 0) {
        // if init and videos length is zero
        return Center(
            child: Text(
          'No Videos',
          style: Theme.of(context).textTheme.body2,
        ));
      }
      return GridView.count(
        //else show a grid of videos using their thumbnails
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children:
            List.generate(videos.length, (index) => videoItem(videos[index])),
      );
    });
  }

  buildFilesGrid() {
    return BlocBuilder<AttachmentBloc, AttachmentState>(
        builder: (context, state) {
      print('Received $state in ui');
      if (state is FetchedAttachmentState && state.fileType == FileType.any) {
        files = List();
        state.attachment.forEach((msg) {
          if (msg is FileMessage) {
            files.add(msg);
          }
        });
      }
      if (files == null) // if uninit show a progress bar
        return Center(child: CircularProgressIndicator());
      else if (files.length == 0) {
        //if files array length is zero
        return Center(
            child: Text(
          'No Files',
          style: Theme.of(context).textTheme.body2,
        ));
      }
      return ListView.separated(
        // show the list of files
        padding: EdgeInsets.only(left: 12, right: 12),
        separatorBuilder: (context, index) => Divider(
          height: .5,
          color: Color(0xffd3d3d3),
        ),
        itemBuilder: (context, index) => fileItem(files[index]),
        itemCount: files.length,
      );
    });
  }

  imageItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ImageFullScreen(

                  tag: 'AttachmentImage_$index', url: photos[index].imageUrl))),
      child: Hero(
          tag: 'AttachmentImage_$index',
          child: ProgressiveImage(
              placeholder: AssetImage(Assets.placeholder),
              thumbnail: NetworkImage(photos[index].imageUrl),
              image: NetworkImage(photos[index].imageUrl),
              fadeDuration: Duration(milliseconds: 300),
              fit: BoxFit.cover,
              width: 150,
              height: 150)
//              Image.network(
//            photos[index].imageUrl,
//            fit: BoxFit.cover,
//            filterQuality: FilterQuality.low,
//          )
          ),
    );
  }

  fileItem(FileMessage fileMessage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Icon(
                  Icons.insert_drive_file,
                )),
            Expanded(
              flex: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          fileMessage.fileName,
                          style: Theme.of(context).textTheme.subtitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat('dd MMM kk:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  fileMessage.timeStamp)),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                        icon: Icon(
                          Icons.file_download,
                        ),
                        onPressed: () => ShareObjects.downloadFile(
                            fileMessage.fileUrl, fileMessage.fileName)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  videoItem(VideoWrapper video) {
    return GestureDetector(
      onTap: () {
        showVideoPlayer(context, video.videoMessage.videoUrl);
      },
      child: Container(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Image.file(
              video.file,
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // this adds the top and bottom tints to the video thumbnail
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xAA000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0xAA000000),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.play_circle_filled,
            )
          ],
        ),
      ),
    );
  }

  void showVideoPlayer(parentContext, String videoUrl) async {
    await showModalBottomSheetApp(
        context: parentContext,
        builder: (BuildContext bc) {
//          return VideoPlayerWidget(videoUrl,);
          return VideoPlayerChewieWidget(
            videoUrl: videoUrl,
          );
        });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
