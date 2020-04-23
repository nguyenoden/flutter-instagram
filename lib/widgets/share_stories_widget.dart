import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/share_stories/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/share_stories/share_stories_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/stories/bloc.dart';

import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/themes.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/share/location.dart';
import 'package:geocoder/geocoder.dart';

class ShareStoriesWidget extends StatefulWidget {
  final fileImage;

  const ShareStoriesWidget({Key key, this.fileImage}) : super(key: key);

  @override
  _ShareStoriesWidgetState createState() => _ShareStoriesWidgetState(fileImage);
}

class _ShareStoriesWidgetState extends State<ShareStoriesWidget>
    with SingleTickerProviderStateMixin {
  var _textCommentController = TextEditingController();
  var locationController = TextEditingController();
  var tagFriendController = TextEditingController();
  final fileImage;

  Address address;
  List<File> _listFileImage = [];

  File _imageFile;
  StoriesBloc storiesBloc;
  ShareStoriesBloc shareStoriesBloc;
  Stories stories;

  _ShareStoriesWidgetState(this.fileImage);

  @override
  void initState() {
    initPlatformState();
    storiesBloc = BlocProvider.of<StoriesBloc>(context);
    shareStoriesBloc = BlocProvider.of<ShareStoriesBloc>(context);
    // fileImage??_listFileImage.add(fileImage);
    if (fileImage != null) {
      setState(() {
        _listFileImage.add(fileImage);
        _imageFile = fileImage;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initPlatformState() async {
    Address first = await getUserLocation();
    setState(() {
      address = first;
    });
  }

  Future<bool> willPopScope() {

    storiesBloc.add(FetchListStoriesEvent());
    Navigator.pop(context);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopScope,
      child: Material(
        child: SafeArea(
          child: BlocListener<ShareStoriesBloc, ShareStoriesState>(
            listener: (context, state) {
              if (state is InProgressFinishShareStoriesState) {
                Future.delayed(Duration(milliseconds: 300), () {
                  shareStoriesBloc.add(InitialShareStoriesEvent());
                  //storiesBloc.add(FetchListStoriesEvent());
                });
              }
              if (state is InitialShareStoriesState) {
                _textCommentController.clear();
                _listFileImage.clear();
                setState(() {
                  _imageFile = null;
                });
              }
            },
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.black12, offset: Offset(0.0, 1))
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () => {

                                storiesBloc.add(FetchListStoriesEvent()),
                                  Navigator.pop(context),
                            },
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Palette.colorBlack,
                                )),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (_textCommentController.text.isNotEmpty) {
                                  shareStoriesBloc.add(SendShareStoriesEvent(
                                      _textCommentController.text,
                                      _listFileImage,
                                      locationController.text,
                                      DateTime
                                          .now()
                                          .millisecondsSinceEpoch,
                                      null));
                                }
                              },
                              child: Text(
                                ' Chia sẻ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme
                                      .of(context)
                                      .accentColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  _listFileImage =
                                  await FilePicker.getMultiFile(
                                      type: FileType.image);
                                  if (_listFileImage.isNotEmpty) {
                                    setState(() {
                                      _imageFile = _listFileImage[0];
                                    });
                                  }
                                },
                                child: Container(
                                  width: 60,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Theme
                                              .of(context)
                                              .accentColor),
                                      image: _imageFile == null
                                          ? null
                                          : DecorationImage(
                                          image: FileImage(_imageFile),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              Positioned(
                                  right: 5,
                                  bottom: 5,
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 0.5,
                                            color: Theme
                                                .of(context)
                                                .accentColor),
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                      ),
                                      child: Center(
                                        child: (_listFileImage != null &&
                                            _listFileImage.length == 0)
                                            ? Icon(
                                          Icons.add,
                                          color:
                                          Theme
                                              .of(context)
                                              .accentColor,
                                          size: 18,
                                        )
                                            : Text(
                                          "+" +
                                              _listFileImage.length
                                                  .toString(),
                                          style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .accentColor,
                                              fontSize: 10),
                                          textAlign: TextAlign.center,
                                        ),
                                      )))
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              controller: _textCommentController,
                              autofocus: false,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 16),
                                hintText: 'Add a comment...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Text(
                        '#',
                        style: TextStyle(color: Colors.black54, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      title: Container(
                        width: 250,
                        child: TextField(
                          controller: tagFriendController,
                          decoration: InputDecoration(
                              hintText: 'Gắn thẻ người khác',
                              helperText:
                              'Gắn thẻ để bạn bè có thể thấy được hình \nđăng một cách dễ dàng',
                              border: InputBorder.none),
                        ),
                      ),
                      trailing: InkWell(
                          onTap: () => print('Hiện Khung chọn bạn'),
                          child: Icon(Icons.add)),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Container(
                        width: 250,
                        child: TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                              hintText: 'Thêm vị trí được chọn',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    (address == null)
                        ? Container()
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildLocationButton(address.addressLine),
                          _buildLocationButton(address.thoroughfare),
                          _buildLocationButton(address.subLocality),
                          _buildLocationButton(address.locality),
                          _buildLocationButton(address.subAdminArea),
                          _buildLocationButton(address.adminArea),
                          _buildLocationButton(address.countryName),
                          _buildLocationButton(address.countryCode),
                          _buildLocationButton(address.subThoroughfare),
                        ],
                      ),
                    ),
                  ],
                ),
                BlocBuilder<ShareStoriesBloc, ShareStoriesState>(
                  builder: (context, state) {
                    if (state is InProgressShareStoriesState) {
                      return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme
                                        .of(context)
                                        .accentColor),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Waiting...',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .caption,
                              )
                            ],
                          ));
                    }
                    if (state is InProgressFinishShareStoriesState) {
                      return Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.check,
                                size: 40,
                                color: Theme
                                    .of(context)
                                    .accentColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //method to build buttons with location.
  _buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () {
            locationController.text = locationName;
          },
          child: Center(
            child: Container(
              //width: 100.0,
              height: 30.0,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              margin: EdgeInsets.only(right: 3.0, left: 3.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  locationName,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
