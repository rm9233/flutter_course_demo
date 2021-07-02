import 'dart:async';

import 'package:app/app/app_navigator.dart';
import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/banner_entity.dart';
import 'package:app/entity/product_entity.dart';
import 'package:app/ui/widget/banner_view.dart';
import 'package:app/ui/widget/login_dialog.dart';
import 'package:app/ui/widget/logout_dialog.dart';
import 'package:app/ui/widget/verify_dialog.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<BannerEntity> bannerEntity = [];
  bool loading = false;

  void onCallBack() {}
  List result = [
    {"index":0,"name":"体验课","data":null},
    {"index":1,"name":"系统课","data":null},
  ];

  @override
  void initState() {
    super.initState();
    onload();
    setState(() {
      BannerEntity be = new BannerEntity(
          type: 0,
          url: "http://www.baidu.com",
          banner:
              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604939465071&di=660c1ffe9480b28ac0b90fbcdffec3f9&imgtype=0&src=http%3A%2F%2Fpic.qingting.fm%2Frecommend%2F2018%2F10%2F25%2F87308e7933f5e5182e1641bda4aca527.jpg%2521800");
      this.bannerEntity.add(be);
      this.bannerEntity.add(be);
      this.bannerEntity.add(be);
      this.bannerEntity.add(be);
    });
  }

  showLoading(){
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

  formatList(data,type){
    List list = [];
    for(int i =0;i<data.length;i++){
      ProductEntity pe = ProductEntity.fromJson(data[i]);
      if(pe.type == type){
        list.add(pe);
      }
    }
    return list;
  }

  onload() {
    showLoading();
    Repository().productList().then((value){
      hideLoading();
      if(value["code"] == Code.SUCCESS){
        List data = value["data"];
        setState(() {
          result[0]["data"] = formatList(data,0);
          result[1]["data"] = formatList(data,1);
        });
      }else{
        ToastUtil.show(value["message"]);
      }
    }).catchError((err){
      hideLoading();
      ToastUtil.show(err.toString());
    });
  }


  List<Widget> buildItem(type){
    List<Widget> list = [];
    List data = result[type]["data"];
    for(int i =0;data!=null && i<data.length;i++){
      ProductEntity pe = data[i];
      if(i==0){
        list.add( Text(
          result[type]["name"],
          style: TextStyle(
            fontSize: LayoutUtil.setSp(48),
            fontWeight: FontWeight.w500,
          ),
        ));
      }

      list.add(InkWell(
        onTap: (){
          AppNavigator.gotoWebViewPage(
              context, pe.title, "http://81.70.198.2/index.html?pid="+pe.id.toString());
        },
        child:  Container(
          height: LayoutUtil.auto(260),
          margin: EdgeInsets.only(top: LayoutUtil.auto(30)),
          padding: EdgeInsets.symmetric(
              horizontal: LayoutUtil.auto(30),
              vertical: LayoutUtil.auto(40)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(LayoutUtil.auto(10))),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffdfdfdf),
                  blurRadius: LayoutUtil.auto(10),
                  offset: Offset(
                      LayoutUtil.auto(5), LayoutUtil.auto(5)))
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                pe.title,
                style: TextStyle(
                    fontSize: LayoutUtil.setSp(36),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: LayoutUtil.auto(20),
              ),
              Text(
                pe.description!=null ? pe.description: "",
                style: TextStyle(
                  fontSize: LayoutUtil.setSp(20),
                  color: Color(0xff999999),
                ),
              ),
              SizedBox(
                height: LayoutUtil.auto(30),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(pe.money != null && pe.money>0 ? pe.money.toString() : "免费",
                      style: TextStyle(
                          fontSize: LayoutUtil.setSp(36),
                          fontWeight: FontWeight.w500,
                          color: Colors.deepOrange)),
                  SizedBox(
                    width: LayoutUtil.auto(10),
                  ),
                  Text(pe.showMoney != null && pe.showMoney>0 ? pe.showMoney.toString() : "",
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.dashed,
                          color:Color(0xff999999)))
                ],
              ),
            ],
          ),
        )
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        color: Colors.white,
        child: ModalProgressHUD(
          inAsyncCall: loading,
          color: Colors.black,
          progressIndicator:
              SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: LayoutUtil.auto(100),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: LayoutUtil.auto(30)),
                        child: Text(
                          "SUPER AI课",
                          style: TextStyle(
                              fontSize: LayoutUtil.setSp(46),
                              fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      height: LayoutUtil.auto(40),
                    ),
                    BannerView(entity: this.bannerEntity),
                    SizedBox(
                      height: LayoutUtil.auto(40),
                    ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: LayoutUtil.auto(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                AppNavigator.gotoWebViewPage(
                                    context, "测试", "http://www.baidu.com/");
                              },
                              child: Container(
//                        width: LayoutUtil.auto(330),
                                height: LayoutUtil.auto(90),
                                decoration: BoxDecoration(
                                    color: Color(0xfff7f8fa),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(LayoutUtil.auto(10)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          "./assets/image/layout-filling.png"),
                                      width: LayoutUtil.auto(60),
                                    ),
                                    SizedBox(width: LayoutUtil.auto(20)),
                                    Text(
                                      "如何上课",
                                      style: TextStyle(
                                          fontSize: LayoutUtil.setSp(28)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: LayoutUtil.auto(30),
                          ),
                          Expanded(
                              child: Container(
//                        width: LayoutUtil.auto(330),
                            height: LayoutUtil.auto(90),
                            decoration: BoxDecoration(
                                color: Color(0xfff7f8fa),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(LayoutUtil.auto(10)))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.asset(
                                      "./assets/image/comment-filling.png"),
                                  width: LayoutUtil.auto(60),
                                ),
                                SizedBox(width: LayoutUtil.auto(20)),
                                Text(
                                  "购课咨询",
                                  style:
                                      TextStyle(fontSize: LayoutUtil.setSp(28)),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: LayoutUtil.auto(70),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: LayoutUtil.auto(30),
                          right: LayoutUtil.auto(30),
                          bottom: LayoutUtil.auto(80)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildItem(0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: LayoutUtil.auto(30),
                          right: LayoutUtil.auto(30),
                          bottom: LayoutUtil.auto(80)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildItem(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
