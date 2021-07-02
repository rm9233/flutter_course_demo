import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app/util/layout_util.dart';

import '../../app/app_navigator.dart';
class WebViewPage extends StatefulWidget {

  final String url;
  final String title;
  final bool history;

  const WebViewPage({Key key, this.url, this.title,this.history}) : super(key: key);


  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  bool isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    double location = 44;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        )
      ),
    );
  }
}
