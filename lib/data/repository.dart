import 'package:app/util/dio_util.dart';
import 'api.dart';
class Repository {

  Future<dynamic> splash() async {
    var result = await DioUtil.request(
        API.SPLASH,
        method: DioUtil.GET,
        noTip: false);
    return result;
  }



  Future<dynamic> userInfo() async {
    var result = await DioUtil.request(
        API.USER_INFO,
        method: DioUtil.GET,
        noTip: false);
    return result;
  }


  Future<dynamic> login(params) async {
    var result = await DioUtil.request(
        API.LOGIN,
        method: DioUtil.POST,
        data: params,
        noTip: false);
    return result;
  }

  Future<dynamic> updateUser(params) async {
    var result = await DioUtil.request(
        API.UPDATE_USER,
        method: DioUtil.POST,
        data: params,
        noTip: false);
    return result;
  }




  Future<dynamic> sts() async {
    var result = await DioUtil.request(
        API.OSS,
        method: DioUtil.GET,
        noTip: false);
    return result;
  }


  Future<dynamic> orderList() async {
    var result = await DioUtil.request(
        API.MY_ORDER_LIST,
        method: DioUtil.GET,
        noTip: false);
    return result;
  }

  Future<dynamic> courseList() async {
    var result = await DioUtil.request(
        API.COURSE_LIST,
        method: DioUtil.GET,
        noTip: false);
    return result;
  }


  Future<dynamic> unitList(int videoId) async {
    var result = await DioUtil.request(
        API.UNIT_LIST+videoId.toString(),
        method: DioUtil.GET,
        noTip: false);
    return result;
  }

  Future<dynamic> scriptList(int unitId) async {
    var result = await DioUtil.request(
        API.SCRIPT_LIST+unitId.toString(),
        method: DioUtil.GET,
        noTip: false);
    return result;
  }

  Future<dynamic> productList() async {
    var result = await DioUtil.request(
        API.PRODUCT_LIST,
        method: DioUtil.GET,
        noTip: false);
    return result;
  }





//  Future<dynamic> sendMsg(params) async {
//    var result = await DioUtil.request(
//        API.SEND_MSG,
//        method: DioUtil.POST,
//        data: params,
//        noTip: false);
//    return result;
//  }
}
