import 'package:app/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';
class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  TextEditingController codeEditer = TextEditingController();
  FocusNode _nodeText1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "优惠券",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              height: ScreenUtil().screenHeight,
              color: Color(0xfff6f6f6),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: LayoutUtil.auto(30),
                    vertical: LayoutUtil.auto(20)),
                child: InkWell(
                  onTap: () {
                    _nodeText1.unfocus();
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: LayoutUtil.auto(540),
                            height: LayoutUtil.auto(50),
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: TextField(
                              focusNode: _nodeText1,
                              controller: codeEditer,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: LayoutUtil.setSp(28),
                                  color: Colors.grey),
                              maxLength: 16,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp("[0-9a-zA-Z]")),
                                LengthLimitingTextInputFormatter(16),
                              ],
                              decoration: InputDecoration(
                                hintText: '请输入兑换码',
                                counterText: "",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: LayoutUtil.auto(20)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: LayoutUtil.auto(30),
                          ),
                          Container(
                            width: LayoutUtil.auto(120),
                            height: LayoutUtil.auto(50),
                            child: FlatButton(
                              onPressed: () {
                                _nodeText1.unfocus();
                                ToastUtil.show("暂无此兑换码..");
                              },
                              color: Color(0xffe7e7e7),
                              highlightColor: Color(0xffe7e7e7),
                              splashColor: Color(0xffe7e7e7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      LayoutUtil.auto(10))),
                              child: Text(
                                "兑换",
                                style: TextStyle(color: Color(0xff999999)),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(380),
                      ),
                      Container(
                        child: Image.asset("./assets/image/box.png"),
                        width: LayoutUtil.auto(168),
                      ),
                      SizedBox(
                        height: LayoutUtil.auto(20),
                      ),
                      Text(
                        "--暂无可用优惠券--",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: LayoutUtil.setSp(28)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
