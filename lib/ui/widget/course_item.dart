import 'dart:math';

import 'package:app/app/app_navigator.dart';
import 'package:app/entity/course_entity.dart';
import 'package:app/entity/script_entity.dart';
import 'package:app/entity/unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/util/layout_util.dart';

class CourseItem extends StatefulWidget {

  final CourseEntity ce;

  const CourseItem({Key key, this.ce}) : super(key: key);
  @override
  _CourseItemState createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {

  Widget buildWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: LayoutUtil.auto(30)),
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: LayoutUtil.auto(280),
          margin: EdgeInsets.only(
              top: LayoutUtil.auto(0), bottom: LayoutUtil.auto(20)),
          padding: EdgeInsets.all(LayoutUtil.auto(20)),
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(LayoutUtil.auto(20))),
              color: Colors.white),
          child: Row(
            children: <Widget>[
              Container(
                width: LayoutUtil.auto(200),
                height: LayoutUtil.auto(240),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: LayoutUtil.auto(200),
                      height: LayoutUtil.auto(240),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.circular(
                                  LayoutUtil.auto(20))),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.ce.avator),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: LayoutUtil.auto(60),
                        height: LayoutUtil.auto(60),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(LayoutUtil.auto(20)))
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: LayoutUtil.auto(5),
                      left: LayoutUtil.auto(5),
                      child: Container(
                        width: LayoutUtil.auto(40),
                        height: LayoutUtil.auto(40),
                        child: Image.asset("./assets/image/picture-filling-icon.png"),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: LayoutUtil.auto(35),),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: LayoutUtil.auto(25),),
                  Text(widget.ce.remark,style: TextStyle(color:Color(0xff999999))),
                  SizedBox(height: LayoutUtil.auto(20),),
                  Text(widget.ce.title,style: TextStyle(fontSize:LayoutUtil.setSp(36)),),
                  SizedBox(height: LayoutUtil.auto(20),),
                  Row(
                    children: <Widget>[
                      Container(child: Image.asset("./assets/image/star-filling.png"),width: LayoutUtil.auto(42),),
                      Container(child: Image.asset("./assets/image/star-filling.png"),width: LayoutUtil.auto(42),),
                      Container(child: Image.asset("./assets/image/star-defalut-filling.png"),width: LayoutUtil.auto(42),),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        AppNavigator.gotoUnitPage(context,widget.ce.videoId);
      },
      child:  buildWidget(),
    );
  }
}
