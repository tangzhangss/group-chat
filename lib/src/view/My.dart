import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/src/common/AppData.dart';
import 'package:groupchat/src/common/Tool.dart';
import 'package:groupchat/src/util/sp_util.dart';

import '../Config.dart';

class MyView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return  new MyViewState();
  }
}

class MyViewState extends State<MyView>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("个人中心"),
          actions: [
            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){
                 //注销
                 //1.清空缓存
                 //2.清空appdata
                 //跳转首页
                 SpUtil.instance.removeKey("user");
                 AppData.user=null;
                 Config.showToast("注销成功");
                 Navigator.of(context).pushReplacementNamed('bottom_tab');
            }),
          ],
        ),
        body:new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     ClipOval(child:
                       new CachedNetworkImage(
                         width: 100,
                         height: 100,
                         imageUrl: AppData.user.portrait,
                   )),
                    new Text(AppData.user.name,style: TextStyle(fontSize: 20,color: Colors.white),)
                   ],
                ),
                color: Config.THEME.primaryColor,
                width: MediaQuery.of(context).size.width,
                height:200,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration:  new BoxDecoration(
                    border: new Border(bottom: BorderSide(width: 1.0,color: Config.THEME.primaryColorLight)),
                ),
                child: new Text("点击右上角注销",style: TextStyle(fontSize: 18,color: Config.THEME.primaryColor),),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration:  new BoxDecoration(
                  border: new Border(bottom: BorderSide(width: 1.0,color: Config.THEME.primaryColorLight)),
                ),
                child: new Text("下列功能有空在做",style: TextStyle(fontSize: 18,color: Config.THEME.primaryColor),),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration:  new BoxDecoration(
                  border: new Border(bottom: BorderSide(width: 1.0,color: Config.THEME.primaryColorLight)),
                ),
                child: new Text("修改信息，创建群聊，群聊朋友圈",style: TextStyle(fontSize: 18,color: Config.THEME.primaryColor),),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration:  new BoxDecoration(
                  border: new Border(bottom: BorderSide(width: 1.0,color: Config.THEME.primaryColorLight)),
                ),
                child: new Text("公众号:TangZhangss",style: TextStyle(fontSize: 18,color: Config.THEME.primaryColor),),
              )
            ],
          ),
        )
    );
  }

}
