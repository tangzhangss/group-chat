import 'package:flutter/material.dart';

class IndexView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return  new IndexViewState();
  }
}

class IndexViewState extends State<IndexView>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("群聊"),
        ),
        body: new Center(child:new Text("我是首页"))
    );
  }

}
