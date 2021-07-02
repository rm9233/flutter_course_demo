import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app/common/config.dart';
import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/script_entity.dart';
import 'package:app/entity/unit_entity.dart';
import 'package:app/ui/widget/kwebview.dart';
import 'package:app/ui/widget/onnode_view_listener.dart';
import 'package:app/util/date_util.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/log_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:archive/archive.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:app/util/layout_util.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';

/**
 * container 设置无效
 * https://blog.csdn.net/yujunlong3919/article/details/104159912?utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~baidu_landing_v2~default-1-104159912.nonecase&utm_term=container%20%E5%AE%BD%E9%AB%98%E9%99%90%E5%88%B6%E6%97%A0%E6%95%88&spm=1000.2123.3001.4430
 *
 * 速度慢
 * https://blog.csdn.net/BianHuanShiZhe/article/details/105047462
 *
 * ios webview加载本地文件
 * http://hk.uwenku.com/question/p-ztvybyxc-bkq.html
 *
 * android 和 ios的跨域方案
 * webview.getsettings().setAllowFileAccessFromFileURLs(true);
 *
 * 为什么还会继续启动服务
 * 因为图片不打算放服务器上，从用户本地取出 速度会更快一些 减少网络原因造成找不到图
 * */

//视频播放页
class PlayerPage extends StatefulWidget {
  final UnitEntity ue;

