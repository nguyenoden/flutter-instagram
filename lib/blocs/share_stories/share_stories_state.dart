
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShareStoriesState extends Equatable {

}

class InitialShareStoriesState extends ShareStoriesState {
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class SendStoriesState extends ShareStoriesState{

  @override
  // TODO: implement props
  List<Object> get props => null;

}
class InProgressShareStoriesState extends ShareStoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  String toString() {
    return 'InProgressShareStoriesState{}';
  }
}
class InProgressFinishShareStoriesState extends ShareStoriesState{
  @override
  // TODO: implement props
  List<Object> get props => [];
  @override
  String toString() {
    return 'InProgressFinishShareStoriesState{}';
  }
}
class ShareImageForApplicationState extends ShareStoriesState{
  final Uint8List fileImage;

  ShareImageForApplicationState(this.fileImage);
  @override
  // TODO: implement props
  List<Object> get props => [fileImage];

  @override
  String toString() {
    return 'ShareImageForApplicationState{fileImage: $fileImage}';
  }
}
