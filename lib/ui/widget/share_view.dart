import 'package:app/ui/widget/verify_dialog.dart';
import 'package:app/util/layout_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ShareView extends StatefulWidget {
  @override
  _ShareViewState createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  @override
  Widget build(BuildContext context) {
          return LayoutUtil.islarge  ? Container() : Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: LayoutUtil.auto(333),
                                      height: LayoutUtil.auto(180),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: LayoutUtil.auto(30)),
                                      decoration: BoxDecoration(
                                          color: Color(0xffffe9da),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  LayoutUtil.auto(30)))),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: LayoutUtil.auto(30),
                                          ),
                                          Text(
                                            "推荐好友得好礼",
                                            style: TextStyle(
                                                fontSize: LayoutUtil.setSp(32),
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff94480d)),
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "去推荐",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            color: Color(0xfff2824f),
                                            highlightColor: Color(0xfff38f4f),
                                            splashColor: Colors.transparent,
                                            onPressed: () {},
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: LayoutUtil.auto(-100),
                                      bottom: LayoutUtil.auto(-50),
                                      child: Opacity(
                                        opacity: .08,
                                        child: Container(
                                          width: LayoutUtil.auto(250),
                                          height: LayoutUtil.auto(250),
                                          child: Image.asset(
                                            "./assets/image/user-diamond-bigger.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: LayoutUtil.auto(333),
                                      height: LayoutUtil.auto(180),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: LayoutUtil.auto(30)),
                                      decoration: BoxDecoration(
                                          color: Color(0xfffcedcc),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  LayoutUtil.auto(30)))),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: LayoutUtil.auto(30),
                                          ),
                                          Text(
                                            "月月分享得金币",
                                            style: TextStyle(
                                                fontSize: LayoutUtil.setSp(32),
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff94480d)),
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "去分享",
                                              style: TextStyle(
                                                  color: Color(0xfffda655)),
                                            ),
                                            color: Color(0xfffcedcc),
                                            highlightColor: Color(0xfffaebca),
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              showCupertinoDialog(context: context, builder: (context) {
                                                return VerifyDialog((){});
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color: Color(0xfff8b974))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: LayoutUtil.auto(-100),
                                      bottom: LayoutUtil.auto(-70),
                                      child: Opacity(
                                        opacity: .1,
                                        child: Container(
                                          width: LayoutUtil.auto(250),
                                          height: LayoutUtil.auto(250),
                                          child: Image.asset(
                                            "./assets/image/user-money-bigger.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
  }
}
