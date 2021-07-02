import 'package:intl/intl.dart';
//  dart 的时间格式处理
// https://cloud.tencent.com/developer/ask/38907
class DateUtil{

  static String formatBirthday(String str,int systemTime){
    String birthdayStr = "";
    if(str!=null && systemTime != null){
      // 当前时间  - 过去时间
      DateTime birthday = DateTime.parse(str).add(new Duration(hours: 8));
      DateTime now = DateTime.fromMillisecondsSinceEpoch(systemTime);
      Duration lost = now.difference(birthday);

      int year = (lost.inDays / 365).floor();
      int month = ((lost.inDays % 365) / 12).floor();

      if(year >0){
        birthdayStr = year.toString()+"岁";
      }
      birthdayStr +=  month.toString()+"个月";

      return birthdayStr;
    }
    return birthdayStr;
  }

  static String formatBirthday2(String str){
    String birthdayStr = "";
    if(str!=null){
      // 当前时间  - 过去时间
      DateTime birthday = DateTime.parse(str).add(new Duration(hours: 8));

      birthdayStr = birthday.year.toString()+"-"+birthday.month.toString()+"-"+birthday.day.toString();

      return birthdayStr;
    }
    return birthdayStr;
  }

  static String formatted(String date,String format){
    var now = DateTime.parse(date).add(new Duration(hours: 8));
    var formatter = new DateFormat(format);
    String formatted = formatter.format(now);
    return formatted;
  }

  static String week(String date,String format){
    var now = DateTime.parse(date).add(new Duration(hours: 8));
    var formatter = new DateFormat(format);
    String formatted = formatter.format(now);


    switch(formatted){
      case "Monday":
        formatted = "周一";
        break;
      case "Tuesday":
        formatted = "周二";
        break;
      case "Wednesday":
        formatted = "周三";
        break;
      case "Thursday":
        formatted = "周四";
        break;
      case "Friday":
        formatted = "周五";
        break;
      case "Saturday":
        formatted = "周六";
        break;
      case "Sunday":
        formatted = "周日";
        break;
    }
    //
    return formatted;
  }

  static String formatMin(Duration time) {

    int seconds = time.inSeconds;
    if(seconds == 0 ){
      return "00:00";
    }
    String s = "0" + ((seconds % 60).floor().toString());
    String m = "0" + ((seconds / 60).floor().toString());

    return  m.substring(m.length -2, m.length) + ":"+ s.substring(s.length -2, s.length);

  }
}