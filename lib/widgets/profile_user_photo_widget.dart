import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/Show_all_photos_user.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/avatar_container_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/container_photo_widget.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/photo_full_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileUserPhotoWidget extends StatefulWidget {
  final List<String> listPhotos;

  const ProfileUserPhotoWidget({
    Key key,
    this.listPhotos,
  }) : super(key: key);

  @override
  _ProfileUserPhotoWidgetState createState() =>
      _ProfileUserPhotoWidgetState(listPhotos);
}

class _ProfileUserPhotoWidgetState extends State<ProfileUserPhotoWidget> {
  final List<String> listPhotos;

  _ProfileUserPhotoWidgetState(this.listPhotos);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(400),
        decoration: Decorations.boxDecorationStories(context),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Photos (${listPhotos.length})", style: Theme.of(context).textTheme.body1),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, SlideLeftRout(page: ShowAllPhotosUser(listPhotos: listPhotos,)));
                    },
                    child: Text("Xem tất cả",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize:
                              ScreenUtil().setSp(35, allowFontScalingSelf: true),
                        )),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(300),
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, SlideLeftRout(page: PhotoFullScreen(url: listPhotos,imageIndex: i,)));
                      },
                      child: ContainerPhotoWidget(
                        photoUrl: listPhotos[i],
                      ),
                    );
                  },
                  itemCount: listPhotos.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
