import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';

class SettingItem extends StatefulWidget {

  final Image icon;
  final Function onTap;
  final String title;

  const SettingItem({Key key, this.icon, this.onTap, this.title}) : super(key: key);

  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:  LayoutUtil.auto(30),),
      height:LayoutUtil.auto(110),
      child: InkWell(
        onTap: (){widget.onTap();},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(width: LayoutUtil.auto(38),height: LayoutUtil.auto(38), child: widget.icon,),
                SizedBox(width: LayoutUtil.auto(36),),
                Text(widget.title,style: TextStyle(fontSize: LayoutUtil.setSp(32),fontWeight: FontWeight.w300),),
              ],
            ),
            Container(width: LayoutUtil.auto(38),height: LayoutUtil.auto(38), child: Image.asset("./assets/image/arrow-right-bold.png")),
          ],
        ),
      ),
    );
  }
}
