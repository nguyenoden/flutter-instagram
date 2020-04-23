import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/chats/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';

import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';

import 'package:flutter_clb_tinhban_ui_app/model/chat.dart';
import 'package:flutter_clb_tinhban_ui_app/model/contacts.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/attachment_page.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Contact contact;
  final Chat chat;
  final double height = 100;

  ChatAppBar({this.contact, this.chat});

  @override
  _ChatAppBarState createState() => _ChatAppBarState(contact, chat);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _ChatAppBarState extends State<ChatAppBar> {
  Contact contact;
  Chat chat;
  ChatBloc chatBloc;
  String receivedUsername;
  String _username = '';
  String _name = '';
  ImageProvider _image = Image.asset(Assets.DonaldTrump).image;

  _ChatAppBarState(this.contact, this.chat);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    if (contact != null) {
      _name = contact.name;
      _username = contact.username;
      _image = CachedNetworkImageProvider(contact.photoUrl);
      chat = Chat(contact.username, contact.chatId);
    } else {
      _username = chat.username;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (bc, state) {
        if (state is FetchedContactDetailState) {
          print('Received state of page $state');
          print(state.user);
          if (state.username == _username) {
            _name = state.user.name;
            _image = CachedNetworkImageProvider(state.user.photoUrl);
          }
        }
        if (state is PageChangedState) {
          print(state.index);
          print('$_name, $_username');
        }
      },
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 5.0, spreadRadius: 0.1)
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 70 - (width * .06),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Container(
                                    child: Center(
                                      child: BlocBuilder<ChatBloc, ChatState>(
                                        builder: (context, state) {
                                          return CircleAvatar(
                                            backgroundImage: _image,
                                            radius: (80 - (width * .06)) / 2,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(_name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle),
                                      Text(
                                        '@' + _username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text('Photos',
                                      style:
                                          Theme.of(context).textTheme.button),
                                  onTap: () => Navigator.push(
                                      context,
                                      SlideLeftRout(
                                          page: AttachmentPage(
                                        this.chat.chatId,
                                        FileType.image,
                                      ))),
                                ),
                                VerticalDivider(
                                  width: 30,
                                  color:
                                      Theme.of(context).textTheme.button.color,
                                ),
                                GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        SlideLeftRout(
                                            page: AttachmentPage(
                                          this.chat.chatId,
                                          FileType.video,
                                        ))),
                                    child: Text('Video',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button)),
                                VerticalDivider(
                                  width: 30,
                                  color:
                                      Theme.of(context).textTheme.button.color,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      SlideLeftRout(
                                          page: AttachmentPage(
                                        this.chat.chatId,
                                        FileType.any,
                                      ))),
                                  child: Text(
                                    'File',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
//                Expanded(
//                  flex: 3,
//                  child: Container(
//                    child: Center(
//                      child: BlocBuilder<ChatBloc, ChatState>(
//                        builder: (context, state) {
//                          return CircleAvatar(
//                            backgroundImage: _image,
//                            radius: (80 - (width * .06)) / 2,
//                          );
//                        },
//                      ),
//                    ),
//                  ),
//                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//  showAttachmentBottomSheet(context) {
//    showModalBottomSheet<Null>(
//        context: context,
//        builder: (BuildContext bc) {
//          return Container(
//            color: Theme.of(context).backgroundColor,
//            child: Wrap(
//              children: <Widget>[
//                ListTile(
//                  leading: Icon(Icons.image),
//                  title: Text('Image'),
//                  onTap: () => showFilePicker(FileType.IMAGE),
//                ),
//                ListTile(
//                  leading: Icon(Icons.videocam),
//                  title: Text('Video'),
//                  onTap: () => showFilePicker(FileType.VIDEO),
//                ),
//                ListTile(
//                  leading: Icon(Icons.insert_drive_file),
//                  title: Text('File'),
//                  onTap: () => showFilePicker(FileType.ANY),
//                )
//              ],
//            ),
//          );
//        });
//  }
//
//  showFilePicker(FileType fileType) async {
//    File file;
//    if (fileType == FileType.IMAGE &&
//        ShareObjects.prefs.getBool(Constants.configImageCompression))
//      file = await ImagePicker.pickImage(
//          source: ImageSource.gallery, imageQuality: 70);
//    else
//      file = await FilePicker.getFile(type: fileType);
//    if (file == null) return;
//    chatBloc.add(SendAttachEvent(chatId, file, fileType));
//    Navigator.pop(context);
//    GradientSnackBar.showMessage(context, 'Sending attachment');
//  }
}
