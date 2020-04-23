import 'package:flutter/material.dart';

import 'package:flutter_clb_tinhban_ui_app/model/post.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';

import 'package:flutter_clb_tinhban_ui_app/widgets/avatar_circle_widget.dart';

class ProfileFriend extends StatefulWidget {
  final User user;
  final Post post;

  const ProfileFriend({Key key, this.user, this.post}) : super(key: key);

  @override
  _ProfileFriendState createState() => _ProfileFriendState();
}

class _ProfileFriendState extends State<ProfileFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          leading: InkWell(
              splashColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black87,
              )),
          title: Text(
            widget.user.name,
            style: TextStyle(
                color: Colors.black, fontFamily: 'Billabong', fontSize: 30),
          ),
          actions: <Widget>[
            Icon(
              Icons.more_vert,
              size: 30,
              color: Colors.black87,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              radius: 60,
                              //backgroundImage: file!=null?FileImage(file):null,
                              child:  Center(
                                child: Icon(
                                  Icons.camera,
                                  color: Theme.of(context).accentColor,
                                  size: 24,
                                ),
                              ),

                            ),
                            width: 90.0,
                            height: 90.0,
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle),
                          ),
                          Text(
                            '${widget.user.name}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Lập trinh/ flutter',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'http://fluttervn.vn,123456789',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '10',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Bài viết',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '100',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Người theo dõi',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '99',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Đang theo..',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.red,
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.blue),
                      child: Text(
                        'Theo Dõi',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    splashColor: Colors.lightBlueAccent.withOpacity(0.3),
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.white),
                      child: Text(
                        'Nhắn tin',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.count(
              primary: false,
              crossAxisSpacing: 0.5,
              mainAxisSpacing: 0.5,
              crossAxisCount: 3,
              children:
                  widget.post.imgUrls.map((url) => loadImage(url)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget loadImage(url) {
    return Container(
      child: Image.asset(
        url,
        fit: BoxFit.cover,
      ),
    );
  }
}
