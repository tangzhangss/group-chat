import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupchat/src/common/Tool.dart';
import 'package:groupchat/src/view/Chat.dart';

class HttpRequest {

  static final Dio dio = Dio();

  static final HttpRequest _httpRequest = HttpRequest._internal();

  HttpRequest._internal(){
      //...
  }

  factory HttpRequest(){
    return _httpRequest;
  }

  request(String url, {
    String method = HttpRequestMethod.GET,
    Map<String, dynamic> params,
    Function success,
    Function error
  }) async {
    // 1.创建单独配置
    final options = Options(method: method);
    // 2.发送网络请求
    try {
      Response response = await dio.request(url, queryParameters: params, options: options);
      success(response);
    } on DioError catch(e){
      error(e.message);
    }
  }

  request_1(BuildContext context,String url,{
    String method = HttpRequestMethod.GET,
    Map<String, dynamic> params,
    Function success,
    Function error,
  }) async {
    // 1.创建单独配置
    final options = Options(method: method);
    // 2.发送网络请求
    try {
      Response response = await dio.request(url, queryParameters: params, options: options);
      Map<String,dynamic> result = jsonDecode(jsonEncode(response.data));

      if(result["code"]!=1){
         //自定义弹出提示框
        Tool.showTipsDialog(context,result["message"]);
      }else{
        success(result);
      }
    } on DioError catch(e){
      Tool.showTipsDialog(context,e.message);
    }
  }
}
class HttpRequestMethod{
  static const String POST = "post";
  static const String GET = "get";
}
