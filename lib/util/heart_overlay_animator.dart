import 'package:flutter/material.dart';

class HeartOverlayAnimator extends StatefulWidget {
  final Stream<void> triggerAnimationStream;

  HeartOverlayAnimator({@required this.triggerAnimationStream});

  @override
  _HeartOverlayAnimatorState createState() => _HeartOverlayAnimatorState();
}

class _HeartOverlayAnimatorState extends State<HeartOverlayAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _heartController;
  Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    final quick = const Duration(milliseconds: 500);
    final scaleTween  = Tween(end: 1.0, begin: 0.0);
    _heartController = AnimationController(duration: quick, vsync: this);
     final Animation  curve=CurvedAnimation(parent: _heartController,curve: Curves.elasticOut);
    _heartAnimation=scaleTween.animate(curve);

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.decelerate,
        );
      }
    });
    widget.triggerAnimationStream.listen((_) {
      _heartController
        ..reset()
        ..forward();
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _heartAnimation,
      child: Icon(
        Icons.favorite,
        size: 100.0,
        color: Colors.red.withOpacity(0.3)
      ),
    );
  }
}
