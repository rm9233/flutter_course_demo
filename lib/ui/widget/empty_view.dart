import 'package:app/util/event_bus.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class EmptyView extends StatefulWidget {
  @override
  _EmptyViewState createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      child: Column(
        children: <Widget>[
          SizedBox(height: LayoutUtil.auto(140),),
          Image.asset("./assets/image/none.png"),
          SizedBox(height: LayoutUtil.auto(20),),
          Text("您现在还没有课程哦!",style: TextStyle(color: Colors.white),),
          SizedBox(height: LayoutUtil.auto(80),),
          FlatButton(
            child: Text(
              "去选课",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            highlightColor: Colors.lightGreen,
            splashColor: Colors.transparent,
            onPressed: () {
              eventBus.emit("gotoHome","");
            },
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(LayoutUtil.auto(35))),
          )
        ],
      ),
    );
  }
}
