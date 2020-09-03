import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groupchat/src/Config.dart';
import 'package:groupchat/src/common/AppData.dart';
import 'package:groupchat/src/common/Input.dart';
import 'package:groupchat/src/common/Tool.dart';
import 'package:groupchat/src/entity/User.dart';
import 'package:groupchat/src/util/http_request.dart';
import 'package:groupchat/src/util/sp_util.dart';
import 'package:groupchat/src/view/Index.dart';

class LoginView  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return  new LoginViewState();
  }
}

class LoginViewState extends State<LoginView>{

  //手机号的控制器
  TextEditingController _accountController = TextEditingController();

  //密码的控制器
  TextEditingController _lockController = TextEditingController();
  bool _lockInvisible = true;//密码不可见



  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        appBar: new AppBar(
          title: new Text("登录|注册"),
        ),
        body: new SingleChildScrollView(
           child: new Container(
               child: new Column(
                 crossAxisAlignment:CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   new Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children:[
                         new Container(
                           margin:EdgeInsets.fromLTRB(0,10,0,60),
                           child:  new Image(
                             image: new AssetImage("images/logo-noback-black.png"),
                             width:150,
                             height:150,
                           ),
                         ),
                       ]
                   ),
                   new Row(
                     children: [
                       new Column(
                         children:[
                           new Container(
                             width:MediaQuery.of(context).size.width,
                             child:new FractionallySizedBox(
                               widthFactor:0.9,
                               child: new Container(
                                   padding:EdgeInsets.fromLTRB(10,0,10,0),
                                   decoration:Input.instance.getBoxDecoration(),
                                   child:
                                   new TextField(
                                     controller:  _accountController,
                                     decoration: InputDecoration(
                                       border: InputBorder.none,
                                       icon: Icon(Icons.account_circle),
                                       hintText: '请输入你的用户名',
                                     ),
                                   )
                               ),
                             ),
                           ),
                           new Container(
                               width:MediaQuery.of(context).size.width * 0.9,
                               decoration:Input.instance.getBoxDecoration(),
                               margin: EdgeInsets.only(top:20),
                               child:new Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   new Container(
                                     width:MediaQuery.of(context).size.width * 0.8,
                                     padding:EdgeInsets.fromLTRB(10,0,10,0),
                                     child:new TextField(
                                       controller:  _lockController,
                                       decoration: InputDecoration(
                                         border: InputBorder.none,
                                         icon: Icon(Icons.lock),
                                         hintText: '请输入你的密码',
                                       ),
                                       obscureText: _lockInvisible,
                                     ),
                                   ),
                                   new Container(
                                       width:MediaQuery.of(context).size.width * 0.1,
                                       child: GestureDetector(
                                         child: new Icon(
                                           Icons.remove_red_eye,
                                           color: Config.THEME.primaryColor,
                                         ),
                                         onTapDown:(_){
                                           setState(() {
                                             _lockInvisible = false;
                                           });
                                         },
                                         onTapUp:(_){
                                           setState(() {
                                             _lockInvisible = true;
                                           });
                                         },
                                       )
                                   ),
                                 ],
                               )
                           ),
                           new Container(
                             margin: EdgeInsets.only(top: 60),
                             width: MediaQuery.of(context).size.width * 0.9,
                             child:
                             new Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 new RaisedButton(
                                   child: new Text("注册"),
                                   color: Config.THEME.primaryColor,
                                   textColor:Colors.white,
                                   onPressed:(){
                                     EasyLoading.show(status: "register");
                                     HttpRequest().request(Config.DOMAIN+"/register",
                                         method: HttpRequestMethod.POST,
                                         params: {"account":_accountController.text,"password":_lockController.text},
                                         success: (res){
                                           Map<String,dynamic> result = jsonDecode(jsonEncode(res.data));
                                           if(result["code"]!=1){
                                             EasyLoading.showError(result["message"]);
                                           }else{
                                              //缓存
                                             User user = new User.all(result["data"]["id"],result["data"]["name"],result["data"]["portrait"]);
                                             AppData.user = user;
                                             user.putStorage();
                                             EasyLoading.showSuccess("注册成功");
                                             //跳转
                                             Navigator.of(context).pushReplacementNamed('bottom_tab');
                                           }
                                         },error: (errorinfo){
                                           EasyLoading.showError(errorinfo,duration: new Duration(seconds: 4));
                                         }
                                     );
                                   },//必须要有这个 不然其他属性无效果
                                 ),
                                 new RaisedButton(
                                   child: new Text("登录"),
                                   color: Config.THEME.primaryColor,
                                   textColor:Colors.white,
                                   onPressed:(){
                                     //进行登录注册然后路由去首页
                                        EasyLoading.show(status: "login");
                                        HttpRequest().request(Config.DOMAIN+"/login",
                                            method: HttpRequestMethod.POST,
                                            params:{"account":_accountController.text,"password":_lockController.text},
                                            success: (res){
                                              Map<String,dynamic> result = jsonDecode(jsonEncode(res.data));
                                                if(result["code"]!=1){
                                                  EasyLoading.showError(result["message"],duration: new Duration(seconds:2));
                                                }else{
                                                  //缓存
                                                  User user = new User.all(result["data"]["id"],result["data"]["name"],result["data"]["portrait"]);
                                                  AppData.user = user;
                                                  user.putStorage();

                                                  EasyLoading.showSuccess("登录成功",duration: new Duration(seconds:2));

                                                  Navigator.of(context).pushReplacementNamed('bottom_tab');
                                                }
                                            },error: (errorinfo){
                                                EasyLoading.showError(errorinfo,duration: new Duration(seconds: 4));
                                            }

                                        );
                                   },//必须要有这个 不然其他属性无效果
                                 ),
                               ],
                             ),
                           )
                         ],
                       ),
                     ],
                   ),
                   new Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       new Container(
                           width: MediaQuery.of(context).size.width * 0.9,
                           margin: EdgeInsets.only(top: 80,bottom: 10),
                           child: new Column(
                               children:[
                                 new Container(
                                   child:new Text("【群聊】属于匿名聊天软件", style: new TextStyle(color:Config.THEME.primaryColor),),
                                 ),
                                 new Container(
                                   margin: EdgeInsets.only(top: 20),
                                   child:new Text(
                                       "不需要用户任何授权，账号密码丢失不可找回",
                                     style: new TextStyle(color:Config.THEME.primaryColor),
                                   ),
                                 ),
                                 new Container(
                                   margin: EdgeInsets.only(top: 20),
                                   child:new Text(
                                     "@author TangZhangss 2020-2021 to write",
                                     style: new TextStyle(color:Config.THEME.primaryColor),
                                   ),
                                 )
                               ]
                           )
                       )
                     ],
                   ),
                 ],
               )
           ),
        )
    );
  }
}