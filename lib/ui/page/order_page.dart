import 'dart:async';

import 'package:app/data/code.dart';
import 'package:app/data/repository.dart';
import 'package:app/entity/order_entity.dart';
import 'package:app/ui/widget/order_item.dart';
import 'package:app/util/layout_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool loading = false;
  List<OrderEntity> oes = [];

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

  void onload() {
    showLoading();
    Repository().orderList().then((value) {
      hideLoading();
      if (value["code"] == Code.SUCCESS) {

        List<OrderEntity> os = [];

        List data = value["data"];
        for(int i = 0;i<data.length;i++){
          os.add(OrderEntity.fromJson(data[i]));
        }

        setState(() {
          oes = os;
        });

      } else {
        ToastUtil.show(value["message"]);
      }
    }).catchError((err) {
      hideLoading();
      ToastUtil.show(err);
    });
  }

  List<Widget> buildList(){
    List<Widget> list = [];
    for(int i = 0;i<oes.length;i++){
      list.add(OrderItem(oe: oes[i],));
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "订单中心",
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
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            color: Color(0xfffafafa),
            child: oes.length>0 ? ListView(
              children: buildList(),
            ) : Column(
              children: <Widget>[
                SizedBox(height: LayoutUtil.auto(150),),
                Container(
                  width: LayoutUtil.auto(300),
                  height: LayoutUtil.auto(300),
                  child: Image.asset("./assets/image/none.png",fit: BoxFit.fill,),
                ),
                SizedBox(height: LayoutUtil.auto(50),),
                Text("暂无订单",style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    onload();
  }
}
