import 'dart:async';
import 'dart:math';

import 'package:app/app/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/util/layout_util.dart';
//import 'package:vibration/vibration.dart';



/**
 * 其他dialog的实现方式
 * https://www.geek-share.com/detail/2758546567.html
 *
 * 动效
 * https://blog.csdn.net/mqdxiaoxiao/article/details/102934917
 *
 * 震动库
 * https://pub.dev/packages/vibration
 * */

class VerifyDialog extends StatefulWidget {

  Function cb;

  VerifyDialog(this.cb);

  @override
  _VerifyDialogState createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<VerifyDialog> with SingleTickerProviderStateMixin {

  List<String> item = ["壹","贰","叁","肆","伍","陆","柒","捌","玖"];
  List<String> choice = [];
  List<String> show = [];
  String answer = "";
  String myAnswer = "";

  AnimationController controller;
  Animation<double> tween;

  int anmiTimes = 0;

  @override
  void initState() {
    super.initState();
    show = [];
    int f = Random().nextInt(9);
    int s = Random().nextInt(9);
    int t = Random().nextInt(9);
    show.add(item[f]);
    show.add(item[s]);
    show.add(item[t]);
    answer = f.toString()+s.toString()+t.toString();

    controller = AnimationController(////创建 Animation对象
        duration: const Duration(milliseconds: 100), //时长
        vsync: this);

    tween = Tween(begin: -10.0, end: 10.0).animate(controller);
    controller.addStatusListener((status) { 
      if(status == AnimationStatus.completed){
        controller.reverse();
      }
    });



  }


  @override
  void dispose() {
    super.dispose();
    if(controller!=null){
      controller.stop();
      controller.dispose();
    }
  }

  Widget buildBlock(String title,int index,Function call){
    return Container(
      width: LayoutUtil.auto(120),
      height: LayoutUtil.auto(100),
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: LayoutUtil.setSp(56)),
        ),
        color: Colors.lightGreen,
        onPressed: () {
          call(title,index);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  void onItemClick(title,index){
      setState((){
        this.choice.add(title);
        this.myAnswer += index.toString();
        if(this.choice.length == 3){
          Timer(Duration(milliseconds: 200), (){
            if(this.answer == this.myAnswer){
              widget.cb();
            }else{
              setState((){
                this.myAnswer = "";
                this.choice = [];
              });
              controller.forward(from: 0);
              onVibrate();
            }
          });
        }
      });
  }

  void onVibrate() async{
//    if (await Vibration.hasVibrator()) {
//      Vibration.vibrate();
//    }
  }

  Widget _buildAnimWidget(BuildContext context, Widget child) {
    return  Scaffold(
      //创建透明层
        backgroundColor: Color(0x3d000000),
        body: StatefulBuilder(builder: (context, StateSetter setState) {
          return Center(
            child: Container(
              width: LayoutUtil.auto(680),
              height: LayoutUtil.auto(1000),
              child: Column(
                children: <Widget>[
//                  Image.asset("./assets/image/verify-icon.png"),
                  Container(
                    width: LayoutUtil.auto(680),
                    height: LayoutUtil.auto(780),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: LayoutUtil.auto(50)),
                        Text(
                          "为了确保您是家长",
                          style: TextStyle(
                              fontSize: LayoutUtil.setSp(38),
                              color: Colors.grey),
                        ),
                        SizedBox(height: LayoutUtil.auto(10)),
                        Text(
                          "请按顺序输入以下数字",
                          style: TextStyle(
                              fontSize: LayoutUtil.setSp(38),
                              color: Colors.grey),
                        ),
                        SizedBox(height: LayoutUtil.auto(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              show[0],
                              style: TextStyle(
                                  fontSize: LayoutUtil.setSp(48),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: LayoutUtil.auto(50)),
                            Text(
                              show[1],
                              style: TextStyle(
                                  fontSize: LayoutUtil.setSp(48),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: LayoutUtil.auto(50)),
                            Text(
                              show[2],
                              style: TextStyle(
                                  fontSize: LayoutUtil.setSp(48),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(height: LayoutUtil.auto(32)),
                        Container(
                          height: LayoutUtil.auto(42),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child:  Container(
                                  alignment: Alignment.center,
                                  width: LayoutUtil.auto(680),
                                  height: LayoutUtil.auto(42),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: LayoutUtil.auto(32)),
                                          width: LayoutUtil.auto(32),
                                          child: this.choice.length >= 1 ? Text(this.choice[0],style: TextStyle(fontSize: LayoutUtil.setSp(42),color: Colors.lightGreen,fontWeight: FontWeight.w800),) : Image.asset(
                                              "./assets/image/verify-choice.png")),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: LayoutUtil.auto(32)),
                                          width: LayoutUtil.auto(32),
                                          child: this.choice.length >= 2 ?  Text(this.choice[1],style: TextStyle(fontSize: LayoutUtil.setSp(42),color: Colors.lightGreen,fontWeight: FontWeight.w800),) : Image.asset(
                                              "./assets/image/verify-choice.png")),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: LayoutUtil.auto(32)),
                                          width: LayoutUtil.auto(32),
                                          child: this.choice.length >= 3  ? Text(this.choice[2],style: TextStyle(fontSize: LayoutUtil.setSp(42),color: Colors.lightGreen,fontWeight: FontWeight.w800),) : Image.asset(
                                              "./assets/image/verify-choice.png")),
                                    ],
                                  ),
                                ),
                                left: controller.value == 0 || controller.value == 1 ? 0 : tween.value ,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: LayoutUtil.auto(30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                            buildBlock("1",0,this.onItemClick),
                            buildBlock("2",1,this.onItemClick),
                            buildBlock("3",2,this.onItemClick),
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: LayoutUtil.auto(30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                            buildBlock("4",3,this.onItemClick),
                            buildBlock("5",4,this.onItemClick),
                            buildBlock("6",5,this.onItemClick),
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: LayoutUtil.auto(30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                            buildBlock("7",6,this.onItemClick),
                            buildBlock("8",7,this.onItemClick),
                            buildBlock("9",8,this.onItemClick),
                            SizedBox(
                              width: LayoutUtil.auto(10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: LayoutUtil.auto(80)),
                  InkWell(
                      onTap: (){
                        AppNavigator.back(context);
                      },
                      child: Container(
                        width: LayoutUtil.auto(80),
                        child: Image.asset("./assets/image/verify-close.png"),
                      ))
                ],
              ),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller,builder: _buildAnimWidget);
  }

}


