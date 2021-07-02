import 'package:app/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';
class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {

  /**
   * 选类型 可以传视频 图片等
   * */

  TextEditingController textEditer = TextEditingController();
  FocusNode _nodeText1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "问题反馈",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            color: Color(0xfffafafa),
            padding: EdgeInsets.all(LayoutUtil.auto(30)),
            child: Column(
              children: <Widget>[
                Container(
                  width: LayoutUtil.auto(690),
                  height: LayoutUtil.auto(400),
                  color: Colors.white,
                  child: TextField(
                    focusNode: _nodeText1,
                    controller: textEditer,
                    style: TextStyle(
                        fontSize: LayoutUtil.setSp(28),
                        color: Colors.grey),
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: '请尽量提供相关截图,以便小S能清楚的了解问题',
                      counterText: "",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all( LayoutUtil.auto(20)),
                    ),
                  ),
                ),
                SizedBox(height: LayoutUtil.auto(50),),
                Container(
                  width: LayoutUtil.auto(690),
                  height: LayoutUtil.auto(70),
                  child: FlatButton(
                    onPressed: () {
                      _nodeText1.unfocus();
                      ToastUtil.show("暂无此兑换码..");
                    },
                    color: Colors.lightGreen,
                    highlightColor: Colors.lightGreen,
                    splashColor:Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            LayoutUtil.auto(10))),
                    child: Text(
                      "提交",
                      style: TextStyle(color: Colors.white,fontSize: LayoutUtil.setSp(32)),
                    ),
                  ),
                )
              ],
            )
        ));
  }
}
