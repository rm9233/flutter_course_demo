import 'dart:io';

import 'package:app/entity/script_entity.dart';
import 'package:app/entity/splash_entity.dart';
import 'package:app/entity/unit_entity.dart';
import 'package:app/ui/page/about_page.dart';
import 'package:app/ui/page/code_page.dart';
import 'package:app/ui/page/game_page.dart';
import 'package:app/ui/page/home_page.dart';
import 'package:app/ui/page/issue_page.dart';
import 'package:app/ui/page/notify_page.dart';
import 'package:app/ui/page/order_page.dart';
import 'package:app/ui/page/player_page.dart';
import 'package:app/ui/page/unit_page.dart';
import 'package:app/ui/page/userinfo_page.dart';
import 'package:app/ui/widget/permission_dialog.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ui/page/webview_page.dart';

//设置用户信息页面
//消息通知 购课 上课
//问题反馈


//设置
  //清楚缓存
  //上传日志
  //给我们评价
  //退出登录


//课程 展示拥有的课程

//课程详情

//上课页 视频 + 游戏


//营销内容 展示列表，购买
//banner
//h5购买页

// 分享
// 推送

class AppNavigator{
  static back(BuildContext context){
    Navigator.pop(context);
  }

  static gotoHomePage(BuildContext context){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }), (route) => false);
  }

  static gotoWebViewPage(BuildContext context,String title,String url){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebViewPage(url: url,title: title,history: false,);
    }));
  }

  static gotoAdPage(BuildContext context,SplashEntity entity){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return WebViewPage(url: entity.url,title: entity.title,history: true,);
    }), (route) => false);
  }

  static gotoCodePage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CodePage();
    }));
  }

  static gotoOrderPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderPage();
    }));
  }

  static gotoUnitPage(BuildContext context,int videoId){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UnitPage(videoId: videoId,);
    }));
  }




  static gotoNotifyPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotifyPage();
    }));
  }

  static gotoAboutPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AboutPage();
    }));
  }

  static gotoIssuePage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return IssuePage();
    }));
  }


  static gotoGamePage(BuildContext context,UnitEntity ue) async{
    PermissionStatus camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus photos = await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    PermissionStatus microphone = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    PermissionStatus storage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if(camera == PermissionStatus.granted && photos == PermissionStatus.granted && microphone == PermissionStatus.granted){

      if(Platform.isIOS){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GamePage(ue: ue,);
        }));
      }else{
        if(storage == PermissionStatus.granted){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GamePage(ue: ue,);
          }));
        }else{
          var data = {};
          data["ue"] = ue;
          showCupertinoDialog(context: context, builder: (context){
            return PermissionDialog(data:data,cb:(data){
              AppNavigator.gotoGamePage(context,data["ue"]);
            });
          });
        }
      }

    }else{
      var data = {};
      data["ue"] = ue;
      showCupertinoDialog(context: context, builder: (context){
        return PermissionDialog(data:data,cb:(data){
          AppNavigator.gotoGamePage(context,data["ue"]);
        });
      });
    }

  }

  static gotoPlayerPage(BuildContext context,UnitEntity ue,bool hasRemove) async {

    PermissionStatus camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus photos = await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    PermissionStatus storage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if(camera == PermissionStatus.granted && photos == PermissionStatus.granted ){

      if(Platform.isIOS){
        if(hasRemove){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PlayerPage(ue: ue,);
          }));

        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return PlayerPage(ue: ue,);
          }));
        }

      }else{
        if(storage == PermissionStatus.granted){
          if(hasRemove){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlayerPage(ue: ue,);
            }));

          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return PlayerPage(ue: ue,);
            }));
          }
        }else{
          var data = {};
          data["ue"] = ue;
          showCupertinoDialog(context: context, builder: (context){
            return PermissionDialog(data:data,cb:(data){
              AppNavigator.gotoPlayerPage(context,data["ue"],hasRemove);
            });
          });
        }
      }

    }else{
      if(Platform.isIOS){
        ToastUtil.show("该操作需要访问您的相机或相册,授权后再进行操作..");
        PermissionHandler().requestPermissions(<PermissionGroup>[
          PermissionGroup.camera,
          PermissionGroup.photos,
        ]).then((onValue) {});
        return;
      }
      var data = {};
      data["ue"] = ue;
      showCupertinoDialog(context: context, builder: (context){
        return PermissionDialog(data:data,cb:(data){
          AppNavigator.gotoPlayerPage(context,data["ue"],hasRemove);
        });
      });
    }
  }



  static gotoUserInfoPage(BuildContext context) async {

    PermissionStatus camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus photos = await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    PermissionStatus microphone = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    PermissionStatus storage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if(camera == PermissionStatus.granted && photos == PermissionStatus.granted && microphone == PermissionStatus.granted){

      if(Platform.isIOS){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UserInfoPage();
        }));
      }else{
        if(storage == PermissionStatus.granted){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserInfoPage();
          }));
        }else{
          showCupertinoDialog(context: context, builder: (context){
            var data = {};
            return PermissionDialog(data:data,cb:(data){
              AppNavigator.gotoUserInfoPage(context);
            });
          });
        }
      }

    }else{
      var data = {};
      showCupertinoDialog(context: context, builder: (context){
        return PermissionDialog(data:data,cb:(data){
          AppNavigator.gotoUserInfoPage(context);
        });
      });
    }
  }



}