  const PlayerPage({Key key, this.ue}) : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with OnNodeViewListener {
  VideoPlayerController _controller;
  ReceivePort _port = ReceivePort();

  bool showCover = true;
  RegExp reg = new RegExp(r"\/([a-zA-Z0-9]+).zip");
  String zipFileName = "";
  String localPath = "";
  String courseStateString = "正在初始化..";
  String local = "";
  WebViewController _webViewController;
  int indexed = 0;
  bool showBar = true;
  bool seeking = false;
  double progress = 0.0;
  double gameProgress = 0.0;
  bool gameing = false;
  String canvas = "";

  //剧本
  List<Widget> scripts = [];

  //剧本执行点
  Map<String, ScriptEntity> scriptMap = new Map<String, ScriptEntity>();

  String duration = "00:00";
  String position = "00:00";

  // 加载完成前 锁定播放按钮
  bool playLocked = true;

  Timer runTimer;
  Timer gameTimer;

  int seekSeconds = 0;

  String seekPositionStr = "00:00";
  bool playComplete = false;

//  NextViewController nextViewController;
//
//  AddStarController addStarController;

  String lastLoadGameTime = "";

  void buildScript() {
    List<Widget> list = [];
    if (widget.ue.scriptUrl != "") {
      Repository().scriptList(widget.ue.id).then((value) {
        if (value['code'] == Code.SUCCESS) {
          List data = value['data'];
          ScriptEntity se = new ScriptEntity();
          List<ScriptEntity> sel = [];
          for (int i = 0; i < data.length; i++) {
            se = ScriptEntity.fromJson(data[i]);
            sel.add(se);
          }

          for (int i = 0; i < sel.length; i++) {
            ScriptEntity se = sel[i];
            if (se.show < _controller.value.duration.inSeconds) {
              double local =
                  1240 * (se.show / _controller.value.duration.inSeconds);
              list.add(
                Positioned(
                  left: LayoutUtil.auto(local),
                  bottom: LayoutUtil.auto(0),
                  child: Container(
                    width: LayoutUtil.auto(60),
                    height: LayoutUtil.auto(60),
                    child: Image.asset("./assets/image/map.png"),
                  ),
                ),
              );
              scriptMap[se.show.toString()] = se;
              setState(() {
                scripts = list;
              });
            }
          }
        } else {
          ToastUtil.show(value['message']);
        }
      }).catchError((err) {
        ToastUtil.show(err.toString());
      });
    }
  }

  onRecord(double progress) {
    var params = {
      "video_id": widget.ue.videoId,
      "del": 0,
      "progress": progress,
      "unit_id": widget.ue.id
    };
//    Repository().addRecord(params).then((value) => null).catchError((err) {
//      ToastUtil.show(err.toString());
//    });
  }

  @override
  void initState() {
    super.initState();
    onRecord(0.5);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _controller = VideoPlayerController.network(widget.ue.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        this.buildScript();
        _onListener();
      });

    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showCover = false;
        });
      }
    });

    if (widget.ue.scriptUrl != null && widget.ue.scriptUrl != "") {
      zipFileName = getFileName(widget.ue.scriptUrl);
      if (zipFileName == "" || zipFileName == null) {
        ToastUtil.show("课件下载地址错误..");
        return;
      }

      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
      startDownloader();

      //渲染剧本中对应的点

    } else {
      //普通视频直接播放
      ToastUtil.show("视频准备播放..");
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            showBar = false;
            playLocked = false;
            courseStateString = "";
          });
        }
      });
      _controller.play();
    }

    Wakelock.enable();
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
        this._downloadFile(widget.ue.scriptUrl, localPath);
      }
    }
  }

  startLoaderCourse() async {
    //todo bug ios 13 以上不能加载本地的文件
    // 参考链接 https://github.com/react-native-webview/react-native-webview/issues/952

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      setState(() {
        courseStateString = "课件加载中..";
        indexed = 1;
        local = (localPath.indexOf("file://") != -1 ? "" : "file://") +
            localPath +
            "/" +
            zipFileName +
            "/index.html";
      });
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo.systemVersion);
      setState(() {
        courseStateString = "课件加载中..";
        indexed = 1;
        if (iosInfo.systemVersion.indexOf("13") != -1 ||
            iosInfo.systemVersion.indexOf("14") != -1 ||
            iosInfo.systemVersion.indexOf("15") != -1 ||
            iosInfo.systemVersion.indexOf("16") != -1) {
          local = "http://" +
              LOCAL +
              ":" +
              PORT +
              "/" +
              zipFileName +
              "/index.html";
        } else {
          local = (localPath.indexOf("file://") != -1 ? "" : "file://") +
              localPath +
              "/" +
              zipFileName +
              "/index.html";
        }
      });
    }
  }

  closeGame() {
    if (mounted) {
      setState(() {
        gameing = false;
        indexed = 0;
      });
    }

    gameTimer.cancel();
    _controller.play();

    String funStr = "window.closeGame()";
    this._webViewController.evaluateJavascript(funStr);
  }

  _onListener() {
    String durationStr = DateUtil.formatMin(_controller.value.duration);
    Timer.periodic(Duration(seconds: 1), (timer) {
      runTimer = timer;
      String positionStr = DateUtil.formatMin(_controller.value.position);
      if (mounted) {
        setState(() {
          duration = durationStr;
          position = positionStr;
          progress = _controller.value.position.inSeconds /
              _controller.value.duration.inSeconds;
        });
      }

      if (scriptMap
          .containsKey(_controller.value.position.inSeconds.toString()) &&
          !gameing) {
        ScriptEntity se =
        scriptMap[_controller.value.position.inSeconds.toString()];
        if (lastLoadGameTime == se.url) {
          return;
        }
        lastLoadGameTime = se.url;
        _controller.pause();
        if (mounted) {
          setState(() {
            indexed = 1;
            gameProgress = 0;
            canvas = "";
          });
        }

        gameing = true;
        String funStr = "window.loadGame(\"" + se.url + "\")";
        this._webViewController.evaluateJavascript(funStr);

        /**
         * 开启倒计时
         * */
        int countTime = 0;
        Timer.periodic(Duration(seconds: 1), (timer) {
          gameTimer = timer;
          countTime++;
          if (countTime == se.hide) {
            closeGame();
          } else {
            if (mounted) {
              setState(() {
                gameProgress = countTime / se.hide;
              });
            }

            Log.i(gameProgress);
          }
        });
      }

      if (_controller.value.position.inSeconds ==
          _controller.value.duration.inSeconds) {
        runTimer.cancel();
        playComplete = true;
//        nextViewController.show();
        onRecord(1);
      }
    });
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

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
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

  initDonwload() async {
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<bool> _onBackPressed(context) async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return await Future.value(true);
  }

  onHideBar() {
    Timer(Duration(seconds: 5), () {
      if (seeking) {
        onHideBar();
      } else {
        if (mounted) {
          setState(() {
            showBar = false;
          });
        }
      }
    });
  }

  void nextViewCb() {
    ToastUtil.show("开始重新播放");
//    nextViewController.hide();
    _controller.seekTo(Duration(seconds: 0));
    _controller.play();
    _onListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () {
              return _onBackPressed(context);
            },
            child: IndexedStack(
              index: indexed,
              children: <Widget>[
                Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Center(
                        child: _controller.value.initialized
                            ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                            : Container(),
                      ),
                      canvas != "" && canvas != null
                          ? Center(
                        child: Container(
                          width: LayoutUtil.auto(1334),
                          height: LayoutUtil.auto(750),
                          color: Colors.transparent,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: LayoutUtil.auto(30),
                                right: 0,
                                child: Container(
                                  color: Colors.white,
                                  width: LayoutUtil.auto(450 / 2),
                                  height: LayoutUtil.auto(436 / 2),
                                  child: Image.network(canvas),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                          : Container(),
                      Center(
                        child: Listener(
                            onPointerDown: (event) {
                              Log.i("kevin: onPointerDown" +
                                  event.localPosition.dx.toString());
                              if (!showBar) {
                                setState(() {
                                  showBar = true;
                                });
                                onHideBar();
                              }
                            },
                            onPointerMove: (event) {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                                seeking = true;
                                seekSeconds =
                                    _controller.value.position.inSeconds;
                                seekPositionStr = DateUtil.formatMin(
                                    _controller.value.position);
                              }

                              double local = event.localPosition.dx /
                                  LayoutUtil.auto(1334);
                              if (local < 0) {
                                local = 0;
                              } else if (local > 1) {
                                local = 1;
                              }

                              setState(() {
                                seekSeconds =
                                    (_controller.value.duration.inSeconds *
                                        local)
                                        .floor();
                                seekPositionStr = DateUtil.formatMin(
                                    Duration(seconds: seekSeconds));
                              });
                            },
                            onPointerUp: (event) {
                              Log.i("kevin: onPointerUp" +
                                  event.localPosition.dx.toString());
                              if (seeking) {
                                _controller
                                    .seekTo(Duration(seconds: seekSeconds));
                                _controller.play();
                                lastLoadGameTime =
                                ""; // 清楚记录的标记 防止在同一视频节点加载两次游戏问题
                                if (mounted) {
                                  setState(() {
                                    canvas = "";
                                  });
                                }
                              }
                              seeking = false;
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: LayoutUtil.auto(1334),
                                  height: LayoutUtil.auto(750),
                                  color: Colors.transparent,
                                ),
                                Center(
                                  child: seeking
                                      ? Container(
                                    width: LayoutUtil.auto(350),
                                    height: LayoutUtil.auto(200),
                                    decoration: BoxDecoration(
                                        color: Color(0x66999999),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                LayoutUtil.auto(20)))),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: LayoutUtil.auto(40),
                                        ),
                                        Container(
                                          width: LayoutUtil.auto(72),
                                          child: Image.asset(
                                              "./assets/image/animal.png"),
                                        ),
                                        SizedBox(
                                          height: LayoutUtil.auto(10),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              seekPositionStr,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  LayoutUtil.setSp(
                                                      28)),
                                            ),
                                            Text(
                                              "/",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  LayoutUtil.setSp(
                                                      28)),
                                            ),
                                            Text(
                                              _controller != null
                                                  ? DateUtil.formatMin(
                                                  _controller
                                                      .value.duration)
                                                  : '00:00',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  LayoutUtil.setSp(
                                                      28)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                      : Container(),
                                )
                              ],
                            )),
                      ),
                      showBar
                          ? Positioned(
                        top: 0,
                        child: Container(
                          width: ScreenUtil().screenHeight,
                          height: LayoutUtil.auto(160),
                          padding: EdgeInsets.only(
                              bottom: LayoutUtil.auto(60)),
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xaa666666),
                                  Colors.transparent,
                                ],
                              )),
                          child: InkWell(
                            onTap: () {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown
                              ]);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: LayoutUtil.auto(40),
                                ),
                                Container(
                                  width: LayoutUtil.auto(40),
                                  height: LayoutUtil.auto(40),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: LayoutUtil.auto(32),
                                  ),
                                ),
                                SizedBox(
                                  width: LayoutUtil.auto(20),
                                ),
                                Text(
                                  widget.ue.title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: LayoutUtil.setSp(32)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          : Container(),
                      showBar
                          ? Positioned(
                        bottom: LayoutUtil.auto(150),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: LayoutUtil.auto(1300),
                              height: LayoutUtil.auto(60),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                    width: LayoutUtil.auto(1300),
                                    height: LayoutUtil.auto(4),
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey,
                                      value: progress,
                                      valueColor:
                                      new AlwaysStoppedAnimation<
                                          Color>(Colors.orange),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                          : Container(),
                      showBar
                          ? Positioned(
                        bottom: LayoutUtil.auto(150),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: LayoutUtil.auto(1300),
                              height: LayoutUtil.auto(60),
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: scripts),
                            )
                          ],
                        ),
                      )
                          : Container(),
                      showBar
                          ? Positioned(
                        bottom: 0,
                        child: Container(
                          width: ScreenUtil().screenHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topLeft,
                                colors: [
                                  Color(0xaa666666),
                                  Colors.transparent,
                                ],
                              )),
                          child: Container(
                            width: LayoutUtil.auto(1300),
                            height: LayoutUtil.auto(180),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: LayoutUtil.auto(50),
                                      height: LayoutUtil.auto(50),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (!playLocked) {
                                                _controller.value
                                                    .isPlaying
                                                    ? _controller
                                                    .pause()
                                                    : _controller
                                                    .play();
                                              }
                                              if (playComplete) {
                                                _controller.seekTo(
                                                    Duration(
                                                        seconds: 0));
                                                _controller.play();
                                                _onListener();
                                              }
                                            });
                                          },
                                          child: Image.asset(_controller
                                              .value.isPlaying
                                              ? "./assets/image/pause.png"
                                              : "./assets/image/play.png")),
                                    ),
                                    SizedBox(
                                      width: LayoutUtil.auto(30),
                                    ),
                                    Text(
                                      position,
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                    Text(
                                      " / ",
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                    Text(
                                      duration,
                                      style: TextStyle(
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: LayoutUtil.auto(10),
                                ),
                                Container(
                                  child: Text(
                                    courseStateString,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                          : Container(),
//                      Container(
//                        alignment: Alignment.center,
//                        child: Row(
//                          children: [
//                            AddStarWrapper(
//                              onCreateView: (AddStarController _controller) {
//                                addStarController = _controller;
//                              },
//                            )
//                          ],
//                        ),
//                      ),
//                      NextView(
//                        cb: this.nextViewCb,
//                        ue: widget.ue,
//                        onCreateView: (NextViewController controller) {
//                          nextViewController = controller;
//                        },
//                      ),
                      showCover
                          ? Container(
                        child: widget.ue.avator != null &&
                            widget.ue.avator != ""
                            ? Container(
                          color: Color(0xfff6f6f6),
                          child: Center(
                            child: Image.network(widget.ue.avator),
                          ),
                        )
                            : Container(),
                      )
                          : Container()
                    ],
                  ),
                ),
                local != ""
                    ? Stack(
                  children: <Widget>[
                    KWebView(
                      url: local,
                      callback: (type, parms) {
                        if (type == "loaded") {
                          setState(() {
                            courseStateString = "课件加载完成";
                            indexed = 0;
                            playLocked = false;
                            _controller.play();
                          });

                          Timer(Duration(seconds: 3), () {
                            if (mounted) {
                              setState(() {
                                courseStateString = "";
                                showBar = false;
                              });
                            }
                          });
                        } else if (type == "canvas") {
                          print(parms);
                          String path = Uri.decodeComponent(parms);
                          setState(() {
                            canvas = "http://" +
                                LOCAL +
                                ":" +
                                PORT +
                                "/" +
                                zipFileName +
                                path;
                          });
                        } else if (type == "star") {
                          closeGame();
//                          addStarController.show(3);
                        }
                      },
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                    ),
                    gameing
                        ? Positioned(
                      top: LayoutUtil.auto(100),
                      right: LayoutUtil.auto(30),
                      child: Container(
                        width: LayoutUtil.auto(50),
                        height: LayoutUtil.auto(50),
                        child: CircularProgressIndicator(
                          strokeWidth: LayoutUtil.auto(12),
                          backgroundColor: Colors.grey,
                          value: gameProgress,
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(
                              Colors.orangeAccent),
                        ),
                      ),
                    )
                        : Container(),

                  ],
                )
                    : Container(),
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _unbindBackgroundIsolate();
    _controller.dispose();
    Wakelock.disable();
    if (runTimer != null) {
      runTimer.cancel();
    }

    if (gameTimer != null) {
      gameTimer.cancel();
    }
  }
}
