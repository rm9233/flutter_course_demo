import 'dart:convert';

import 'package:app/app/app_navigator.dart';
import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/user_entity.dart';
import 'package:app/ui/widget/login_dialog.dart';
import 'package:app/ui/widget/logout_dialog.dart';
import 'package:app/ui/widget/money_view.dart';
import 'package:app/ui/widget/setting_item.dart';
import 'package:app/ui/widget/verify_dialog.dart';
import 'package:app/util/date_util.dart';
import 'package:app/util/event_bus.dart';
import 'package:app/util/sp_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/util/layout_util.dart';

/**
 * 跳转的离奇bug
 * https://github.com/flutter/flutter/issues/36177
 * */
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  UserEntity userEntity;
  int systemTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().screenWidth,
          height: LayoutUtil.auto(1520),
          child: Stack(
            children: <Widget>[
              Container(
                width: ScreenUtil().screenWidth,
                height: LayoutUtil.auto(290),
                color: Colors.lightGreen,
              ),
              //绿条圆角
              Positioned(
                top: LayoutUtil.auto(270),
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: LayoutUtil.auto(100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(LayoutUtil.auto(30))),
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: LayoutUtil.auto(250),
                child: Column(
                  children: <Widget>[
                     Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: LayoutUtil.auto(30)),
                      width: ScreenUtil().screenWidth,
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                            width: LayoutUtil.auto(160),
                                            height: LayoutUtil.auto(160),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        LayoutUtil.auto(80)))),
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      LayoutUtil.auto(75))),
                                              child: Container(
                                                width: LayoutUtil.auto(150),
                                                height: LayoutUtil.auto(150),
                                                child: userEntity != null &&
                                                    userEntity.avator != "" && userEntity.avator != null
                                                    ? Image.network(userEntity.avator) : Image.asset(
                                                    "./assets/image/user-filling.jpg"),
                                              ),
                                            )),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: LayoutUtil.auto(50),
                                            height: LayoutUtil.auto(50),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        LayoutUtil.auto(25)))),
                                            child: Image.asset(
                                                "./assets/image/user-edit.png"),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: (){
                                      if(userEntity==null){
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) {
                                              return LoginDialog();
                                            });
                                      }else{
                                        AppNavigator.gotoUserInfoPage(context);
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: LayoutUtil.auto(40),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: LayoutUtil.auto(45),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            userEntity !=null && userEntity.nickName!=null ?  userEntity.nickName : "未登录",
                                            style: TextStyle(
                                                fontSize: LayoutUtil.setSp(32)),
                                          ),
                                          SizedBox(
                                            width: LayoutUtil.auto(20),
                                          ),
                                          userEntity !=null && userEntity.birthday!=null ? Text(
                                            DateUtil.formatBirthday(userEntity.birthday,systemTime),
                                            style: TextStyle(
                                                fontSize: LayoutUtil.setSp(24),
                                                color: Colors.grey),
                                          ) : Container(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: LayoutUtil.auto(20),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          MoneyView(
                                              num: 0,
                                              icon: Image.asset(
                                                  "./assets/image/user-money.png"),
                                              color: Color(0xfffceecb)),
                                          SizedBox(
                                            width: LayoutUtil.auto(20),
                                          ),
                                          MoneyView(
                                              num: 0,
                                              icon: Image.asset(
                                                  "./assets/image/user-diamond.png"),
                                              color: Color(0xfffceadc)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if(userEntity==null){
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return LoginDialog();
                                    });
                              }
                            },
                          ),
