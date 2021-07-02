import 'package:app/entity/order_entity.dart';
import 'package:app/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';

class OrderItem extends StatefulWidget {
  final OrderEntity oe;

  const OrderItem({Key key, this.oe}) : super(key: key);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  bool isShowInfo = false;

  String payStatus(int payStatus){
    switch(widget.oe.payStatus){
      case 0:
        return "未支付";
        break;
      case 1:
        return "支付成功";
        break;
      case 2:
        return "支付失败";
        break;
      default:
        return "未知";
        break;
    }
  }
  String courseInfo(){
    String info = "";
    for(int i = 0;i<widget.oe.courses.length;i++){
      info+= "<"+widget.oe.courses[i].title+">  ";
    }
    return info;
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: ScreenUtil().screenWidth,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: LayoutUtil.auto(20)),
      padding: EdgeInsets.symmetric(vertical: LayoutUtil.auto(20),horizontal:LayoutUtil.auto(20) ),
      child: Column(
        children: <Widget>[
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: LayoutUtil.auto(160),
                      height: LayoutUtil.auto(160),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.circular(
                                  LayoutUtil.auto(20))),
                          image: DecorationImage(
                              image: widget.oe.avator != null ? NetworkImage(widget.oe.avator) : AssetImage("./assets/image/defalut.png"),
                              fit: BoxFit.fill)
                      )
                    ),
                    SizedBox(width: LayoutUtil.auto(30),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: LayoutUtil.auto(5),),
                        Text(widget.oe.title,style: TextStyle(fontSize: LayoutUtil.setSp(38)),),
                        SizedBox(height: LayoutUtil.auto(20),),
                        Text("订单号:"+widget.oe.order_number,style: TextStyle(fontSize: LayoutUtil.setSp(28),color: Color(0xff999999)),),
                        Text("下单时间:"+DateUtil.formatted(widget.oe.createAt, "yyyy-MM-dd hh:mm:ss"),style: TextStyle(fontSize: LayoutUtil.setSp(28),color: Color(0xff999999)),),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: LayoutUtil.auto(50),
                  child: widget.oe.payStatus == 1 ? Image.asset("./assets/image/success.png") : Container(),
                ),

              ],
            ),
            onTap: (){
              setState(() {
                isShowInfo = !isShowInfo;
              });
            },
          ),
          isShowInfo ? Container(
            padding: EdgeInsets.only(left:LayoutUtil.auto(190),top: LayoutUtil.auto(30),),
            width: ScreenUtil().screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("支付状态："+payStatus(widget.oe.payStatus) ,style: TextStyle(fontSize: LayoutUtil.setSp(28),color: Color(0xff999999)),),
                Text("金额：￥ "+ widget.oe.money.toString(),style: TextStyle(fontSize: LayoutUtil.setSp(28),color: Color(0xff999999)),),
                widget.oe.payStatus == 1 ? Text("付款时间:"+DateUtil.formatted(widget.oe.payAt, "yyyy-MM-dd hh:mm:ss"),style: TextStyle(fontSize: LayoutUtil.setSp(28),color: Color(0xff999999)),) : Container(),
                Text("开通课程: " + courseInfo(),style: TextStyle(fontSize: LayoutUtil.setSp(28),color: Color(0xff999999)),),
              ],
            ),
          ) : Container()
        ],
      )
    );
  }
}
