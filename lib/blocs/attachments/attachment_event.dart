import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
@immutable
abstract class AttachmentEvent extends Equatable{
  AttachmentEvent([List props= const <dynamic>[]]):super();

}
class FetchAttachmentEvent extends AttachmentEvent{
  final FileType fileType;
  final String chatId;

  FetchAttachmentEvent(this.fileType, this.chatId):super([fileType,chatId]);

  @override
  // TODO: implement props
  List<Object> get props => [fileType,chatId];

  @override
  String toString() =>'FetchAttachmentEvent';
}