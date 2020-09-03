import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/src/common/AppData.dart';

import '../Config.dart';

class Tool{

  /*
  检查用户信息
   */
  static bool checkUserInfo(){
    return AppData.user==null?false:true;
  }
  /*
    强制竖屏
     */
  static void  setForcedVerticalscreen (){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  /*
    强制横屏
     */
  static void  setForcedHorizontalScreen (){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }


  /*
  信息提示框
   */
  static void showTipsDialog(BuildContext context,String msg){
    showDialog(context: context,builder:(BuildContext context)=>
    Container(
        width:MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width:MediaQuery.of(context).size.width*0.8,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '提示',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF333333),
                        decoration: TextDecoration.none),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      msg,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:Colors.grey,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  new GestureDetector(
                      child: Text(
                        '关闭 ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color:Config.THEME.primaryColorDark,
                            decoration: TextDecoration.none),
                      ),
                      onTap:(){
                        Navigator.of(context).pop();
                      }
                  )
                ],
              ),
            ),
          ],
        ))
    );
  }

}