import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/util/layout_util.dart';

/**
 * 加一下 发送的时间
 * */


class NotifyItem extends StatefulWidget {
  @override
  _NotifyItemState createState() => _NotifyItemState();
}

class _NotifyItemState extends State<NotifyItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(LayoutUtil.auto(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: LayoutUtil.auto(90),
            height: LayoutUtil.auto(90),
            decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.all(
                    Radius.circular(LayoutUtil.auto(45)))),
          ),
          SizedBox(width: LayoutUtil.auto(20),),

          Container(
            width: LayoutUtil.auto(550),
            padding: EdgeInsets.all(LayoutUtil.auto(25)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(LayoutUtil.auto(20)),
                    bottomLeft: Radius.circular(LayoutUtil.auto(20)),
                    bottomRight: Radius.circular(LayoutUtil.auto(20)),
                )
            ),
            child: Text("测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容,测试文字内容",maxLines: 100,),
          )

        ],
      ),
    );
  }
}
