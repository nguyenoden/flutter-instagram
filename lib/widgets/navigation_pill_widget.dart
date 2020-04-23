import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';

class NavigationPillWidget extends StatefulWidget {
  @override
  _NavigationPillWidgetState createState() => _NavigationPillWidgetState();
}

class _NavigationPillWidgetState extends State<NavigationPillWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Center(
              child: Wrap(
                children: <Widget>[
                  Container(
                    width: 50,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 5,
                    decoration: new BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
