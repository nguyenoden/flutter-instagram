import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/attachments/attachment_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/attachments/attachment_state.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/video_wrapper.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/chat_repository.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  final ChatRepository chatRepository;

  AttachmentBloc(this.chatRepository) : assert(chatRepository != null);

  @override
  // TODO: implement initialState
  AttachmentState get initialState => InitialAttachmentState();

  @override
  Stream<AttachmentState> mapEventToState(AttachmentEvent event) async* {
    if (event is FetchAttachmentEvent) {
      yield* mapFetchAttachmentEventToState(event);
    }
  }

  Stream<AttachmentState> mapFetchAttachmentEventToState(
      FetchAttachmentEvent event) async* {
    int type = ShareObjects.getTypeFromFileType(event.fileType);
    print("type : $type");
    List<Message> attachment =
        await chatRepository.getAttachments(event.chatId, type);
    if (event.fileType != FileType.video) {
      yield FetchedAttachmentState(attachment, event.fileType);
    } else {
      List<VideoWrapper> video = List();
      for (Message message in attachment) {
        if (message is VideoMessage) {
          print("message.videoUrl : ${message.videoUrl}");
          File file = await ShareObjects.getThumbnail(message.videoUrl);
          print("file: $file");
          video.add(VideoWrapper(file, message));
        }
      }
      print("video : $video");
//        var video = await parseVideos(attachment);

      yield FetchedVideoState(video);
    }
  }

  FutureOr<List<VideoWrapper>> parseVideos(List<Message> attachments) async {
    List<VideoWrapper> videos = List();
    for (Message message in attachments) {
      if (message is VideoMessage) {
        File file = await ShareObjects.getThumbnail(message.videoUrl);
        videos.add(VideoWrapper(file, message));
      }
    }
    return videos;
  }
}
