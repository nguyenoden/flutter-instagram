import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/constants.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/messager/messages_page.dart';

import 'package:flutter_clb_tinhban_ui_app/model/data.dart';

import 'package:flutter_clb_tinhban_ui_app/homepage/stories_page.dart';
import 'package:flutter_clb_tinhban_ui_app/pages/contact_list_page.dart';

import 'package:flutter_clb_tinhban_ui_app/profile/profile.dart';
import 'package:flutter_clb_tinhban_ui_app/search/search.dart';
import 'package:flutter_clb_tinhban_ui_app/util/shared_objects.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCLB extends StatefulWidget {


  const HomeCLB({Key key }) : super(key: key);
  @override
  _HomeCLBState createState() => _HomeCLBState();
}

class _HomeCLBState extends State<HomeCLB> {
  // ScrollController _scrollController;
  PageController pageController;
  var _tabSelectedIndex = 0;

  _HomeCLBState();
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

//  void scrollToTop() {
//    if (_scrollController == null) {
//      return;
//    } else {
//      _scrollController.animateTo(0.0,
//          duration: Duration(milliseconds: 200), curve: Curves.decelerate);
//    }
//  }

   void navigationTapped(int page) {
   pageController.jumpToPage(page);
  }
  void onChangePage(int page) {
    setState(() {
      this._tabSelectedIndex = page;
    });
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you really want to exits app'),
              actions: <Widget>[
                FlatButton(
                    child: Text("No"),
                    onPressed: () => Navigator.pop(context, false)),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width * mediaQuery.devicePixelRatio;
    var height = mediaQuery.size.height * mediaQuery.devicePixelRatio;
    print('width: $width, height: $height');
    ScreenUtil.init(context,
        width: width, height: height, allowFontScaling: false);
    return Scaffold(
        body: pageStoriesViewWidget(),
        bottomNavigationBar: _buildBottomNavigationBar());
  }

  Widget pageStoriesViewWidget() {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PageView(
        controller: pageController,
        onPageChanged: onChangePage,
        physics: new NeverScrollableScrollPhysics(), // Disable Scroll page view
        children: <Widget>[
          StoriesPage(),
          SearchPage(),
          MessagesPage(),
          ContactListPage(),
          Profile(uid:ShareObjects.prefs.getString(Constants.sessionUid),
          ),
          //ContactListPage()
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    const _unselectedIcon = <IconData>[
      Icons.home,
      Icons.search,
      Icons.near_me,
      Icons.contacts,
      Icons.person,
    ];
    const _selectedIcon = <IconData>[
      Icons.home,
      Icons.search,
      Icons.near_me,
      Icons.contacts,
      Icons.person,
    ];
    const List labelTab = ['Home', 'Search', 'Messages', 'Contacts', 'Profile'];
    final itemBottomNavigationBar = List.generate(5, (i) {
      final iconData =
          _tabSelectedIndex == i ? _selectedIcon[i] : _unselectedIcon[i];
      return BottomNavigationBarItem(
          icon: Icon(
            iconData,
          ),
          title: Text(
            '${labelTab[i]}',
          ));
    }).toList();
    return Container(
      height: 55.0,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [BoxShadow(color: Colors.black)]),
      child: BottomNavigationBar(
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Theme.of(context).accentColor),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        elevation: 0,
        items: itemBottomNavigationBar,
        iconSize: 24,
        currentIndex: _tabSelectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: navigationTapped,
      ),
    );
  }
}
