import 'dart:io';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/database/contacts_database.dart';
import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/util/file_compress.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/gradient_snack_bar.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class InputWidget extends StatefulWidget {
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _textEditingController =
      new TextEditingController();

  ChatBloc chatBloc;

  bool showEmojiKeyboard = false;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Theme.of(context).hintColor, width: 0.5)),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: new Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      color: Theme.of(context).primaryColor,
                      child: IconButton(
                        onPressed: () => showAttachmentBottomSheet(context),
                        icon: Icon(
                          Icons.attach_file,
                          color: Theme.of(context).accentColor,
                        ),
                      )),
                ),
                Flexible(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: TextField(
                      autofocus: false,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.body2,
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Type a message...',
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor)),
                    ),
                  ),
                ),
                Material(
                  child: Container(
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () => sendMessage(context)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAttachmentBottomSheet(context) {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Image'),
                  onTap: () => showFilePicker(FileType.image),
                ),
                ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text('Video'),
                  onTap: () => showFilePicker(FileType.video),
                ),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text('File'),
                  onTap: () => showFilePicker(FileType.any),
                )
              ],
            ),
          );
        });
  }

  showFilePicker(FileType fileType) async {
    File file;
    if (fileType == FileType.image) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file = await FileCompress().imageCompress(image);
      } else if (image == null) {
        return;
      }
    } else {
      file = await FilePicker.getFile(type: fileType);
    }
    if (file == null) return;

    chatBloc.add(SendAttachEvent(chatId, file, fileType));
    Navigator.pop(context);
    GradientSnackBar.showMessage(context, 'Sending attachment');
  }

  void sendMessage(context) {
    chatBloc.add(SendTextMessageEvent(_textEditingController.text));

    _textEditingController.clear();
  }
}
