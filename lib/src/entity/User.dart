import 'dart:convert';
import 'package:groupchat/src/util/sp_util.dart';

class User{
   int id;//id
   String name;//用户名
   String portrait;//头像

   User(){
     //----
   }
   User.all(int id,String name,String portrait){
     this.id = id;
     this.name = name;
     this.portrait = portrait;
   }

   int getId(){
     return id;
   }

   /// jsonDecode(jsonStr)方法返回的是Map<String, dynamic>类型，需要这里将map转换成实体类
   User fromMap(Map<String, dynamic> map) {
     User user = new User.all(map['id'],map["name"],map["portrait"]);
     return user;
   }
   /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
   Map toJson() {
     Map map = new Map();
     map["id"] = this.id;
     map["name"] = this.name;
     map["portrait"] = this.portrait;
     return map;
   }
   User getUserByJsonString(String  str){
     return this.fromMap(jsonDecode(str));
   }
   Future<bool> putStorage(){
     String jsonStr = jsonEncode(this);
//     print("user转json:"+jsonStr);
     return SpUtil.instance.putString("user", jsonStr);
   }
}