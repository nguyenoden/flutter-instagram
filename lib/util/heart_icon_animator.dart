import 'dart:ffi';

import 'package:flutter/material.dart';

class HearIconAnimation extends StatefulWidget {
  final VoidCallback opTap;
  final Stream<Void> triggerAnimationStream;
  final double size;
  final bool isLike;
  final Color color;

  const HearIconAnimation(
      {Key key,
      @required this.opTap,
      this.triggerAnimationStream,
      this.size = 24.0,
      this.isLike=false, this.color})
      : super(key: key);

  @override
  _HearIconAnimationState createState() => _HearIconAnimationState();
}

class _HearIconAnimationState extends State<HearIconAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  Animation _curve;

  @override
  void initState() {
    super.initState();
    final quick = const Duration(milliseconds: 600);
    final scale = Tween<double>(begin:0, end: 1.0);
    _animationController = AnimationController(duration: quick, vsync: this);
     _curve=CurvedAnimation(parent: _animationController,curve: Curves.elasticOut);
    _animation = scale.animate(_curve);
    _animationController.animateTo(1.0, duration: Duration.zero);
    if (widget.triggerAnimationStream != null) {
      widget.triggerAnimationStream.listen((_) => _animate());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animate() {
    _animationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return _TapHeart(
      color: widget.color,
      size: widget.size,
      isLike: widget.isLike,
      opTap: () {
        _animate();
        widget.opTap();
      },
      animation: _animation,
    );
  }
}
class _TapHeart extends AnimatedWidget {
  final bool isLike;
  final double size;
  final VoidCallback opTap;
  final Color color;
  _TapHeart(
      {Key key,
        this.color,
        @required  this.isLike,
        @required  this.size,
        @required this.opTap,
        @required  Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScaleTransition(
      scale: listenable,
      child: GestureDetector(
        child: isLike
            ? Icon(
                Icons.favorite,
                color: Colors.red,size: size,
              )
            : Icon(
                Icons.favorite_border,
                color: color,size: size,
              ),
        onTap: opTap,
      ),
    );
  }
}
