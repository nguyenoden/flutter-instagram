import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_clb_tinhban_ui_app/model/message.dart';
import 'package:flutter_clb_tinhban_ui_app/model/video_wrapper.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

@immutable
abstract class AttachmentState extends Equatable {
  AttachmentState([List props = const <dynamic>[]]) : super();
}
class InitialAttachmentState extends AttachmentState{
  @override
  // TODO: implement props
  List<Object> get props => null;

}
class FetchedAttachmentState extends AttachmentState{
  final List<Message> attachment;
  final FileType fileType;

  FetchedAttachmentState(this.attachment, this.fileType):super([attachment,fileType]);
  @override
  // TODO: implement props
  List<Object> get props => [attachment,fileType];

  @override
  String toString() =>'FetchAttachmentState';
}
class FetchedVideoState extends AttachmentState{
  final List<VideoWrapper> video;

  FetchedVideoState(this.video):super([video]);

  @override
  // TODO: implement props
  List<Object> get props => [video];

  @override
  String toString() =>'FetchedVideoState';
}