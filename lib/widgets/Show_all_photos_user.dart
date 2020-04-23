import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/photo_full_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShowAllPhotosUser extends StatefulWidget {
  final List<String> listPhotos;

  const ShowAllPhotosUser({Key key, this.listPhotos}) : super(key: key);

  @override
  _ShowAllPhotosUserState createState() => _ShowAllPhotosUserState(listPhotos);
}

class _ShowAllPhotosUserState extends State<ShowAllPhotosUser> {
  final List<String> listPhotos;

  _ShowAllPhotosUserState(this.listPhotos);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: listPhotos.length,
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 2 : 1),
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  SlideLeftRout(
                      page: PhotoFullScreen(
                    url: listPhotos,
                    imageIndex: index,
                  )));
            },
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: listPhotos[index] != null
                          ? CachedNetworkImageProvider(listPhotos[index])
                          : AssetImage(Assets.placeholder),
                      fit: BoxFit.cover)),
            ),
          ),
        ),
      ),
    );
  }
}
