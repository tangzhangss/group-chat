import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SpUtil {

  static SpUtil instance = new SpUtil();

  SharedPreferences spf;

  bool checkInit(){
    if(spf==null){
      init();
      return true;
    }
    return false;
  }
  //初始化，必须要初始化
  Future<bool> init() async {
    spf = await SharedPreferences.getInstance();
    if(spf != null){
      print("SharedPreferences 初始化完成!");
      return true;
    }else{
      return false;
    }
  }
  Future<bool> putString(String key, String value){
    if (checkInit()) return null;
    return spf.setString(key, value);
  }
  String getString(String key){
    if (checkInit()) return null;
    return spf.getString(key);
  }

  Future<bool> removeKey(String key){
    if (checkInit()) return null;
    return spf.remove(key);
  }
}
