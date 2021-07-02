import 'package:app/util/date_util.dart';
import 'package:app/util/layout_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseTimeItem extends StatefulWidget {
  final String time;

  const CourseTimeItem({Key key, this.time}) : super(key: key);
  @override
  _CourseTimeItemState createState() => _CourseTimeItemState();
}

class _CourseTimeItemState extends State<CourseTimeItem> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: LayoutUtil.setSp(30),horizontal: LayoutUtil.setSp(30)),
      child: Container(
        child: Text(DateUtil.formatted(widget.time, 'MM.dd')+" "+DateUtil.week(widget.time, 'EEEE'),style: TextStyle(color: Colors.white),),
        padding: EdgeInsets.symmetric(vertical: LayoutUtil.auto(10),horizontal: LayoutUtil.auto(20)),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topLeft:  Radius.circular(LayoutUtil.auto(20)), topRight:  Radius.circular(LayoutUtil.auto(20)),bottomRight:  Radius.circular(LayoutUtil.auto(20)))
        ),
      ),
    );
  }
}
