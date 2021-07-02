import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';

class MoneyView extends StatefulWidget {

  final Color color;
  final int num;
  final Image icon;

  const MoneyView({Key key, this.color, this.num, this.icon}) : super(key: key);


  @override
  _MoneyViewState createState() => _MoneyViewState();
}

class _MoneyViewState extends State<MoneyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: LayoutUtil.auto(10),right: LayoutUtil.auto(20)),
      height: LayoutUtil.auto(40),
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(LayoutUtil.auto(20)))
      ),
      child: Row(
        children: <Widget>[
          widget.icon,
          SizedBox(width: LayoutUtil.auto(10),),
          Text(widget.num.toString(),style: TextStyle(fontSize: LayoutUtil.setSp(24),color: Color(0xfff08b5d),fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }
}
