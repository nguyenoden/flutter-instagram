import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes{
  
  static final ThemeData light= ThemeData(
    accentColor: Palette.accentColorLight,
    primaryColor: Palette.primaryColorLight,
    primarySwatch: Palette.accentColorLight,
    disabledColor: Palette.colorGrey,
    cardColor: Palette.colorWhite,
    scaffoldBackgroundColor:  Palette.colorWhite,
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.light,
    backgroundColor: Palette.colorWhite,
    buttonColor: Palette.accentColorLight,
    appBarTheme: AppBarTheme(elevation: 0.1),
    fontFamily: 'Manrope',
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
    textTheme:TextTheme(
      display2: TextStyle(color: Palette.colorWhite,fontSize: 24,fontWeight: FontWeight.w700,fontStyle: FontStyle.normal,fontFamily: 'Manrope'),
      display1: TextStyle(color:  Palette.colorWhite,fontSize: 20),
      caption:  TextStyle(color:  Palette.colorGrey,fontSize: 12,),
      body2:  TextStyle(color:  Palette.colorBlack,fontSize:16,fontWeight: FontWeight.w600),
      subtitle: TextStyle(color:  Palette.colorBlack,fontSize:14,fontWeight: FontWeight.w600),
      title: TextStyle(color: Palette.colorBlack,fontSize: 20,fontStyle: FontStyle.normal ),
      body1: TextStyle(color: Palette.colorBlack,fontSize: 14,fontStyle: FontStyle.normal ),

    )

  );

  static final ThemeData dark= ThemeData(
      accentColor: Palette.accentColorDart,
      primaryColor: Palette.primaryColorDart,
      primarySwatch:  Palette.accentColorDart,
      disabledColor: Palette.colorGrey,
      cardColor: Color(0xff191919),
      canvasColor: Colors.grey[50],
      scaffoldBackgroundColor: Palette.primaryColorDart,
      brightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      backgroundColor:Color(0xff191919),
      buttonColor: Palette.accentColorDart,
      appBarTheme: AppBarTheme(elevation: 0.1),
      fontFamily: 'Billabong',
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0))

  );
}