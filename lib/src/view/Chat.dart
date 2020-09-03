import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupchat/src/Config.dart';
import 'package:groupchat/src/common/AppData.dart';
import 'package:groupchat/src/entity/MailListOne.dart';
import 'package:groupchat/src/util/http_request.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatView extends StatefulWidget{
  final int _groupId;
  ChatView(this._groupId);

  @override
  State<StatefulWidget> createState() {
    return  new ChatViewState();
  }
}

class ChatViewState extends State<ChatView>{

  String _online="0";
  var _list = [];
  //发送框
  TextEditingController _textController = TextEditingController();

  MailListOne _mailListOne = new MailListOne.chat();

  ScrollController _controller = ScrollController();

  WebSocketChannel  _channel;
  bool _websocketEnd = false;

  StreamController<String> _streamController =  StreamController<String>();

  ChatViewState(){
    _init();
  }
  void _init(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.show(status: "loading");
      //获取群信息
      HttpRequest().request(Config.DOMAIN + "/get_groupinfo/"+widget._groupId.toString(),
          method: HttpRequestMethod.GET,
          success: (res) {
            Map<String, dynamic> result = jsonDecode(jsonEncode(res.data));

            if (result["code"] != 1) {
              EasyLoading.showError(
                  result["message"], duration: new Duration(seconds: 2));
            } else {
              EasyLoading.dismiss();

              setState((){
                _mailListOne = new MailListOne(
                    result["data"]["id"],  result["data"]["name"], brief:  result["data"]["brief"],
                    neticon:  result["data"]["neticon"]);
              });
            }
          }, error: (errorinfo) {
            EasyLoading.showError(
                errorinfo, duration: new Duration(seconds: 4));
          }
      );

      _connect();
    });
  }

  _connect(){

    _channel = new IOWebSocketChannel.connect(Config.WEBSOCKETURL);

    var msg = "init-chatroom_"+AppData.user.id.toString()+"_"+widget._groupId.toString();

    _channel.sink.add(msg);

    _channel.stream.listen((message) {
      print("channel收到消息:"+message);
      if (message.startsWith("online@@")) {
        setState(() {
          _online = message.split("@@")[1];
        });
      } else if (false) {

      } else {
        //正常消息
        List<String> msg = message.split("|@|");
        setState(() {
          _list.add({"sendId":msg[0],"name":msg[1],"portrait":msg[2],"msgType":int.parse(msg[4]),"sendText":msg[5],"friendlyTime":"刚刚"});
        });

        _updateGroupLogReaded();

        //跳转到最底部
        new Timer(new Duration(milliseconds:200), (){
          _controller.jumpTo(_controller.position.maxScrollExtent);
        });
      }

    },onError: (error){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EasyLoading.showToast("聊天室连接失败",duration: Duration(seconds: 5));
      });
    },
        onDone: (){

          if(!_websocketEnd){
            print("channel被关闭尝试重新连接...");
            _connect();
          }
        }
    );
  }

  @override
  void initState() {
    //获取聊天信息列表
    HttpRequest().request_1(
        context,
        Config.DOMAIN+"/get_group_logs/"+widget._groupId.toString(),
        method: HttpRequestMethod.GET,
        success: (res){
          setState(() {
            _list=res["data"];
          });


          //更新已读聊天消息
          _updateGroupLogReaded();
        }
    );

    super.initState();
  }

  _updateGroupLogReaded(){
    HttpRequest().request_1(
        context,
        Config.DOMAIN+"/update_group_log_readed",
        params: {"groupId":widget._groupId,"userId":AppData.user.id,"count":_list.length},
        method: HttpRequestMethod.POST,
        success: (res){}
    );
  }
  /*
  必须再state中关闭连接
   */
  @override
  void dispose(){
    print("关闭websocket连接....");
    _websocketEnd=true;
    _channel.sink.close();//这里关闭会触发 done事件导致setState() called after dispose()错误,设置一个全局标签_websocketEnd
    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    //跳转到最底部
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      new Timer(new Duration(milliseconds:200), (){
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    });

    return new Scaffold(
              appBar: new AppBar(
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(_mailListOne.title),
                    new Text("${_online}人在线", style: TextStyle(fontSize: 14),)
                  ],
                ),
              ),
              body: new Stack(
                children: [
                  new ListView.builder(
                    controller: _controller,
                    padding: new EdgeInsets.fromLTRB(10,10,10,60),
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context,int index){
                      return new Column(
                        children: [
                          _list[index]['sendId']==AppData.user.id.toString()?_rightContainer(index):_leftContainer(index)
                        ],
                      );
                    },
                  ),
                  new Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child:
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          color: Config.THEME.primaryColorLight,
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: new TextField(
                            // maxLength:240,
                            maxLengthEnforced: true,
                            maxLines: 4,
                            minLines: 1,
                            controller:  _textController,
                            decoration: InputDecoration(
                              hintText: '请输入内容',
                              fillColor: Colors.white,
                              suffixIcon:new IconButton(
                                  icon: new Icon(Icons.send),
                                  onPressed: (){
                                    if(_textController.text == ''){
                                      return false;
                                    }
                                    var param={"sendId":AppData.user.id,"groupId":widget._groupId,"sendText":_textController.text,"msgType":1};

                                    var sendmsgstr=[param["sendId"],AppData.user.name,AppData.user.portrait,param["groupId"],param["msgType"],param["sendText"]];

                                    _channel.sink.add(sendmsgstr.join("|@|"));

                                    HttpRequest().request_1(
                                        context,
                                        Config.DOMAIN+"/send_group_msg",
                                        method: HttpRequestMethod.POST,
                                        params:param,
                                        success: (res){
                                          _textController.text = "";
                                          Config.showToast("发送成功^_^");
                                          //取消焦点
                                          FocusScope.of(context).requestFocus(FocusNode());
                                        }
                                    );

                                  }
                              )
                            ),
                          ),
                        ),
                    )
                ],
              ),
            );
  }

  _rightContainer(int index){
    var data = _list[index];
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  new Text(data['name']+"  ",style: TextStyle(color: Config.THEME.primaryColorDark),),
                  new Text(data['friendlyTime']+"  ",style: TextStyle(color:Colors.grey),)
                ],
              ),
              ClipOval(
                child:  CachedNetworkImage(
                  width: 40,
                  height: 40,
                  imageUrl: data["portrait"],
                ),
              ),
            ],
          ),
          data['msgType']==1?Container(
            margin: EdgeInsets.fromLTRB(5, 20, 45,20),
            child: new Text(data['sendText'], style: TextStyle(fontSize: 20),),
          ):Container(),
          index==_list.length-1?new Center(
            child: new Text("---人家也是有底线的---",style: TextStyle(fontSize: 12,color: Config.THEME.primaryColorLight),),
          ):new Text("")
        ],
      ),
    );
  }
  _leftContainer(int index) {
    var data = _list[index];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  width: 40,
                  height: 40,
                  imageUrl: data["portrait"],
                ),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text("  " + data['name'],
                    style: TextStyle(color: Config.THEME.primaryColorDark),),
                  new Text("  " + data['friendlyTime'],
                    style: TextStyle(color: Colors.grey),)
                ],
              )
            ],
          ),
          data['msgType']==1?Container(
            margin: EdgeInsets.fromLTRB(45, 20, 5, 20),
            child: new Text(data['sendText'], style: TextStyle(fontSize: 20),),
          ):Container(),
          index==_list.length-1?new Center(
            child: new Text("---人家也是有底线的---",style: TextStyle(fontSize: 12,color: Config.THEME.primaryColorLight)),
          ):new Text("")
        ],
      ),
    );
  }
}
