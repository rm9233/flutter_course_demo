import 'package:app/app/app_navigator.dart';
import 'package:app/util/event_bus.dart';
import 'package:app/util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:app/util/layout_util.dart';

class LogoutDialog extends Dialog {
  LogoutDialog({Key key}) : super(key: key);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
        type: MaterialType.transparency,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return ModalProgressHUD(
            inAsyncCall: loading,
            color: Colors.black,
            progressIndicator:
            SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
            child: Container(
              color: Color(0x3d000000),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(LayoutUtil.auto(20))),
                    color: Colors.white,
                  ),
                  width: LayoutUtil.auto(600),
                  height: LayoutUtil.auto(370),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: LayoutUtil.auto(90),
                      ),
                      Text(
                        "是否要退出当前帐号？",
                        style: TextStyle(fontSize: LayoutUtil.setSp(26)),
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(90),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              AppNavigator.back(context);
                            },
                            child: Container(
                                child: Container(
                                  width: LayoutUtil.auto(200),
                                  height: LayoutUtil.auto(76),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xffECECEC),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              LayoutUtil.auto(40)))),
                                  child: Text(
                                    '不退出',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: LayoutUtil.setSp(28),
                                        color: Color(0xff000000)),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: LayoutUtil.auto(20),
                          ),
                          InkWell(
                            onTap: () {
                              SpUtil.remove("user");
                              SpUtil.remove("token");
                              eventBus.emit("refresh","");
                              AppNavigator.back(context);
                            },
                            child: Container(
                                child: Container(
                                  width: LayoutUtil.auto(200),
                                  height: LayoutUtil.auto(76),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              LayoutUtil.auto(40)))),
                                  child: Text(
                                    '退出',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: LayoutUtil.setSp(28),
                                        color: Colors.white),
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
