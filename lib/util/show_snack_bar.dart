import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, text) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text,style: TextStyle(color: Colors.white),),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.grey.shade600,

  ));
}
