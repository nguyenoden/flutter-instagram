import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/user_stories/bloc.dart';

import 'package:flutter_clb_tinhban_ui_app/blocs/user_stories/user_stories_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/config/decorations.dart';
import 'package:flutter_clb_tinhban_ui_app/config/transitions.dart';
import 'package:flutter_clb_tinhban_ui_app/homepage/home_clb.dart';
import 'package:flutter_clb_tinhban_ui_app/model/user.dart';
import 'package:flutter_clb_tinhban_ui_app/profile/profile.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'avatar_container_widget.dart';

class StoriesTopUserWidget extends StatefulWidget {
  const StoriesTopUserWidget() : super();

  @override
  _StoriesTopUserWidgetState createState() => _StoriesTopUserWidgetState();
}

class _StoriesTopUserWidgetState extends State<StoriesTopUserWidget>
    with SingleTickerProviderStateMixin {
  List<User> listUser;
  UserStoriesBloc userStoriesBloc;


  @override
  void initState() {
    super.initState();
    listUser = List();
    userStoriesBloc = BlocProvider.of<UserStoriesBloc>(context);
    userStoriesBloc.add(FetchListUserEvent());

  }

  _StoriesTopUserWidgetState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStoriesBloc, UserStoriesState>(
      bloc: userStoriesBloc,
      builder: (context, state) {
        if (state is FetchedListUserState) {
          listUser = state.listUser;
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                constraints: BoxConstraints(
                    maxHeight: ScreenUtil().setHeight(560),
                    maxWidth: double.infinity),
                height: ScreenUtil().setHeight(560),
                decoration: Decorations.boxDecorationStories(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: Text(
                          'Top Thanh Vien Tuan',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(440),
                          child: ListView.builder(
                            physics: PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return GestureDetector(
                                onTap: () {},
                                child: AvatarContainerWidget(
                                  user: listUser[i],
                                  context: context,
                                ),
                              );
                            },
                            itemCount: listUser.length,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );
        }
        return SizedBox();
      },
    );
  }
}
