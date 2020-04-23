import 'package:flutter/material.dart';

class CountImagePost extends StatefulWidget {
  final Stream<void> triggerAnimationStream;
  final int index;
  final int size;
  CountImagePost({@required this.triggerAnimationStream, this.index, this.size});
  @override
  _CountImagePostState createState() => _CountImagePostState();
}

class _CountImagePostState extends State<CountImagePost>
    with SingleTickerProviderStateMixin {
  AnimationController _heartController;
  Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    final quick = const Duration(milliseconds: 2000);
    final scaleTween  = Tween(end: 1.0, begin: 0.0);
    _heartController = AnimationController(duration: quick, vsync: this);
    final Animation  curve=CurvedAnimation(parent: _heartController,curve: Curves.elasticOut);
   _heartAnimation=scaleTween.animate(curve);

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartController.animateTo(
          0.0,
          duration: const Duration(milliseconds:500),
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
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              '${widget.index+ 1}/${widget.size}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
