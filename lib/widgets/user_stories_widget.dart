import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/profile/bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/model/stories.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UserStoriesWidget extends StatefulWidget {


  final Stories stories;

  const UserStoriesWidget({Key key,  this.stories}) : super(key: key);

  @override
  _UserStoriesWidgetState createState() => _UserStoriesWidgetState(stories);
}

class _UserStoriesWidgetState extends State<UserStoriesWidget> {

  final Stories stories;
  ProfileBloc profileBloc;
  User user;


  @override
  void initState() {
    user=User();
    profileBloc=BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(FetchProfileUserEvent(stories.uid));
    super.initState();
  }

  _UserStoriesWidgetState(this.stories);

  @override
  Widget build(BuildContext context) {
    return  BlocListener<ProfileBloc,ProfileState>(
      bloc: profileBloc,
      listener: (context,state){
        if( state is FetchedProfileUserState) {
          user = state.user;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                user.photoUrl!=null?
                CachedNetworkImageProvider(user.photoUrl):
                AssetImage(Assets.placeholder),
              ),
              width: 30.0,
              height: 30.0,
              padding: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.circle),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.username??"Chưa biết",
                    style: Theme.of(context).textTheme.subtitle),
                Row(
                  children: <Widget>[
                    Text(
                      "${DateFormat('d MMM').format(DateTime.fromMillisecondsSinceEpoch(stories.timeStamp))}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: stories.location.isNotEmpty
                          ? Theme.of(context).accentColor
                          : Colors.grey,
                    ),
                    Container(
                        width: 100,
                        child: Text(
                          stories.location,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                )
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () => {showDialogOption(context)},
              icon: Icon(
                Icons.more_vert,
                size: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
  showDialogOption(BuildContext context) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return SimpleDialog(
            title: null,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.report,
                        size: 24,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Báo cáo...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  onPressed: () => print('Bao cao'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.save_alt,
                        size: 24,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Sao chép liên kết', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.notifications_active,
                        size: 24,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Bật thông báo bài viết',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        size: 24,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Chia sẻ lên', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 24,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Bỏ theo dõi', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SimpleDialogOption(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.cancel,
                        size: 24,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Thoát', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }
}
