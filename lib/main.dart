import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/src/Config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groupchat/src/common/AppData.dart';
import 'package:groupchat/src/common/BottomTab.dart';
import 'package:groupchat/src/entity/User.dart';
import 'package:groupchat/src/util/sp_util.dart';
import 'package:groupchat/src/view/Chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groupchat/src/view/Login.dart';
import 'package:groupchat/src/view/Index.dart';
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class InitState extends State<Init>{
  int _flag = 0; //0等待 1进入首页  2登陆页面
  InitState(){
    _checkSpInit();
  }
  _checkSpInit() async{
    //从缓存中回去用户信息
    if(SpUtil.instance.spf == null){
      SpUtil.instance.spf =  await SharedPreferences.getInstance();
      if(SpUtil.instance.spf != null){
        print("SharedPreferences 初始化完成!");
          _getUserInfo();
      }
    }else{
      _getUserInfo();
    }
  }

  _getUserInfo(){
    User user = new User();//用户信息
    var str  = SpUtil.instance.getString("user");

    setState((){
      if(str == null){
        //注册登录.....
        print("缓存没有获取到user信息");
        _flag=2;
      }else{
        AppData.user = user.getUserByJsonString(str);
        print("缓存获取到了user信息:"+AppData.user.toJson().toString());
        _flag=1;
      }
    });
  }
   Widget _index = new Scaffold(
      appBar: new AppBar(
        title: new Text("群聊"),
      ),
      body: new Center(child:new Text("我是首页"))
    );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
        EasyLoading.show(status: "loading");
    });
   }
  @override
  Widget build(BuildContext context){
    if(_flag==0){
      WidgetsBinding.instance.addPostFrameCallback((_){
        EasyLoading.show(status: "loading");
      });
      return  Scaffold(
          appBar: new AppBar(
            title: new Text("群聊"),
          ),
          body: new Center(child:new Text(""))
      );
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_){
        EasyLoading.dismiss();
      });
      return new BottomTab();
    }
  }
}
class Init extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return  new InitState();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.initConfigEasyLoading(context); //交互组件
    return MaterialApp(
        title: '群聊',
        theme: Config.THEME,
        debugShowCheckedModeBanner: false,
         home: new FlutterEasyLoading(
                   child:  Init()
         ),
        routes: {
          "login_page": (BuildContext context) => new LoginView(),
          "bottom_tab": (BuildContext context) => new BottomTab(),
        },
    );
  }
}
