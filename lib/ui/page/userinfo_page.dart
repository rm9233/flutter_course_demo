import 'dart:async';
import 'dart:convert';
import 'dart:io';

//import 'package:aly_oss/aly_oss.dart';
import 'package:aliyunoss/aliyunoss.dart';
import 'package:app/app/app_navigator.dart';
import 'package:app/common/config.dart';
import 'package:app/data/api.dart';
import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/sts_entity.dart';
import 'package:app/entity/user_entity.dart';
import 'package:app/util/date_util.dart';
import 'package:app/util/event_bus.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/log_util.dart';
import 'package:app/util/sp_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';
//import 'package:uuid/uuid.dart';

// 判断是否input焦点
// https://blog.csdn.net/sinat_37255207/article/details/105359572
// 键盘不顶起页面
// https://www.jianshu.com/p/956df82a37a2
// flutter 与原生的交互
// https://www.jianshu.com/p/c5263a3d7aac
// flutter 获取activity
// https://blog.csdn.net/qq1377399077/article/details/108979944
// Oss的异常
// https://www.alibabacloud.com/help/zh/doc-detail/32066.htm

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool loading = false;
  String MIN_DATETIME = '2010-01-01';
  String MAX_DATETIME = '2020-12-31';
  DateTime _dateTime = DateTime.parse('2010-01-01');
  String _format = 'yyyy-MMMM-dd';
  bool _showTitle = true;
//  DateTimePickerLocale _locale = DateTimePickerLocale.zh_cn;
  bool ifshowtime = false;

  final _uuid = Uuid();
//  final AlyOss _alyOss = AlyOss();

  TextEditingController nickNameEditer = TextEditingController();
  TextEditingController birthdayEditer = TextEditingController();

//  TextEditingController pswEditer = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  UserEntity userEntity = new UserEntity();

