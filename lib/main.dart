import 'package:app/data/api.dart';
import 'package:app/ui/page/splash_page.dart';
import 'package:app/util/dio_util.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/config.dart';

/**
 * 状态栏颜色问题 https://github.com/flutter/flutter/issues/50606
 * */
/**
 * app 三方
 * 推送/消息、三方分享
 *
 * 无网络、各种冷启动各种补充、适配工作
 *
 * h5
 * 支付、邀请、分享
 *
 * 后台接口和逻辑整合
 *
 * */

/**
 * 构思
 * 只做49元小课 买了就送礼包那种 + 20w公海用户 + 造课成本低
 * */
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await SpUtil.getInstance();
  LayoutUtil.init();
  runApp(MyApp());


  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.light) // Or Brightness.dark
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.indigo[800],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.light,
          textTheme: Typography.material2018().black.merge(Typography.englishLike2018),
          iconTheme: const IconThemeData(color: Colors.black87),
          actionsIconTheme: const IconThemeData(color: Colors.black87),
          elevation: 0,
        ),
      ),
      home: SplashPage(),
    );
  }
}
