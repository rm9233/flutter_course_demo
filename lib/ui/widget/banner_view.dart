import 'package:app/entity/banner_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/util/layout_util.dart';

class BannerView extends StatefulWidget {

  final List<BannerEntity> entity;
  const BannerView({Key key, this.entity}) : super(key: key);

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {

  // var imgs = [
  //   "https://i1.mifile.cn/f/i/2019/micc9/summary/specs-02.png",
  //   "https://i1.mifile.cn/f/i/2019/micc9/summary/specs-03.png",
  //   "https://i1.mifile.cn/f/i/2019/micc9/summary/specs-04.png",
  //   "https://i1.mifile.cn/f/i/2019/micc9/summary/specs-05.png",
  //   "https://i1.mifile.cn/f/i/2019/micc9/summary/specs-06.png"
  // ];

  List<Widget> buildBanner(){
    List<Widget> banners = List<Widget>();
    for(int i = 0; i<widget.entity.length;i++){
      Widget banner = Container(
        padding: EdgeInsets.symmetric(horizontal: LayoutUtil.auto(30)),
        child: Container(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(borderRadius:BorderRadiusDirectional.circular(10)),
              image:  DecorationImage(image:NetworkImage("https://i1.mifile.cn/f/i/2019/micc9/summary/specs-02.png"),fit: BoxFit.fill)
          ),
        ),
      );
      banners.add(banner);
    }
    return banners;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: LayoutUtil.auto(280),
      child: Stack(
        children: <Widget>[
          PageView(
            children: buildBanner()

            //     <Widget>[
            //

            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: LayoutUtil.auto(30)),
            //     child: Container(
            //       decoration: ShapeDecoration(
            //           shape: RoundedRectangleBorder(borderRadius:BorderRadiusDirectional.circular(10)),
            //           image:  DecorationImage(image:NetworkImage(imgs[1]),fit: BoxFit.fill)
            //       ),
            //     ),
            //   ),
            // ],
          )
        ],
      ),
    );
  }
}