//  final FocusNode _nodeText3 = FocusNode();

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  showLoading() {
    setState(() {
      loading = true;
    });
  }

  hideLoading(){
    Timer(Duration(milliseconds: 200),(){
      if(mounted){
        setState(() {
          loading = false;
        });
      }
    });
  }

  onUpdate() {
    showLoading();
    var params = {};
    params["nickname"] = nickNameEditer.text;
    params["birthday"] = birthdayEditer.text;
    params["sex"] = userEntity.sex;
    params["avator"] = userEntity.avator;
    Repository().updateUser(params).then((value) {
      hideLoading();
      if(value["code"] == Code.SUCCESS){
        ToastUtil.show("修改成功");
        SpUtil.putString("user", jsonEncode(value["data"]));

        eventBus.emit("refresh");

      }else{
        ToastUtil.show(value["message"]);
      }
    }).catchError((onError) {
      hideLoading();
      ToastUtil.show(onError.toString());
    });
  }

  onLoad() {
    String jsonStr = SpUtil.getString("user");
    if (jsonStr != "") {
      Map<String, dynamic> json = jsonDecode(jsonStr);

      String birthday = "";
      setState(() {
        userEntity = UserEntity.fromJson(json);
        birthday = DateUtil.formatBirthday2(userEntity.birthday);
        if (birthday != "") {
          _dateTime = DateTime.parse(birthday);
        }
      });

      nickNameEditer.text = userEntity.nickName;
      birthdayEditer.text = birthday;
    }
  }

  Future<void> uploadFile(StsEntity se, String path) async {
    showLoading();
    OssEngine.onProgress = (Map map) {
      print("OssEngine.onProgress??");
      // {totalSize: 8924, currentSize: 4096}
      print(map);
    };

    OssEngine.onUpload = (Map map) {
      print("OssEngine.onUpload??");
      hideLoading();
      if (map.containsKey("status")) {
        if (map["status"] == "true") {
          setState(() {
            userEntity.avator = map["path"];
          });
        } else {
          ToastUtil.show(map["error"]);
        }
      }
    };

    String format = path.substring(path.lastIndexOf("."),path.length);
    String objectKey = _uuid.v4()+format;

    await Aliyunoss.init(
        se.accessKeyId, se.accessKeySecret, se.stsToken, se.bucket, se.region);
    await Aliyunoss.upload(path, se.bucket, se.region, objectKey);
  }

  Future<void> cropImage(File imageFile) async {
//    File croppedFile = await ImageCropper.cropImage(
//        sourcePath: imageFile.path,
//        aspectRatioPresets: [CropAspectRatioPreset.square],
//        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
//        compressQuality: 10,
//        androidUiSettings: AndroidUiSettings(
//            toolbarTitle: '裁剪',
//            toolbarColor: Colors.transparent,
//            toolbarWidgetColor: Color(0xffff6633),
//            initAspectRatio: CropAspectRatioPreset.original,
//            lockAspectRatio: false),
//        iosUiSettings: IOSUiSettings(
//          title: '裁剪',
//        ));
//
//    if (croppedFile != null) {
//      //[NSData dataWithContentsOfFile:dic[@"path"]];
//      Repository().sts().then((value) {
//        if (value["code"] == Code.SUCCESS) {
//          StsEntity se = StsEntity.fromJson(value["data"]);
//          this.uploadFile(se, croppedFile.path);
//        }
//      }).catchError((e) {});
//      _imagePath = croppedFile;
//      ossUrl = '';
//      flieUpload(_imagePath);
//      var result = await _alyOss
//          .init(InitRequest(_uuid.v4(), HOST+API.OSS, 'oss-cn-beijing.aliyuncs.com', '1234567890123456', '1234567890123456'));
//      Log.i(result);
//
//    }
  }

  Future<void> selectedImage(int type) async {
//    File image = await ImagePicker.pickImage(
//        source: type == 1 ? ImageSource.camera : ImageSource.gallery);
//    cropImage(image);
  }

  void showImagePickSheet() {
    showCupertinoModalPopup<int>(
        context: context,
        builder: (context) {
          var dialog = CupertinoActionSheet(
            title: Text("请选择"),
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, 0);
                  _nodeText1.unfocus();
                  _nodeText2.unfocus();
                },
                child: Text("取消")),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {
                    selectedImage(1);
                    AppNavigator.back(context);
                  },
                  child: Text('相机')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    selectedImage(2);
                    AppNavigator.back(context);
                  },
                  child: Text('相册')),
            ],
          );
          return dialog;
        });
  }

  void _showDatePicker() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "编辑资料",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          color: Colors.black,
          progressIndicator:
              SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
          child: Container(
            color: Colors.white,
            height: ScreenUtil().screenHeight,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: LayoutUtil.auto(30),
                      ),
                      InkWell(
                        onTap: () {
                          showImagePickSheet();
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: LayoutUtil.auto(160),
                                height: LayoutUtil.auto(160),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(LayoutUtil.auto(80)))),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(LayoutUtil.auto(75))),
                                  child: Container(
                                    width: LayoutUtil.auto(150),
                                    height: LayoutUtil.auto(150),
                                    child: userEntity != null &&
                                            userEntity.avator != ""
                                        ? Image.network(userEntity.avator)
                                        : Image.asset(
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
                                        Radius.circular(LayoutUtil.auto(25)))),
                                child:
                                    Image.asset("./assets/image/user-edit.png"),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(20),
                      ),
                      Text(
                        "更换头像",
                        style: TextStyle(
                            color: Color(0xff999999),
                            fontSize: LayoutUtil.setSp(24)),
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(70),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                userEntity.sex = 0;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: LayoutUtil.auto(80),
                                  height: LayoutUtil.auto(80),
                                  padding: EdgeInsets.all(LayoutUtil.auto(10)),
                                  child: Image.asset(
                                      userEntity != null && userEntity.sex == 0
                                          ? "./assets/image/icon-boy-select.png"
                                          : "./assets/image/icon-boy.png"),
                                  decoration: BoxDecoration(
                                      color: Color(0xffdfdfdf),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              LayoutUtil.auto(40)))),
                                ),
                                SizedBox(
                                  width: LayoutUtil.auto(20),
                                ),
                                Text(
                                  "男孩",
                                  style: TextStyle(
                                      color: Color(userEntity != null &&
                                              userEntity.sex == 0
                                          ? 0xff666666
                                          : 0xff999999),
                                      fontSize: LayoutUtil.setSp(28)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: LayoutUtil.auto(100),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                userEntity.sex = 1;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: LayoutUtil.auto(80),
                                  height: LayoutUtil.auto(80),
                                  padding: EdgeInsets.all(LayoutUtil.auto(10)),
                                  child: Image.asset(userEntity != null &&
                                          userEntity.sex == 1
                                      ? "./assets/image/icon-girl-select.png"
                                      : "./assets/image/icon-girl.png"),
                                  decoration: BoxDecoration(
                                      color: Color(0xffdfdfdf),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              LayoutUtil.auto(40)))),
                                ),
                                SizedBox(
                                  width: LayoutUtil.auto(20),
                                ),
                                Text(
                                  "女孩",
                                  style: TextStyle(
                                      color: Color(userEntity != null &&
                                              userEntity.sex == 1
                                          ? 0xff666666
                                          : 0xff999999),
                                      fontSize: LayoutUtil.setSp(28)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(90),
                      ),
                      Container(
                        padding: EdgeInsets.all(LayoutUtil.auto(30)),
                        margin: EdgeInsets.only(left: LayoutUtil.auto(30)),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: Color(0xffdfdfdf),
                              width: LayoutUtil.auto(1)),
                        )),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "宝贝名称",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              width: LayoutUtil.auto(40),
                            ),
                            Container(
                              width: LayoutUtil.auto(500),
                              height: LayoutUtil.auto(40),
                              child: TextField(
                                controller: nickNameEditer,
                                keyboardType: TextInputType.number,
                                focusNode: _nodeText1,
                                style: TextStyle(
                                    fontSize: LayoutUtil.setSp(28),
                                    color: Colors.grey),
                                maxLength: 10,
                                decoration: InputDecoration(
                                  hintText: '请输入宝贝的名称',
                                  counterText: "",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(30),
                      ),
                      Container(
                        padding: EdgeInsets.all(LayoutUtil.auto(30)),
                        margin: EdgeInsets.only(left: LayoutUtil.auto(30)),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: Color(0xffdfdfdf),
                              width: LayoutUtil.auto(1)),
                        )),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "宝贝生日",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              width: LayoutUtil.auto(40),
                            ),
                            InkWell(
                              onTap: () {
                                _showDatePicker();
                              },
                              child: Container(
                                width: LayoutUtil.auto(500),
                                height: LayoutUtil.auto(40),
                                child: TextField(
                                  controller: birthdayEditer,
                                  focusNode: _nodeText2,
                                  style: TextStyle(
                                      fontSize: LayoutUtil.setSp(28),
                                      color: Colors.grey),
                                  maxLength: 10,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: '请填写宝宝生日',
                                    counterText: "",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: LayoutUtil.auto(120),
                  child: RaisedButton(
                      onPressed: () {
                        this.onUpdate();
                      },
                      child: Container(
                        width: LayoutUtil.auto(240),
                        height: LayoutUtil.auto(90),
                        alignment: Alignment.center,
                        child: Text(
                          '保存',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: LayoutUtil.setSp(28),
                              color: Colors.white),
                        ),
                      ),
                      highlightColor: Colors.lightGreen,
                      color: Colors.green,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                ),
              ],
            ),
          ),
        ));
  }
}
