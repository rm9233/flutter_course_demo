import 'package:app/util/layout_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "关于我们",
            style: TextStyle(color: Colors.black87),
          ),

        ),
        body: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: Color(0xfffafafa),
          child: ListView(
            children: <Widget>[
              SizedBox(height: LayoutUtil.auto(300)),
              Container(
                width: LayoutUtil.auto(555 / 1.5),
                height: LayoutUtil.auto(123 / 1.5),
                child: Image.asset("./assets/image/logo.png"),
              ),
              SizedBox(height: LayoutUtil.auto(20)),
              Container(
                alignment: Alignment.center,
                child: Text("版本 V 1.0.0",style: TextStyle(color: Color(0xff999999))),
              ),
              SizedBox(height: LayoutUtil.auto(550)),
              Container(
                alignment: Alignment.center,
                child: Text("010 8038 7057",style: TextStyle(fontSize: LayoutUtil.setSp(42),color: Colors.lightGreen),),
              ),
              SizedBox(height: LayoutUtil.auto(20)),
              Container(
                alignment: Alignment.center,
                child: Text("工作时间 9:00 - 20:00",style: TextStyle(color: Color(0xff999999))),
              ),
            ],
          ),
        ));
  }
}