//                          SizedBox(
//                            height: LayoutUtil.auto(50),
//                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: LayoutUtil.auto(40),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().screenWidth,
                          child: Column(
                            children: <Widget>[
//                              SettingItem(
//                                icon:
//                                Image.asset("./assets/image/user-work.png"),
//                                title: "推荐好友得好礼",
//                                onTap: ()=>{
//                                  //AppNavigator.gotoCodePage(context)
//                                },
//                              ),
//                              SettingItem(
//                                icon:
//                                Image.asset("./assets/image/user-share.png"),
//                                title: "月月分享得金币",
//                                onTap: ()=>{
//                                  //AppNavigator.gotoCodePage(context)
//                                },
//                              ),
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/user-layers.png"),
                                title: "优惠券",
                                onTap: (){
                                  if(userEntity==null){
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return LoginDialog();
                                        });
                                  }else{
                                    AppNavigator.gotoCodePage(context);
                                  }
                                },
                              ),
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/user-file-common.png"),
                                title: "订单信息",
                                onTap: () {
                                  if(userEntity==null){
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return LoginDialog();
                                        });
                                  }else{
                                    AppNavigator.gotoOrderPage(context);
                                  }

                                },
                              ),

                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: LayoutUtil.auto(100)),
                            width: ScreenUtil().screenWidth,
                            height: LayoutUtil.auto(0.2),
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().screenWidth,
                          child: Column(
                            children: <Widget>[
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/notification.png"),
                                title: "消息通知",
                                onTap: () {
                                  if(userEntity==null){
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return LoginDialog();
                                        });
                                  }else{
                                    AppNavigator.gotoNotifyPage(context);
                                  }
                                },
                              ),
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/help.png"),
                                title: "问题反馈",
                                onTap: () {
                                  if(userEntity==null){
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return LoginDialog();
                                        });
                                  }else{
                                    AppNavigator.gotoIssuePage(context);
                                  }
                                },
                              ),
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/customer-service.png"),
                                title: "在线客服",
                                onTap: () {
                                  //call phone numer
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: LayoutUtil.auto(100)),
                            width: ScreenUtil().screenWidth,
                            height: LayoutUtil.auto(0.2),
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().screenWidth,
                          child: Column(
                            children: <Widget>[
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/ashbin.png"),
                                title: "清除缓存",
                                onTap: () {

                                },
                              ),
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/icon-caps-lock.png"),
                                title: "上传日志",
                                onTap: () {
                                  if(userEntity==null){
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return LoginDialog();
                                        });
                                  }else{
                                    //TODO 上传日志
                                  }
                                },
                              ),
                              SettingItem(
                                icon:
                                Image.asset("./assets/image/about.png"),
                                title: "关于我们",
                                onTap: () {
                                  AppNavigator.gotoAboutPage(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: LayoutUtil.auto(100)),
                            width: ScreenUtil().screenWidth,
                            height: LayoutUtil.auto(0.2),
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: LayoutUtil.auto(100),
                    ),
                    userEntity!=null ? Container(
                      width: LayoutUtil.auto(620),
                      height: LayoutUtil.auto(72),
                      child: FlatButton(
                        child: Text(
                          "退出登陆",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                        highlightColor: Colors.lightGreen,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          showCupertinoDialog(context: context, builder: (context) {
                            return LogoutDialog();
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(LayoutUtil.auto(35))),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    this.onLoad();
    this.onListener();
  }


  void onLoad(){
    String jsonStr = SpUtil.getString("user");
    String token = SpUtil.getString("token");
    if(jsonStr!=""){
      Map<String, dynamic> json = jsonDecode(jsonStr);
      if(mounted){
        setState(() {
          userEntity = UserEntity.fromJson(json);
        });
      }
    }else{
      if(mounted){
        setState(() {
          userEntity = null;
        });
      }

    }

    if(token!=""){
      Repository().userInfo().then((value){
        if(value["code"] == Code.SUCCESS){
          if(mounted){
            setState(() {
              userEntity = UserEntity.fromJson(value["data"]);
              systemTime = value["time"];
            });
          }

          SpUtil.putString("user", jsonEncode(value["data"]));
        }else{
          ToastUtil.show(value["message"]);
        }
      }).catchError((err){
        ToastUtil.show(err.toString());
      });
    }

  }

  void onListener(){
    eventBus.on("refresh",(res){
      onLoad();
    });
  }


}
