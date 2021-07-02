import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app/common/config.dart';
import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/splash_entity.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jaguar/http/common/mimetype.dart';
import 'package:jaguar/http/response/byte_response.dart';
import 'package:jaguar/serve/server.dart';
import 'package:app/util/layout_util.dart';

import '../../app/app_navigator.dart';

/**
 *  上面广告 + （倒计时 和 跳过）
 *  下面icon
 *  本地缓存数据 + 请求
 * */

/**
 * 和父控件高度一致 http://findsrc.com/flutter/detail/8763
 * 关于宽高 https://www.cnblogs.com/lxlx1798/articles/11279909.html
 * dart 基础操作符 https://www.jianshu.com/p/64a6ed7581aa
 * jsonencode jsondecode
 * dart 实体类的处理 https://blog.csdn.net/yuzhiqiang_1993/article/details/88533166?utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~first_rank_v2~rank_v28-1-88533166.nonecase&utm_term=flutter%20json%E8%BD%ACbean&spm=1000.2123.3001.4430
 * */
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer jump;
  SplashEntity splash;
  var server = null;
   int servePort;

  @override
  void initState() {
    super.initState();
    this.loadData();
    this._startServer();
    this._initDownloader();
    jump = Timer(Duration(seconds: 3), (){
      AppNavigator.gotoHomePage(context);
    });
  }

  _initDownloader() async{
    await FlutterDownloader.initialize();
  }


   _startServer() async {
     servePort = 8081;
     server = Jaguar(address: LOCAL, port: servePort);
     String localPath = await FileUtil.getLocalPath();
     server.get('*', (ctx) {
       String mimeType = "";
       if (!ctx.path.endsWith('/')) {
         if (ctx.pathSegments.isNotEmpty) {
           final String last = ctx.pathSegments.last;
           if (last.contains('.')) {
             mimeType = MimeTypes.fromFileExtension[last.split('.').last];
           }
         }
       } else {
         mimeType = "text/html";
       }

       //解压缩的路径要处理
        File file = new File(localPath + ctx.path);
        List<int> body = file.readAsBytesSync();
        ctx.response = ByteResponse(body, mimeType: mimeType);
     });
     await server.serve();
     server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
 }


  void loadData(){
    Repository().splash().then((res){
      if(res["code"] == Code.SUCCESS){
        SpUtil.putString("splash", jsonEncode(res["data"]));
      }
    });

    String jsonStr = SpUtil.getString("splash");
    if(jsonStr!=""){
      Map<String, dynamic> json = jsonDecode(jsonStr);
      setState(() {
        splash =  SplashEntity.fromJson(json);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context,designSize: Size(750, 1334));
    print(ScreenUtil().scaleHeight);
    return Material(
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().scaleHeight,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight * 0.8,
              child: InkWell(
                onTap: (){
                  if(splash!=null && splash.url!=""){
                    AppNavigator.gotoAdPage(context, splash);
                    jump.cancel();
                  }
                },
                child: splash?.images != null ? Image.network(splash?.images,fit: BoxFit.cover) : Container(),
              ),
            ),
            Positioned(
              right: LayoutUtil.auto(40),
              top: LayoutUtil.auto(100),
              child: splash?.images != null ? Container(
                width: LayoutUtil.auto(120),
                height: LayoutUtil.auto(60),
                child: RaisedButton(
                  onPressed: (){
                    AppNavigator.gotoHomePage(context);
                    jump.cancel();
                  },
                  color: Color(0xff3f3f3f),
                  elevation: 1,
                  child: Text("跳过",style: TextStyle(color: Colors.white,fontSize: LayoutUtil.setSp(24)),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ) : Container() ,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight * 0.2,
                child: Center(
                  child: Container(
                    width: LayoutUtil.auto(300),
                    child: Image.asset("./assets/image/logo.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }


}
