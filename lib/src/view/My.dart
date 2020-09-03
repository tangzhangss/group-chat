import 'package:flutter/material.dart';

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
        ),
        body: new Center(child:new Text("我是个人中心"))
    );
  }

}
