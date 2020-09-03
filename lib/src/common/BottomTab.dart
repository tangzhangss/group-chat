import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groupchat/src/Config.dart';
import 'package:groupchat/src/view/Index.dart';
import 'package:groupchat/src/view/Login.dart';
import 'package:groupchat/src/view/Maillist.dart';
import 'package:groupchat/src/view/My.dart';

import 'Tool.dart';

class BottomTab extends StatefulWidget {
  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<BottomTab> {

  int _currentIndex=0;
  List _list=[
    IndexView(),
    MailListView(),
    MyView(),
  ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Config.initConfigEasyLoading(context); //交互组件

    if(!Tool.checkUserInfo()){
      return LoginView();
    }
    return Scaffold(
      body: this._list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (int index){
          setState(() {
            _currentIndex=index;
          });
        },
        iconSize:30,//icon大小
        fixedColor:Config.THEME.primaryColor,//选中颜色
        type: BottomNavigationBarType.fixed,//配置底部tabs可以有多个，不会被挤下去
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('主页')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              title: Text('通讯')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('我的')
          )
        ],
      ),
    );
  }
}