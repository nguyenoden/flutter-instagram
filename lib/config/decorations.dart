import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';

class Decorations {
  static InputDecoration getInputDecoration(
      {@required String hint, @required BuildContext context}) {
    return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).hintColor, width: 0.1)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).hintColor, width: 0.1)));
  }

  static InputDecoration getInputDecorationLight(
      {@required String hint, @required BuildContext context}) {
    return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 0.1)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 0.1)));
  }

  static BoxDecoration boxDecorationStories(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor,
      boxShadow: [
        BoxShadow(
            color: Palette.colorGrey, offset: Offset(0.2, 0.2), blurRadius: 1)
      ],
      borderRadius: BorderRadius.circular(10),
    );
  }
}
