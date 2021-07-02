import 'dart:io';

import 'package:app/app/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/util/layout_util.dart';

class PermissionDialog extends StatefulWidget {
  final Function cb;
  final Object data;

  const PermissionDialog({Key key, this.cb,this.data}) : super(key: key);

  @override
  _PermissionDialogState createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {


  bool camera = false;
  bool  photos =false;
  bool microphone = false;
  bool   storage = false;

  @override
  void initState() {
    super.initState();
    this.checkPermission();
  }


  Future<void> checkPermission() async {
    PermissionStatus cameraStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus photosStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    PermissionStatus microphoneStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    PermissionStatus storageStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    setState(() {
      camera = cameraStatus == PermissionStatus.granted;
      photos = photosStatus == PermissionStatus.granted;
      microphone = microphoneStatus == PermissionStatus.granted;
      storage = Platform.isIOS || storageStatus == PermissionStatus.granted;
    });

  }

  void onTap(String type) async{

      switch(type){
        case "camera":
          PermissionHandler().requestPermissions(<PermissionGroup>[
            PermissionGroup.camera,
          ]).then((onValue) {
            setState((){
              camera = onValue[PermissionGroup.camera] == PermissionStatus.granted;
            });
            this.onOver();
          });
          break;
        case "photos":
          PermissionHandler().requestPermissions(<PermissionGroup>[
            PermissionGroup.photos,
          ]).then((onValue) {
            setState((){
              photos = onValue[PermissionGroup.photos] == PermissionStatus.granted;
            });
            this.onOver();
          });
          break;
        case "microphone":
          PermissionHandler().requestPermissions(<PermissionGroup>[
            PermissionGroup.microphone,
          ]).then((onValue) {
            setState((){
              microphone = onValue[PermissionGroup.microphone] == PermissionStatus.granted;
            });
            this.onOver();
          });
          break;
        case "storage":
          PermissionHandler().requestPermissions(<PermissionGroup>[
            PermissionGroup.storage,
          ]).then((onValue) {
            setState((){
              storage = onValue[PermissionGroup.storage] == PermissionStatus.granted;
            });
            this.onOver();
          });
          break;
      }


  }

  void onOver(){
    if(camera && storage && microphone && photos){
      widget.cb(widget.data);
      AppNavigator.back(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        //创建透明层
        backgroundColor: Color(0x3d000000),
        body: Center(
            child: Container(
                width: LayoutUtil.auto(680),
                height: LayoutUtil.auto(500),
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                    children: <Widget>[
                      SizedBox(height: LayoutUtil.auto(120),),
                      Text("当前操作需要,允许以下权限才可继续进行"),
                      SizedBox(height: LayoutUtil.auto(40),),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            camera ? Container(child: Image.asset("./assets/image/select-bold.png"),width: LayoutUtil.auto(36),) : Container(),
                            SizedBox(width: LayoutUtil.auto(20)),
                            Text("启动相机访问权限",style: TextStyle(color: Color(camera ?  0xff999999 : 0xff5086ec)),)
                          ],
                        ),
                        onTap: (){
                          this.onTap("camera");
                        },
                      ),
                      SizedBox(height: LayoutUtil.auto(30),),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            photos ? Container(child: Image.asset("./assets/image/select-bold.png"),width: LayoutUtil.auto(36),) : Container(),
                            SizedBox(width: LayoutUtil.auto(20)),
                            Text("启动访问相册权限",style: TextStyle(color: Color(photos ?  0xff999999 : 0xff5086ec)),)
                          ],
                        ),
                        onTap: (){
                          this.onTap("photos");
                        },
                      ),
                      SizedBox(height: LayoutUtil.auto(30),),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            storage ? Container(child: Image.asset("./assets/image/select-bold.png"),width: LayoutUtil.auto(36),) : Container(),
                            SizedBox(width: LayoutUtil.auto(20)),
                            Text("启动写入文件权限",style: TextStyle(color: Color(storage ?  0xff999999 : 0xff5086ec)),)
                          ],
                        ),
                        onTap: (){
                          this.onTap("storage");
                        },
                      ),
                      SizedBox(height: LayoutUtil.auto(30),),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            microphone ? Container(child: Image.asset("./assets/image/select-bold.png"),width: LayoutUtil.auto(36),) : Container(),
                            SizedBox(width: LayoutUtil.auto(20)),
                            Text("启动麦克风访问权限",style: TextStyle(color: Color(microphone ?  0xff999999 : 0xff5086ec)),)
                          ],
                        ),
                        onTap: (){
                          this.onTap("microphone");
                        },
                      ),
                    ],
                )
            )
        )
    );
  }


}
