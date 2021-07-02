import 'dart:async';

import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/unit_entity.dart';
import 'package:app/ui/widget/unit_item.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
class UnitPage extends StatefulWidget {
  final int videoId;

  const UnitPage({Key key, this.videoId}) : super(key: key);
  @override
  _UnitPageState createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {

  bool loading = false;
  List<UnitEntity> ues = [];
  @override
  void initState() {
    super.initState();
    onload();
  }

  showLoading(){
    setState(() {
      loading = true;
    });
  }

  hideLoading(){
    Timer(Duration(milliseconds: 500),(){
      if(mounted){
        setState(() {
          loading = false;
        });
      }
    });
  }

  onload(){
    this.showLoading();
    Repository().unitList(widget.videoId).then((value){
      this.hideLoading();
      if(value['code'] == Code.SUCCESS){
        List data = value['data'];
        UnitEntity ue = new UnitEntity();
        List<UnitEntity> list = [];
        for(int i=0;i<data.length;i++){
          ue = UnitEntity.fromJson(data[i]);
          list.add(ue);
        }
        setState(() {
          ues = list;
        });
      }else{
        ToastUtil.show(value["message"]);
      }

    }).catchError((err){
      this.hideLoading();
      ToastUtil.show(err);
    });
  }


  List<Widget> buildList(){
    List<Widget> list = [];
    for(int i =0;i<ues.length;i++){
      list.add(UnitItem(index: i,length: ues.length,ue: ues[i],));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(LayoutUtil.auto(30)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: LayoutUtil.auto(120),
                        height: LayoutUtil.auto(160),
                        alignment: Alignment.center,
                        color: Color(0xffd1d1d1),
                        child: Center(
                          child: Image.asset("./assets/image/defalut.png"),
                        ),
                      ),
                      SizedBox(width: LayoutUtil.auto(30),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("毕加索的小画廊",style: TextStyle(fontSize: LayoutUtil.setSp(38),color: Colors.lightGreen)),
                          SizedBox(height: LayoutUtil.auto(20),),
                          Row(
                            children: <Widget>[
                              Container(child: Image.asset("./assets/image/caps-lock.png"),height: LayoutUtil.auto(24),),
                              SizedBox(width: LayoutUtil.auto(4),),
                              Text("共6个章节",style: TextStyle(fontSize: LayoutUtil.setSp(24),color: Color(0xff999999))),
                              SizedBox(width: LayoutUtil.auto(20),),
                              Container(child: Image.asset("./assets/image/chart-pie.png"),height: LayoutUtil.auto(24),),
                              SizedBox(width: LayoutUtil.auto(4),),
                              Text("已完成60%",style: TextStyle(fontSize: LayoutUtil.setSp(24),color: Color(0xff999999)))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(LayoutUtil.auto(30)),
                  child: Column(
                    children: buildList(),
                  ),
                ),
              ],
            ),
          )
        ));
  }


}
