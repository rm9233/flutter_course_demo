import 'package:app/ui/widget/notify_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
class NotifyPage extends StatefulWidget {
  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "消息中心",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: Color(0xfff5f6f7),
          child: ListView(
            children: <Widget>[
              NotifyItem()
            ],
          ),
        ));
  }
}
