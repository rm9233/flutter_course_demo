import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app/app/app_navigator.dart';
import 'package:app/common/config.dart';
import 'package:app/entity/unit_entity.dart';
import 'package:app/ui/widget/kwebview.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/log_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:wakelock/wakelock.dart';
import 'package:device_info/device_info.dart';

/**
 * flutter ios 加载webview白屏问题
 * https://blog.csdn.net/oZhuiMeng123/article/details/93020774
 * */
//纯游戏页面
class GamePage extends StatefulWidget {
  final UnitEntity ue;

  const GamePage({Key key, this.ue}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  ReceivePort _port = ReceivePort();
  String localPath;

  RegExp reg = new RegExp(r"\/([a-zA-Z0-9]+).zip");

  String zipFileName;

  String courseStateString = "";
  String local = "";
  bool showCover = true;



  Future<bool> _onBackPressed(context) async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return await Future.value(true);
  }

  void nextViewCb(){
    //TODO 游戏增加一个清楚的方法 可以被直接调用
//    String funStr = "window.loadGame(\"" + se.url + "\")";
//    this._webViewController.evaluateJavascript(funStr);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: WillPopScope(
          onWillPop: () {
            return _onBackPressed(context);
          },
          child: Stack(
            children: <Widget>[
              local != ""
                  ? KWebView(
                url: local,
                callback: (type, parms) {
                  Log.i("type = loaded");
                  if (type == "loaded") {
                    setState(() {
                      courseStateString = "课件加载完成";
                    });
                    Wakelock.enable();
                    Timer(Duration(seconds: 3), () {
                      if (mounted) {
                        setState(() {
                          courseStateString = "";
                        });
                      }
                    });
                  }else if (type == "star") {
//                    addStarController.show(3);
//                    Timer(Duration(seconds: 2),(){
//                      nextViewController.show();
//                    });
                  }
                },

                onWebViewCreated: (controller) {

                },
              )
                  : Container(),
              Positioned(
                bottom: LayoutUtil.auto(30),
                left: LayoutUtil.auto(30),
                child: Text(
                  courseStateString,
                  style: TextStyle(
                      fontSize: LayoutUtil.setSp(24), color: Colors.grey),
                ),
              ),
              Positioned(
                top: LayoutUtil.auto(90),
                left: LayoutUtil.auto(30),
                child: InkWell(
                  onTap: () {
                    _onBackPressed(context);
                    AppNavigator.back(context);
                  },
                  child: Container(
                    width: LayoutUtil.auto(72),
                    child: Image.asset("./assets/image/arrow-back.png"),
                  ),
                ),
              ),
              Container(
                child: widget.ue.avator != null &&
                    widget.ue.avator != "" &&
                    showCover
                    ? Container(
                  color: Color(0xfff6f6f6),
                  child: Center(
                    child: Image.network(widget.ue.avator),
                  ),
                )
                    : Container(),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
//                    AddStarWrapper(onCreateView: (AddStarController _controller){
//                      addStarController = _controller;
//                    },)
                  ],
                ),
              ),
//              NextView(cb: this.nextViewCb,ue: widget.ue,onCreateView: (NextViewController controller){
//                nextViewController = controller;
//              },),

            ],
          ),
        ));
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print("status: $status");
      print("progress: $progress");
      print(
          'Download task ($id) is in status ($status) and process ($progress)');

      setState(() {
        courseStateString = "课件下载中 ($progress)% , 状态: $status";
      });

      if (progress == 100) {
        _unZip(localPath + '/' + zipFileName + ".zip");
      }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  String getFileName(url) {
    String fileName = "";
    Iterable<Match> matches = reg.allMatches(url);
    for (Match m in matches) {
      if (!m.group(0).isEmpty) {
        String s = m.group(0);
        fileName = s.substring(1, s.length - 4);
      }
    }
    return fileName;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    Timer(Duration(seconds: 2), () {
      setState(() {
        showCover = false;
      });
    });

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);

    zipFileName = getFileName(widget.ue.url);
    if (zipFileName == "" || zipFileName == null) {
      ToastUtil.show("课件下载地址错误..");
      return;
    }



    startDownloader();
  }

  startLoaderCourse() async {
    //todo bug ios 13 以上不能加载本地的文件
    // 参考链接 https://github.com/react-native-webview/react-native-webview/issues/952

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      setState(() {
        courseStateString = "课件加载中..";
        local =  (localPath.indexOf("file://") != -1 ? "" :"file://" ) +localPath + "/"+zipFileName + "/index.html";
      });
    }else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo.systemVersion);
      setState(() {
        courseStateString = "课件加载中..";
        if(iosInfo.systemVersion.indexOf("13")!=-1||iosInfo.systemVersion.indexOf("14")!=-1||iosInfo.systemVersion.indexOf("15")!=-1||iosInfo.systemVersion.indexOf("16")!=-1){
          local = "http://"+LOCAL+":"+PORT+"/" +zipFileName + "/index.html";
        }else{
          local =  (localPath.indexOf("file://") != -1 ? "" :"file://" ) +localPath + "/"+zipFileName + "/index.html";
        }
      });
    }

  }

  void startDownloader() async {
    localPath = await FileUtil.getLocalPath();
    final savedDir = Directory(localPath);
    // 判断下载路径是否存在
    bool hasExisted = await savedDir.exists();
    // 不存在就新建路径
    if (!hasExisted) {
      savedDir.create();
    }

    var _unzipFilePath = localPath + "/" + zipFileName + "/cocos2d-js-min.js";
    final unZipFileDir = File(_unzipFilePath);
    bool unZipHasExisted = await unZipFileDir.exists();
    if (unZipHasExisted) {
      startLoaderCourse();
    } else {
      var _zipFilePath = localPath + "/" + zipFileName + ".zip";
      final zipFileDir = File(_zipFilePath);
      bool zipHasExisted = await zipFileDir.exists();
      if (zipHasExisted) {
        this._unZip(_zipFilePath);
      } else {
        this._downloadFile(widget.ue.url, localPath);
      }
    }
  }

  _downloadFile(downloadUrl, savePath) async {
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: savePath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
      false, // click on notification to open downloaded file (for Android)
    );
  }

  void _unZip(String path) async {
    setState(() {
      courseStateString = "课件开始解压 ..";
    });

    final zipFile = File(path);
    // Read the Zip file from disk.
    final bytes = zipFile.readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    try {
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File(localPath + "/" + filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(localPath + "/" + filename)..create(recursive: true);
        }
      }
    } catch (e) {
      ToastUtil.show(e.toString());
      setState(() {
        courseStateString = "课件解压失败 ..";
      });
      return;
    }

    setState(() {
      courseStateString = "课件解压完成 ..";
    });

    startLoaderCourse();
  }

  @override
  void dispose() {
    super.dispose();
    _unbindBackgroundIsolate();
    Wakelock.disable();
  }
}
