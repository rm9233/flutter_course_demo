import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LayoutUtil{

  static bool islarge = false;

  static void init() async{
    if(Platform.isIOS){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if(iosInfo.model.toLowerCase().indexOf("ipad")!=-1){
        LayoutUtil.islarge = true;
      }
    }
  }

  static double auto(num size){
    double scale =  islarge ? .75 : 1.0;
    if(ScreenUtil().screenWidth > ScreenUtil().screenHeight){
      return ScreenUtil().setHeight(size * scale);
    }else{
      return ScreenUtil().setWidth(size * scale);
    }

  }

  static double setSp(num size){
//    double scale =  islarge ? .7 : 1.0;
//    return ScreenUtil().setSp(size * scale);
    double scale =  islarge ? .7 : 1.0;
    if(ScreenUtil().screenWidth > ScreenUtil().screenHeight){
      return ScreenUtil().setHeight(size * scale);
    }else{
      return ScreenUtil().setWidth(size * scale);
    }
  }

}
