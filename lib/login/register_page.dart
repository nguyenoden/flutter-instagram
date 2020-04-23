import 'dart:io';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_event.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/authentication_state.dart';
import 'package:flutter_clb_tinhban_ui_app/config/assets.dart';
import 'package:flutter_clb_tinhban_ui_app/config/language.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/config/styles.dart';

import 'package:flutter_clb_tinhban_ui_app/provider/authentication_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/circle_indicator.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/gradient_snack_bar.dart';
import 'package:flutter_clb_tinhban_ui_app/widgets/number_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_clb_tinhban_ui_app/blocs/authentication/bloc.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  PageController pageController;
  ImageProvider profileImage;
  ImageProvider placeHolderImage = Image.asset(Assets.AbrahamLincoln).image;
  int ageCurrent = 18;
  var profileImageFile;
  AuthenticationBloc authenticationBloc;
  AuthenticationProvider authenticationProvider;

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  // Các Animation liên quan đến việc bố trí  ảnh  và đẩy các widget lên khi click vao tên người dùng
  AnimationController usernameFieldAnimationController;
  Animation profilePictureHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();

  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    initApp();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFocusNode.dispose();
    usernameFieldAnimationController.dispose();
    super.dispose();
  }

  void initApp() async {
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
    usernameFieldAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    profilePictureHeightAnimation =
        Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    ageAnimation =
        Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        usernameFieldAnimationController.forward();
      } else {
        usernameFieldAnimationController.reverse();
      }
    });
    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    authenticationBloc.listen((state) {
      if (state is Authenticated) {
        updatePageState(1);
      }
    });
  }

  Future pickImage() async {
    try {
      profileImageFile = await FilePicker.getFile(type: FileType.image);
    } catch (e) {
      profileImageFile = null;
    }
    if (profileImageFile != null) {
      authenticationBloc.add(PickedProfilePicture(profileImageFile));
    }
  }

  updatePageState(index) {
    if (currentPage == index) return;
    if (index == 1) {
      pageController.nextPage(
          duration: Duration(microseconds: 300), curve: Curves.easeIn);
      setState(() {
        currentPage = index;
      });
    }
  }

  Future<bool> onWillPop() async {
    if (currentPage == 1) {
      // di chuyen toi page 1 neu hien tai dang o page 2
      pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      return false;
    }
    return true;
  }

  buildCircularProgressBarWidget() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [Palette.gradientStartColor, Palette.gradientEndColor])),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              buildHeaderSectionWidget(),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                     'Waiting...',
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildHeaderSectionWidget() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 250),
          child: Image.asset(Assets.app_icon_fg, height: 100)),
      Container(
        margin: EdgeInsets.only(top: 30),
        child: Text(
          'Message Group',
          style: Theme.of(context).textTheme.display1,
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop, //user to override the back button press
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        //  avoids the bottom overflow warning when keyboard is shown
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _buildHome(),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthInProgress ||
                      state is ProfileUpdateInProgress) {
                    return buildCircularProgressBarWidget();
                  }
                  return SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildHome() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [Palette.gradientStartColor, Palette.gradientEndColor])),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int page) => updatePageState(page),
            children: <Widget>[
              _buildPageOne(),
              _buildPageTwo(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < 2; i++) CircleIndicator(i == currentPage),
              ],
            ),
          ),
          _buildUpdateProfileButtonWidget()
        ],
      ),
    );
  }

  _buildPageOne() {
    return Column(
      children: <Widget>[
        _buildHeaderSectionWidget(),
        _buildFacebookButtonWidget(),
        _buildGoogleButtonWidget(),
      ],
    );
  }

  _buildHeaderSectionWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child: Image.asset(
            Assets.app_icon_fg,
            height: 100,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Text(
            'Message Group',
            style: Theme.of(context).textTheme.display2,
          ),
        )
      ],
    );
  }

  _buildFacebookButtonWidget() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: FlatButton.icon(
          onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
              .add(ClickedFaceBookLoggedIn()),
          color: Colors.transparent,
          icon: Image.asset(
            Assets.facebook_button,
            height: 25,
            color: Colors.white,
          ),
          label: Text(
            'SIGN WITH FACEBOOK',
            style: Theme.of(context).textTheme.display1,
          )),
    );
  }

  _buildGoogleButtonWidget() {
    return Container(
      child: FlatButton.icon(
          onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
              .add(ClickedGoogleLoggedIn()),
          color: Colors.transparent,
          icon: Image.asset(
            Assets.google_button,
            height: 25,
          ),
          label: Text(
            'SIGN WITH GOOGLE',
            style: Theme.of(context).textTheme.display1,
          )),
    );
  }

  _buildPageTwo() {
    return InkWell(
      // to dismiss the keyboard when the user tabs out of the TextField
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            profileImage = placeHolderImage;
            if (state is PreFillData) {
              ageCurrent = state.user.age != null ? state.user.age : ageCurrent;
              if (state.user.photoUrl != null) {
                profileImage = Image.network(state.user.photoUrl).image;
              }
            }
            if (state is ReceivedProfilePicture) {
              profileImageFile = state.fileImage;
              profileImage = Image.file(profileImageFile).image;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: profilePictureHeightAnimation.value,
                ),
                _buildProfilePictureWidget(),
                SizedBox(
                  height: ageAnimation.value,
                ),
                Text('How old are you', style: Theme.of(context).textTheme.body2),
                _buildAgePickerWidget(),
                SizedBox(
                  height: usernameAnimation.value,
                ),
                GestureDetector(
                  onTap: () => {
                    authenticationBloc.mapLoggedOutToSate(),
                    print('mapLoggedOutToSate')
                  },
                  child: Text(
                    'Choose a username',
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildUsernameWidget()
              ],
            );
          },
        ),
      ),
    );
  }

  _buildProfilePictureWidget() {
    return GestureDetector(
      onTap: () => pickImage(),
      child: CircleAvatar(
        backgroundImage: profileImage,
        radius: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            Text(
              'Set Profile Picture',
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  _buildAgePickerWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new NumberPicker.horizontal(
            highlightSelectedValue: true,
            initialValue: ageCurrent,
            minValue: 15,
            maxValue: 100,
            onChanged: (num value) {
              setState(() {
                ageCurrent = value;
              });
            }),
        Text(
          ' YearOld',
          style: Theme.of(context).textTheme.body2,
        )
      ],
    );
  }

  _buildUsernameWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 120,
      child: TextField(
        style: Theme.of(context).textTheme.display1,
        focusNode: usernameFocusNode,
        controller: usernameController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            hintText: '@username',
            hintStyle: Theme.of(context).textTheme.caption,
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 0.1)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 0.1))),
      ),
    );
  }

  _buildUpdateProfileButtonWidget() {
    return AnimatedOpacity(
      opacity: currentPage == 1 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.only(bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                if ((profileImageFile != null) &&
                    ageCurrent != null &&
                    usernameController.text.isNotEmpty) {
                  authenticationBloc.add(SaveProfile(
                      profileImageFile, ageCurrent, usernameController.text));
                } else {
                  GradientSnackBar.errorMessage(
                      context, 'Please choose avata ,age and username');
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              child: Icon(
                Icons.done,
                color: Theme.of(context).accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
