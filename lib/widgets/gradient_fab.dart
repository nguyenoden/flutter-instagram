import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';
import 'package:flutter_clb_tinhban_ui_app/util/read_more_text.dart';

class GradientFab extends StatelessWidget {
  final Animation<double> animation;
  final TickerProvider vsync;
  final VoidCallback onPressed;
  final Widget child;
  final double elevation;

  const GradientFab(
      {Key key,
      this.animation,
      this.vsync,
      this.onPressed,
      this.child,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fab = FloatingActionButton(
      elevation: elevation != null ? elevation : 6,
      mini: true,
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [
                  Palette.gradientStartColor,
                  Palette.gradientEndColor
                ])),
        child: child,
      ),
      onPressed: onPressed,
    );

    return animation != null
        ? AnimatedSize(
            duration: Duration(milliseconds: 1000),
            curve: Curves.linear,
            vsync: vsync,
            child: ScaleTransition(scale: animation, child: fab))
        : fab;
  }
}
