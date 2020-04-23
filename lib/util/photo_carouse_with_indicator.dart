import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoCarouseWithIndicator extends StatelessWidget {
  final int photoCount;
  final int photoIndex;


  const PhotoCarouseWithIndicator(
      {Key key, @required this.photoCount, @required this.photoIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int size;
    if(photoCount>5){
     size=5;
    }else{
      size=photoCount;
    }

    // TODO: implement build
    return
      Row(
      children:
      List.generate(size, (i)=> i).map((i)=>_buildDot(i==photoIndex)).toList()
    );
  }
  Widget _buildDot(bool isActive) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          width: isActive ? 6.0 : 5.0,
          height: isActive ? 6.0 : 5.0,
          decoration: BoxDecoration(
              color: isActive ? Colors.blue : Colors.grey,
              shape: BoxShape.circle

          ),
        ),
      ),
    );
  }
}
