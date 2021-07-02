import 'package:fluttertoast/fluttertoast.dart';
class ToastUtil {
  static int times = 0;
  static String msg;
  static show(String msg) {

    int now = new DateTime.now().millisecondsSinceEpoch;

    if(ToastUtil.msg == msg && now - ToastUtil.times < 2000 && ToastUtil.times != 0){
      return;
    }

    ToastUtil.msg = msg;
    ToastUtil.times = new DateTime.now().millisecondsSinceEpoch;
    Fluttertoast.showToast(msg: msg);
  }

  static void cancel() {
  }
}
