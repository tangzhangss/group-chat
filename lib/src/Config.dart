import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupchat/src/util/http_request.dart';

class Config{
   static const String DOMAIN="http://groupchat.tzss.ink/api/tangzhangss/groupchat/";
   static const String WEBSOCKETURL="ws://groupchat.tzss.ink:10005/ws";
   static final  ThemeData THEME= new ThemeData(
      primaryColor: Colors.pink[300],
      primaryColorLight:Colors.pink[100],
      primaryColorDark:Colors.pink[500],
   );

   static void initConfigEasyLoading(context){
      EasyLoading.instance
         ..context=context
         ..displayDuration = const Duration(milliseconds: 2000)
         ..indicatorType = EasyLoadingIndicatorType.fadingCircle
         ..loadingStyle = EasyLoadingStyle.custom
         ..indicatorSize = 45.0
         ..radius = 10.0
         ..progressColor =THEME.primaryColor
         ..backgroundColor = Colors.white.withOpacity(0.9)
         ..indicatorColor = THEME.primaryColor
         ..textColor =THEME.primaryColor
         ..maskColor = Colors.white.withOpacity(0.4)
         ..userInteractions = true
         ..maskType = EasyLoadingMaskType.custom
         ..userInteractions=false;
      }

   static void showToast(msg){
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,  // 消息框弹出的位置
          timeInSecForIos: 1,  // 消息框持续的时间（目前的版本只有ios有效）
          fontSize: 16.0
      );
   }
}