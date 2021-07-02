import 'package:app/data/result_data.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

import 'code.dart';

///是否需要弹提示
const NOT_TIP_KEY = "noTip";

/**
 * 错误拦截
 */
class ErrorInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  ErrorInterceptors(this._dio);

//  @override
//  onRequest(RequestOptions options) async {
//    //没有网络
//    var connectivityResult = await (new Connectivity().checkConnectivity());
//    if (connectivityResult == ConnectivityResult.none) {
//      print('链接不上网络');
//      return _dio.resolve(new ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, "", false), false, Code.NETWORK_ERROR));
//    }
//    return options;
//  }

}
