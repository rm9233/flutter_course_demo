import 'package:app/app/app_navigator.dart';
import 'package:app/entity/unit_entity.dart';
import 'package:app/util/layout_util.dart';
import 'package:flutter/material.dart';
class UnitItem extends StatefulWidget {

  final int index;
  final int length;
  final UnitEntity ue;

  const UnitItem({Key key, this.index, this.length,this.ue}) : super(key: key);

  @override
  _UnitItemState createState() => _UnitItemState();
}

class _UnitItemState extends State<UnitItem> {

  String typeUri(){
    String uri = "./assets/image/unit-type1.png";
    switch(widget.ue.type){
      case 0:
        //视频
        uri = "./assets/image/unit-type2.png";
        break;
      case 1:
        uri = "./assets/image/unit-type3.png";
        break;
      case 2:
        uri = "./assets/image/unit-type1.png";
        break;
    }
    return uri;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: LayoutUtil.auto(170),
          width:  LayoutUtil.auto(100),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              widget.index == 0 || widget.index+1 != widget.length ? Positioned(
                bottom: 0,
                child:Container(
                width:  LayoutUtil.auto(4),
                height:  LayoutUtil.auto(widget.index == 0  ?  170 / 2 : 170),
                color: Color(0xffdfdfdf),
                ),
              ) : Positioned(
                top: 0,
                child:Container(
                  width:  LayoutUtil.auto(4),
                  height:  LayoutUtil.auto(170 / 2),
                  color: Color(0xffdfdfdf),
                ),
              ),
              Positioned(
                  top: LayoutUtil.auto(50),
                  child: Container(
                    color: Colors.white,
                    height: LayoutUtil.auto(70),
                    width: LayoutUtil.auto(70),
                    padding: EdgeInsets.all(LayoutUtil.auto(20)),
                    child: CircularProgressIndicator(
                      strokeWidth: LayoutUtil.auto(12),
                      backgroundColor:  Color(0xffdfdfdf),
                      value: 0.0,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  )
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(LayoutUtil.auto(15)),
          child: InkWell(
            onTap: (){
              if (widget.ue.type == 0) {
//                AppNavigator.gotoPicPage(context, widget.ue,true);
              } else if (widget.ue.type == 1) {
                AppNavigator.gotoPlayerPage(context, widget.ue,true);
              } else if (widget.ue.type == 2) {
                AppNavigator.gotoGamePage(context, widget.ue);
              } else if (widget.ue.type == 3) {
//                AppNavigator.gotoCallPage(context, widget.ue,true);
              } else if (widget.ue.type == 4) {
//                AppNavigator.gotoPicPage(context, widget.ue,true);
              }

            },
            child: Container(
              width: LayoutUtil.auto(560),
              padding: EdgeInsets.all(LayoutUtil.auto(30)),
              decoration: BoxDecoration(
                  color: Color(0xfff0f5f0),
                  borderRadius: BorderRadius.all(Radius.circular(LayoutUtil.auto(30)))
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset(typeUri()),
                    width: LayoutUtil.auto(80),
                  ),
                  SizedBox(width: LayoutUtil.auto(30),),
                  widget.ue!=null && widget.ue.title !="" ? Text(widget.ue.title.toString(),style: TextStyle(fontWeight: FontWeight.w600),) : Container(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.ue.toString());
  }
}
