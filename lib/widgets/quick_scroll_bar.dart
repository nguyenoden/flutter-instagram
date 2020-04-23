import 'package:flutter/material.dart';
import 'package:flutter_clb_tinhban_ui_app/config/palette.dart';

class QuickScrollBar extends StatefulWidget {
  final List nameList;
  final ScrollController scrollController;

  const QuickScrollBar(
      {Key key, @required this.nameList, @required this.scrollController})
      : super(key: key);

  @override
  _QuickScrollBarState createState() =>
      _QuickScrollBarState(nameList, scrollController);
}

class _QuickScrollBarState extends State<QuickScrollBar> {
  double offsetContainer = 0.0;
  var scrollBarText;
  var scrollBarTextPrev;
  var scrollBarHeight;
  var contactRowSize = 45.0;
  var scrollBarMarginRight = 50.0;
  var scrollBarContainerHeight;
  var scrollBarPosSelected = 0;
  var screenHeight = 0.0;
  var scrollBarHeightDiff = 0.0;

  ScrollController scrollController;
  String scrollBarBubbleText = '';
  bool scrollBarBubbleVisible = false;
  List nameList;
  _QuickScrollBarState(this.nameList, this.scrollController);
  List alphabetList = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(builder: (context, constraints) {
      scrollBarHeightDiff = screenHeight - constraints.biggest.height;
      scrollBarHeight = (constraints.biggest.height) / alphabetList.length;
      scrollBarContainerHeight = (constraints.biggest.height);
      return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onVerticalDragEnd: _onVerticalEnd,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragStart: _onVerticalDragStart,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: []..addAll(List.generate(
                      alphabetList.length, (index) => _getAlphabetItem(index))),
                ),
              ),
            ),
          ),
          Positioned(
            right: scrollBarMarginRight,
            top: offsetContainer,
            child: _getBubble(),
          )
        ],
      );
    });
  }

  _getAlphabetItem(int index) {
    return Expanded(
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          alphabetList[index],
          style: (index == scrollBarPosSelected)
              ? TextStyle(fontSize: 14, fontWeight: FontWeight.w800)
              : TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _getBubble() {
    if (!scrollBarBubbleVisible) {
      return Container();
    }
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Center(
        child: Text(
          "${scrollBarText ?? "${alphabetList.first}"}",
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      scrollBarBubbleVisible = true;
      print(offsetContainer);
      print(details);
      if ((offsetContainer + details.delta.dy) >= 0 &&
          (offsetContainer + details.delta.dy) <=
              (scrollBarContainerHeight - scrollBarHeight)) {
        offsetContainer += details.delta.dy;
        print(offsetContainer);
        scrollBarPosSelected =
            ((offsetContainer / scrollBarHeight) % alphabetList.length).round();
        print(scrollBarPosSelected);
        scrollBarText = alphabetList[scrollBarPosSelected];
        if (scrollBarText != scrollBarTextPrev) {
          for (var i = 0; i < nameList.length; i++) {
            print(scrollBarText.toString());
            if (scrollBarText
                    .toString()
                    .compareTo(nameList[i].toString().toUpperCase()[0]) ==
                0) {
              print(nameList[i]);
              scrollController.jumpTo(i * contactRowSize);
              break;
            }
          }
          scrollBarTextPrev = scrollBarText;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    offsetContainer = details.globalPosition.dy - scrollBarHeightDiff;
    setState(() {
      scrollBarBubbleVisible = true;
    });
  }

  void _onVerticalEnd(DragEndDetails details) {
    setState(() {
      scrollBarBubbleVisible = false;
    });
  }
}
