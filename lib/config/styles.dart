import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  // Style AppBar
  static TextStyle textAppBarStories = TextStyle(
      color: Palette.secondaryColorLight,
      fontFamily: 'Billabong',
      fontSize: ScreenUtil().setSp(80, allowFontScalingSelf: true),
      letterSpacing: 2.0);
  static TextStyle textHeading = GoogleFonts.lato(
      color: Palette.secondaryColorLight,
      fontSize: ScreenUtil().setSp(70),
      fontWeight: FontWeight.normal);
  static TextStyle textStoriesComment = GoogleFonts.lato(
      color: Palette.secondaryColorLight,
      fontSize: ScreenUtil().setSp(45),
      fontWeight: FontWeight.normal);
  static TextStyle textStoriesGrey = TextStyle(
    color: Palette.colorGrey,
    fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true),
  );
  static TextStyle textStoriesBold = TextStyle(
      color: Palette.secondaryColorDart,
      fontSize: ScreenUtil().setSp(38, allowFontScalingSelf: true),
      fontWeight: FontWeight.bold);

  static TextStyle textSigInRegister = TextStyle(
    color: Palette.colorWhite,
    fontSize: 16,
  );
  static TextStyle textMessageRegister = TextStyle(
      color: Palette.colorWhite,
      fontSize: 30,
      fontFamily: 'Billabong',
      letterSpacing: 5.0);

  static TextStyle textHeadingStories = GoogleFonts.lato(
      color: Palette.secondaryColorLight,
      fontSize: ScreenUtil().setSp(50),
      fontWeight: FontWeight.bold);
  static TextStyle textSub =
      TextStyle(color: Palette.secondaryColorLight, fontSize: 14);
  static TextStyle textDate =
      TextStyle(color: Palette.secondaryColorLight, fontSize: 14);

  static TextStyle numberPickerHeading =
      TextStyle(fontSize: 30, color: Palette.primaryColorLight);
  static TextStyle textButtonLight =
      TextStyle(color: Palette.primaryColorLight, fontSize: 14);

  static TextStyle questionLight =
      TextStyle(color: Palette.primaryColorLight, fontSize: 18);

  static TextStyle subHeadingLight =
      TextStyle(color: Palette.primaryColorLight, fontSize: 14);

  static TextStyle textLight =
      TextStyle(color: Palette.secondaryColorLight);
  static TextStyle hintTextLight = TextStyle(color: Palette.primaryColorLight);
  static TextStyle appBarTitle = TextStyle(
      color: Palette.secondaryColorLight, fontSize: ScreenUtil().setSp(50));
}
