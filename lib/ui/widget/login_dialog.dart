import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/app/app_navigator.dart';
import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/util/event_bus.dart';
import 'package:app/util/sp_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:package_info/package_info.dart';
import 'package:app/util/layout_util.dart';

import 'code_button.dart';
import 'keyboard_avoiding.dart';


class LoginDialog extends Dialog {
  bool loading = false;
  TextEditingController phoneEditer = TextEditingController();
  TextEditingController codeEditer = TextEditingController();
  TextEditingController pswEditer = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  String device_info;
  String deviceId;
  String version;
  int type = 0;
  int countdownSeconds = 0;
  bool check = false;
  bool isCanSee = true;
  Timer timer;
  bool show = true;
  String location = "";

  LoginDialog({Key key, String url}) : super(key: key) {
    getDeviceInfo();
    var phoneNum = SpUtil.getString("phone_num");
    SpUtil.getInstance();
    phoneEditer.text = phoneNum;
    location = url;
  }

  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      this.device_info = androidInfo.device;
      this.deviceId = androidInfo.androidId;
      print(
          'Running on${androidInfo.device} ${androidInfo.isPhysicalDevice} ${androidInfo.model}${this.deviceId}'); // e.g. "Moto G (4)"
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      this.deviceId = iosInfo.identifierForVendor;
      print('Running on ${iosInfo.utsname.machine}====${this.deviceId}');
      device_info = iosInfo.utsname.machine;
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    this.version = packageInfo.version;
  }

  Widget buildTopbar(Function callback) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            callback({
              "type": 0,
            });
          },
          child: Text(
            "手机号登录",
            style: TextStyle(
                fontSize: LayoutUtil.setSp(36),
                color: type == 0 ? Colors.black : Colors.grey,
                fontWeight: type == 0 ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: LayoutUtil.auto(32)),
          child: Container(
            width: 1,
            height: LayoutUtil.auto(42),
            color: Colors.grey,
          ),
        ),
        InkWell(
          onTap: () {
            callback({
              "type": 1,
            });
          },
          child: Text(
            "密码登录",
            style: TextStyle(
                fontSize: LayoutUtil.setSp(36),
                color: type == 1 ? Colors.black : Colors.grey,
                fontWeight: type == 1 ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void onLogin(Function callback, BuildContext context) async {
    var phone = phoneEditer.text;
    var code;
    if (phoneEditer.text.length == 0) {
      ToastUtil.show('手机号不能为空');
      return;
    }
    if (isChinaPhoneLegal(phoneEditer.text)) {
      print('手机号正确');
    } else {
      ToastUtil.show('请输入正确的手机号');
      return;
    }

    if (type == 0) {
      code = codeEditer.text;
      if (codeEditer.text.length == 0) {
        ToastUtil.show('验证码不能为空');
        return;
      }
    } else {
      code = pswEditer.text;
      if (code.length < 6) {
        ToastUtil.show('密码不能小于6位');
        return;
      }
    }

    if (!this.check) {
      ToastUtil.show('请阅读并同意用户协议和隐私政策');
      return;
    }

    callback({"loading": true});

    var params = {
      'platform': Platform.isIOS ? 'IOS' : 'Android',
      'device_info': device_info,
      'deviceId': this.deviceId,
      'version': version,
    };

    if (type == 0) {
      //短信
    } else {
      params['mobile'] = phone;
      params["password"] = code;
    }

    Repository().login(params).then((value){

      if(value["code"] == Code.SUCCESS){

        callback({"loading": false, "seconds": 0});
        ToastUtil.show('登录成功');
        if (timer != null) {
          timer.cancel();
        }

        SpUtil.putString("user", jsonEncode(value["data"]));
        SpUtil.putString("token", value["data"]["token"]);

        AppNavigator.back(context);
        eventBus.emit('refresh', '');
      }else{
        callback({"loading": false, "seconds": countdownSeconds});
        ToastUtil.show(value['message']);
      }
    },onError: (err){
        callback({"loading": false, "seconds": 0});
        ToastUtil.show(err.toString());
    });


  }

  Widget buildLoginBut(Function callback, BuildContext context) {
    return Container(
      child: RaisedButton(
          onPressed: () {
            onLogin(callback, context);
          },
          child: Container(
            width: LayoutUtil.auto(640),
            child: Text(
              '登录',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: LayoutUtil.setSp(28), color: Colors.white),
            ),
          ),
          highlightColor: Colors.lightGreen,
          color: Colors.green,
          elevation: 1,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
    );
  }

  Widget buildAgreement(BuildContext context, Function callback) {
    return InkWell(
        onTap: () {
          this.check = !this.check;
          callback({"agreement": this.check});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(
                image: AssetImage(this.check
                    ? "./assets/image/checkmark-square-out.png"
                    : "./assets/image/checkmark-square-outed.png"),
                width: LayoutUtil.setSp(32)),
            SizedBox(
              width: LayoutUtil.setSp(10),
            ),
            Text(
              '同意SuperKid课堂',
              style: TextStyle(fontSize: LayoutUtil.setSp(24)),
            ),
            InkWell(
              onTap: () {
                //AppNavigator.gotoProtocol(context, 1);
              },
              child: Text(
                '用户协议',
                style: TextStyle(
                    fontSize: LayoutUtil.setSp(24), color: Colors.green),
              ),
            ),
            Text(
              '和',
              style: TextStyle(fontSize: LayoutUtil.setSp(24)),
            ),
            InkWell(
              onTap: () {
                //AppNavigator.gotoProtocol(context, 2);
              },
              child: Text(
                '隐私政策',
                style: TextStyle(
                    fontSize: LayoutUtil.setSp(24), color: Colors.green),
              ),
            )
          ],
        ));
  }

  Widget buildPhone() {
    return Container(
      alignment: Alignment.centerLeft,
      height: LayoutUtil.auto(90),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: LayoutUtil.auto(1),
                  color: Color(0xffedeeee)))),
      child: TextField(
        controller: phoneEditer,
        keyboardType: TextInputType.number,
        focusNode: _nodeText3,
        style: TextStyle(fontSize: LayoutUtil.setSp(28), color: Colors.grey),
        maxLength: 11,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[0-9]")),
          LengthLimitingTextInputFormatter(11),
        ],
        decoration: InputDecoration(
          hintText: '请输入11位手机号',
          counterText: "",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget buildPsw(Function callback) {
    if (type == 1) {
      return Container(
        alignment: Alignment.centerLeft,
        height: LayoutUtil.auto(90),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: LayoutUtil.auto(1),
                    color: Color(0xffedeeee)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: TextField(
                  controller: pswEditer,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: _nodeText1,
                  maxLength: 16,
                  style: TextStyle(
                      fontSize: LayoutUtil.setSp(28), color: Colors.grey),
                  decoration: InputDecoration(
                    hintText: '请填写密码',
                    counterText: "",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[^\u4e00-\u9fa5]")),
                    LengthLimitingTextInputFormatter(16),
                  ],
                  obscureText: isCanSee),
            ),
//            IconButton(
//                iconSize: LayoutUtil.auto(20),
//                icon: Image.asset(Utils.getImgPath(isCanSee ? "nosee" : 'see')),
//                onPressed: () {
//                  callback({"see": !isCanSee});
//                })
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  static bool isChinaPhoneLegal(String str) {
    print('${str.split('')[0]}#########${str.split('')[0] == '1'}');
    return str.split('')[0] == '1' && str.length == 11 ? true : false;
  }

  coldDown(Function callback) {
    timer = Timer(Duration(seconds: 1), () {
      print(countdownSeconds);
      callback({"seconds": --countdownSeconds});
      if (countdownSeconds == 0) {
        timer.cancel();
      } else {
        coldDown(callback);
      }
    });
  }

  fetchSmsCode(Function callback) async {
    if (phoneEditer.text.length == 0) {
      ToastUtil.show('手机号不能为空');
      return;
    }
    if (isChinaPhoneLegal(phoneEditer.text)) {
      print('手机号正确');
    } else {
      ToastUtil.show('请输入正确的手机号');
      return;
    }

    var params = {"mobile": phoneEditer.text, "method": "login"};

    callback({"seconds": 60});

    coldDown(callback);

  }

  Widget buildCode(Function callback) {
    if (type == 1) {
      return Container();
    }
    return Container(
      alignment: Alignment.centerLeft,
      height: LayoutUtil.auto(90),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: LayoutUtil.auto(1),
                  color: Color(0xffedeeee)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextField(
                controller: codeEditer,
                keyboardType: TextInputType.number,
                focusNode: _nodeText2,
                maxLength: 4,
                style: TextStyle(
                    fontSize: LayoutUtil.setSp(28), color: Colors.grey),
                decoration: InputDecoration(
                  hintText: '请输入4位验证码',
                  counterText: "",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9]")),
                  LengthLimitingTextInputFormatter(4),
                ],
                obscureText: false),
          ),
          CodeButton(
            onPressed: () => {fetchSmsCode(callback)},
            coldDownSeconds: countdownSeconds,
          ),
        ],
      ),
    );
  }

  Widget buildForget(BuildContext context) {
    if (type == 1) {
      return Container(
          height: LayoutUtil.auto(50),
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              //AppNavigator.gotoForgotPassword(context, 2);
            },
            child: Text(
              "忘记密码？",
              style: TextStyle(
                  color: Colors.grey, fontSize: LayoutUtil.setSp(24)),
            ),
          ));
    } else {
      return SizedBox(
        height: LayoutUtil.auto(50),
      );
    }
  }

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _nodeText1,
        ),
        KeyboardAction(
          focusNode: _nodeText2,
          closeWidget: Padding(padding: EdgeInsets.all(8.0), child: Text('完成')),
        ),
        KeyboardAction(
          focusNode: _nodeText3,
          closeWidget: Padding(padding: EdgeInsets.all(8.0), child: Text('完成')),
          onTapAction: () {},
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context, Function callback) {
    return Container(
      child: Center(
        child: Container(
          width: LayoutUtil.auto(720),
          height: LayoutUtil.auto(680),
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: LayoutUtil.auto(20),
                  top: LayoutUtil.auto(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          LayoutUtil.auto(20))),
                      color: Colors.white,
                    ),
                    width: LayoutUtil.auto(680),
                    height: LayoutUtil.auto(640),
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: LayoutUtil.auto(65),
                            right: LayoutUtil.auto(65),
                            top: LayoutUtil.auto(70)),
                        child: Column(
                          children: <Widget>[
                            buildTopbar(callback),
                            SizedBox(
                              height: LayoutUtil.auto(60),
                            ),
                            buildPhone(),
                            SizedBox(
                              height: LayoutUtil.auto(20),
                            ),
                            buildPsw(callback),
                            buildCode(callback),
                            SizedBox(
                                height: LayoutUtil.auto(10)),
                            buildForget(context),
                            buildLoginBut((params) {
                              callback(params);
                            }, context),
                            SizedBox(
                                height: LayoutUtil.auto(24)),
                            buildAgreement(context, callback),
                          ],
                        )),
                  )),
              Positioned(
                top: LayoutUtil.auto(-30),
                right: LayoutUtil.auto(-30),
                child: InkWell(
                  onTap: () {
                    //callback({"show":false});
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: LayoutUtil.auto(130),
                    height: LayoutUtil.auto(130),
                    child: Center(
                      child: Image(
                        image: AssetImage("./assets/image/close.png"),
                        width: LayoutUtil.auto(65),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //创建透明层
        backgroundColor: Color(0x3d000000),
        body: StatefulBuilder(builder: (context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              print("FocusScope");
              _nodeText3.unfocus();
              _nodeText1.unfocus();
              _nodeText2.unfocus();
            },
            child: KeyboardAvoiding(
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight,
                  child: ModalProgressHUD(
                    inAsyncCall: loading,
                    color: Colors.black,
                    progressIndicator:
                    SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
                    child: Center(
                      child: SingleChildScrollView(
                        child: buildBody(context, (params) {
                          setState(() {
                            type = params["type"] != null ? params["type"] : type;
                            isCanSee =
                            params["see"] != null ? params["see"] : isCanSee;
                            countdownSeconds = params["seconds"] != null
                                ? params["seconds"]
                                : countdownSeconds;
                            loading = params["loading"] != null
                                ? params["loading"]
                                : loading;
                            check = params["agreement"] != null
                                ? params["agreement"]
                                : check;
                            show = params["show"] != null ? params["show"] : show;
                          });
                        }),
                      ),
                    ),
                  ),
                )),
          );
        }));
  }
}
