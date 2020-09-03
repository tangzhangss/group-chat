import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/src/Config.dart';

class Input{

  static final Input instance = new Input();

  BoxDecoration _boxDecoration = new BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),//圆角
    boxShadow: [
      BoxShadow(
          offset:Offset(2.0,2.0),//x y偏移量
          color: Config.THEME.primaryColor,
          blurRadius:6.0,//模糊程度
          spreadRadius:1.0//阴影面积
      )
    ],
    color: Colors.white,
  );


  BoxDecoration getBoxDecoration(){
     return _boxDecoration;
  }
}