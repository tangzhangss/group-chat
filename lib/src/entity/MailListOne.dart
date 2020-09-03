class MailListOne{
  int _id;
  String _title;
  String _neticon;
  String _msg;
  String _msgtime;
  int _msgcount;
  String _brief;


  MailListOne(id,title,{neticon='https://my1admin.oss-cn-beijing.aliyuncs.com/tangzhangss/group_chat_logo.png',
    msg="暂无消息",
    msgtime="",
    msgcount=0,
    brief="",}){
    this._id = id;
    this._title=title;
    this._neticon=neticon;
    this._msg=msg;
    this._msgtime=msgtime;
    this._msgcount=msgcount;
    this._brief=brief;
  }

  MailListOne.chat(){
    //....
    this._title="";
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get msgcount => _msgcount;

  set msgcount(int value) {
    _msgcount = value;
  }

  String get msgtime => _msgtime;

  set msgtime(String value) {
    _msgtime = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get neticon => _neticon;

  set neticon(String value) {
    _neticon = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get brief => _brief;

  set brief(String value) {
    _brief = value;
  }

  @override
  String toString() {
    return 'MailListOne{_id: $_id, _title: $_title, _neticon: $_neticon, _msg: $_msg, _msgtime: $_msgtime, _msgcount: $_msgcount, _brief: $_brief}';
  }
}