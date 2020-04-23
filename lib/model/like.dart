
import 'package:flutter_clb_tinhban_ui_app/model/user_base.dart';

class Like {
  final UserBase user;
  Like({this.user});
  @override
  String toString() {
    return 'Like{user: $user}';
  }
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map= Map();
    map['user']=user;
    return map;
  }
}
