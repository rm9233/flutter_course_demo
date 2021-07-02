import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:app/util/layout_util.dart';

class CodeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int coldDownSeconds;

  CodeButton({@required this.onPressed, @required this.coldDownSeconds});

  @override
  Widget build(BuildContext context) {
    if (coldDownSeconds!=null && coldDownSeconds > 0) {
      return Container(
        height: 45,
        width: LayoutUtil.auto(180),
        child: Center(
          child: Text(
            '${coldDownSeconds}s',
            style: TextStyle(fontSize: LayoutUtil.setSp(28), color: Colors.grey),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          width: LayoutUtil.auto(180),
          child: Text('发送验证码',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: LayoutUtil.setSp(28),
                  fontWeight: FontWeight.normal,
                  color: Colors.green)),
        ),
      ),
    );
  }
}
