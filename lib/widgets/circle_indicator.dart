import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';

// ignore: must_be_immutable
class CircleIndicator extends StatefulWidget {
  bool isActive;
  CircleIndicator(this.isActive);
  @override
  _CircleIndicatorState createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.all(2),
      duration: Duration(microseconds: 600),
      height: widget.isActive ? 12 : 8,
      width: widget.isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: widget.isActive ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
