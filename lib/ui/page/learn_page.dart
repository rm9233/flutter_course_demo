import 'dart:async';

import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/course_entity.dart';
import 'package:app/entity/format_course_entity.dart';
import 'package:app/ui/widget/course_item.dart';
import 'package:app/ui/widget/course_time_item.dart';
import 'package:app/ui/widget/empty_view.dart';
import 'package:app/util/event_bus.dart';
import 'package:app/util/sp_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int currentPage = 0;
  List<CourseEntity> ces = [];
  bool loading = false;

  var category = [
    {"title": "我的课程", "index": 0, "category": 99, "list": null},
    {"title": "美术", "index": 1, "category": 0, "list": null},
    {"title": "乐高", "index": 2, "category": 1, "list": null}
  ];

  @override
  void initState() {
    super.initState();
    this.onLoad();
    this.onListener();
  }


  showLoading(){
    setState(() {
      loading = true;
    });
  }

  hideLoading(){
    Timer(Duration(milliseconds: 200),(){
      if(mounted){
        setState(() {
          loading = false;
        });
      }
    });
  }

  onListener() {
    eventBus.on("refresh", (res) {
      onLoad();
    });
  }

  List<FormatCourseEntity> formatData(List<CourseEntity> cs, int category) {
    var startAt = "";
    List<FormatCourseEntity> list = [];
    for (int c = 0; c < cs.length; c++) {
      if (category == 99) {
        if (startAt != cs[c].startAt) {
          list.add(
              new FormatCourseEntity(data: null, type: 1, time: cs[c].startAt));
        }
        list.add(
            new FormatCourseEntity(data: cs[c], type: 2, time: cs[c].startAt));
        startAt = cs[c].startAt;
      } else {
        if (cs[c].category == category) {
          if (startAt != cs[c].startAt) {
            list.add(new FormatCourseEntity(
                data: null, type: 1, time: cs[c].startAt));
          }
          list.add(new FormatCourseEntity(
              data: cs[c], type: 2, time: cs[c].startAt));
          startAt = cs[c].startAt;
        }
      }
    }
    return list;
  }

  onLoad() {

    if (SpUtil.getString("token", defValue: "") == "") {
      return;
    }
    showLoading();

    Repository().courseList().then((value) {
      hideLoading();
      if (value["code"] == Code.SUCCESS) {
        List<CourseEntity> cs = [];

        List data = value["data"];
        for (int i = 0; i < data.length; i++) {
          cs.add(CourseEntity.fromJson(data[i]));
        }

        //课程分类
        List list = formatData(cs, 99);
        List drawList = formatData(cs, 0);
        List brickList = formatData(cs, 1);

        if (mounted) {
          setState(() {
            category[0]['list'] = list;
            category[1]['list'] = drawList;
            category[2]['list'] = brickList;
          });
        }
      } else {
        ToastUtil.show(value["message"]);
      }
    }).catchError((err) {
      hideLoading();
      ToastUtil.show(err.toString());
    });
  }

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  List<Widget> buildList(List<FormatCourseEntity> data) {
    List<Widget> list = [];

    for (int i = 0; i < data.length; i++) {
      if (data[i].type == 1) {
        list.add(CourseTimeItem(
          time: data[i].time,
        ));
      } else {
        list.add(CourseItem(ce: data[i].data));
      }
    }
    if (list.length == 0) {
      list.add(EmptyView());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("./assets/image/learn-bg.jpg"),fit: BoxFit.cover)
      ),
      child: ModalProgressHUD(
          inAsyncCall: loading,
          color: Colors.black,
          progressIndicator:
              SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil().screenWidth,
                height: LayoutUtil.auto(188),
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: LayoutUtil.auto(60),
                  padding: EdgeInsets.only(left: LayoutUtil.auto(30)),
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: LayoutUtil.auto(60),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                            Text(
                              "我的课程",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: LayoutUtil.setSp(
                                      currentPage == 0 ? 48 : 36),
                                  fontWeight: currentPage == 1
                                      ? FontWeight.w600
                                      : FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: LayoutUtil.auto(40),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: LayoutUtil.auto(60),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                  "./assets/image/picture-filling.png"),
                              width:
                                  LayoutUtil.auto(currentPage == 1 ? 50 : 38),
                            ),
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                            Text(
                              "美术",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: LayoutUtil.setSp(
                                      currentPage == 1 ? 48 : 36),
                                  fontWeight: currentPage == 1
                                      ? FontWeight.w600
                                      : FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: LayoutUtil.auto(40),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: LayoutUtil.auto(60),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                  "./assets/image/work-filling.png"),
                              width:
                                  LayoutUtil.auto(currentPage == 2 ? 50 : 38),
                            ),
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                            Text(
                              "乐高",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: LayoutUtil.setSp(
                                      currentPage == 2 ? 48 : 36),
                                  fontWeight: currentPage == 2
                                      ? FontWeight.w600
                                      : FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight -
                      LayoutUtil.auto(188 + 88 + 88),
                  child: PageView(
                    onPageChanged: onPageChanged,
                    children: <Widget>[
                      Container(
                        child: SingleChildScrollView(
                          child: category[0]['list'] != null
                              ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: buildList(category[0]['list']),
                                  ),
                                )
                              : Container(
                                  child: EmptyView(),
                                ),
                        ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: category[0]['list'] != null
                              ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: buildList(category[1]['list']),
                                  ),
                                )
                              : Container(
                                  child: EmptyView(),
                                ),
                        ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: category[0]['list'] != null
                              ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: buildList(category[2]['list']),
                                  ),
                                )
                              : Container(
                                  child: EmptyView(),
                                ),
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
