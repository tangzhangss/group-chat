import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:groupchat/src/Config.dart';
import 'package:groupchat/src/common/PhoteViewSimpleScreen.dart';
import 'package:photo_view/photo_view.dart';

class IndexView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return  new IndexViewState();
  }
}

class IndexViewState extends State<IndexView>{
  List _leimuImages = ["images/leimu/1.jpg",
        "images/leimu/2.jpg",
        "images/leimu/3.jpg",
        "images/leimu/4.jpg",
        "images/leimu/5.jpg",
        "images/leimu/6.jpg",
         "images/leimu/7.jpg",
        "images/leimu/8.jpg",
        "images/leimu/9.jpg",
        "images/leimu/10.jpg",
        "images/leimu/11.jpg",
        "images/leimu/12.jpg",
  ];
  List _girlImages = ["images/girl/1.jpg",
    "images/girl/2.jpg",
    "images/girl/3.jpg",
    "images/girl/4.jpg",
    "images/girl/5.jpg",
    "images/girl/6.jpg",
    "images/girl/7.jpg",
    "images/girl/8.jpg",
    "images/girl/9.jpg",
    "images/girl/10.jpg",
    "images/girl/11.jpg",
    "images/girl/12.jpg",
  ];
  List _jiaoxiaoImages = ["images/jiaoxiao/1.png",
  "images/jiaoxiao/2.png",
  "images/jiaoxiao/3.png",
  "images/jiaoxiao/4.jpg",
  "images/jiaoxiao/5.jpg",
  "images/jiaoxiao/6.jpg",
  "images/jiaoxiao/7.jpg",
  "images/jiaoxiao/8.jpg",
  "images/jiaoxiao/9.jpg",
  "images/jiaoxiao/10.png",
  "images/jiaoxiao/11.jpg",
  "images/jiaoxiao/12.jpg",
  ];

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.asset(
      _leimuImages[index],
      fit: BoxFit.cover,
    ));
  }

  Widget _swiperBuilder2(BuildContext context, int index) {
    return (Image.asset(
      _girlImages[index],
      fit: BoxFit.cover,
    ));
  }
  Widget _swiperBuilder3(BuildContext context, int index) {
    return (Image.asset(
      _jiaoxiaoImages[index],
      fit: BoxFit.cover,
    ));
  }

  Swiper _swiper(bulider,images){
    return Swiper(
      itemBuilder: bulider,
      itemCount: images.length,
      control: new SwiperControl(),
      scrollDirection: Axis.horizontal,
      autoplay: true,
      onTap: (index){
        Navigator.of(context).push(MaterialPageRoute(builder:(context){
          return PhotoViewSimpleScreen(
            imageProvider:AssetImage(images[index]),
            heroTag: 'simple',
          );
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("群聊"),
        ),
        body: SingleChildScrollView(child: new Container(
          color: Config.THEME.primaryColorLight,
          width: MediaQuery.of(context).size.width,
          child: new Column(
            children: [
              new Container(
                    width: MediaQuery.of(context).size.width,
                    height:MediaQuery.of(context).size.height,
                    child: _swiper(_swiperBuilder,_leimuImages)
               ),
              new Container(
                  margin: EdgeInsets.only(top: 1),
                  width: MediaQuery.of(context).size.width,
                  height:MediaQuery.of(context).size.height,
                  child: _swiper(_swiperBuilder2,_girlImages)
              ),
              new Container(
                  margin: EdgeInsets.only(top: 1),
                  width: MediaQuery.of(context).size.width,
                  height:MediaQuery.of(context).size.height,
                  child: _swiper(_swiperBuilder3,_jiaoxiaoImages)
              ),
            ],
          ),
        )
       )
    );
  }

}
