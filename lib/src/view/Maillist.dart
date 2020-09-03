import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groupchat/src/Config.dart';
import 'package:groupchat/src/common/AppData.dart';
import 'package:groupchat/src/entity/MailListOne.dart';
import 'package:groupchat/src/util/http_request.dart';
import 'package:groupchat/src/view/Chat.dart';

class MailListView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return  new MailListViewState();
  }
}

class MailListViewState extends State<MailListView> {

  var _list = new List<MailListOne>();

  _getData({bool init=false}){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(init)EasyLoading.show(status: "loading");
      //获取list数据
      HttpRequest().request(Config.DOMAIN + "/get_group_list/"+AppData.user.id.toString(),
          method: HttpRequestMethod.GET,
          params: {},
          success: (res) {
            Map<String, dynamic> result = jsonDecode(jsonEncode(res.data));
            if (result["code"] != 1) {
              EasyLoading.showError(
                  result["message"], duration: new Duration(seconds: 2));
            } else {
              if(init)EasyLoading.dismiss();
              result["data"].forEach((item) {
                _list=[];//先清空
                _list.add(new MailListOne(
                    item["id"], item["name"], brief: item["brief"],
                    neticon: item["neticon"],msgtime: item["groupChatGroupMessage"]["friendlyTime"],msg: item["groupChatGroupMessage"]["sendText"].replaceAll("\n", " "),msgcount:item["userNoReadCount"]));
              });
              //更新全局属性
              AppData.groupList=_list;
              setState(() {
                _list=_list;
              });
            }
          }, error: (errorinfo) {
            if(init)EasyLoading.showError(
                errorinfo, duration: new Duration(seconds: 4));
          }
      );
    });
  }
  MailListViewState(){
    if(AppData.groupList == null){
      _getData(init: true);
    }else{
      _list = AppData.groupList;
      _getData();
    }
  }

  ListTile _listTitle(MailListOne one){
    return new ListTile(
        leading: new Container(
          width:42,
          height: 42,
          decoration:new BoxDecoration(
            borderRadius:BorderRadius.all(Radius.circular(5)),
          ),
          child:CachedNetworkImage(
              imageUrl: one.neticon,
              placeholder: (context, url) => Image.asset("images/logo.png"),
            )
        ),
        trailing:new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:[
            new Text(one.msgtime,style: TextStyle(color: Colors.grey)),
            new Text(one.msgcount==0?'':one.msgcount.toString(),style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold)),
          ],
        ),
        dense: true,
        contentPadding:EdgeInsets.all(10),
        title:new Text(one.title,style: new TextStyle(fontSize: 18),),
        subtitle:new Text(one.msg,maxLines: 1,),
        onTap:(){
          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new ChatView(one.id))).then((data){
            _getData();
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("通讯录"),
        ),
        body: new ListView.separated(
          itemCount: _list.length,
          separatorBuilder:(BuildContext context, int index){
            return new Divider(
                color:Config.THEME.primaryColorLight,
                height:1
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return _listTitle(_list[index]);
          },//,
        )
    );
  }
}


