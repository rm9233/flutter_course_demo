import 'dart:io';

import 'package:app/common/config.dart';
import 'package:app/data/code.dart';
import 'package:app/data/error_interceptor.dart';
import 'package:app/data/result_data.dart';
import 'package:app/util/sp_util.dart';
import 'package:app/util/toast_util.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

import 'log_util.dart';



/// <BaseResp<T> 返回 status code msg data.
class BaseResp<T> {
  String status;
  int code;
  String msg;
  T data;

  BaseResp(this.status, this.code, this.msg, this.data);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"status\":\"$status\"");
    sb.write(",\"code\":$code");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}

class DioUtil {
  /// global dio object
  static Dio dio;



  static const String API_PREFIX = HOST;
  static const int CONNECT_TIMEOUT = 5000;
  static const int RECEIVE_TIMEOUT = 20000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static request(String url, {data, method, noTip = false}) async {
    data = data ?? {};
    method = method ?? 'GET';
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + url + '】');
    print('请求参数：' + data.toString());
    Dio dio = createInstance();
    var result;

    try {
      SpUtil.getInstance();
      var token = SpUtil.getString('token');
      if (token != "") {
        dio.options.headers['Authorization'] = token;
      }
      if (Platform.isAndroid) {
        dio.options.headers['Client-Type'] = 'android';
      } else {
        dio.options.headers['Client-Type'] = 'ios';
      }
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Content-Type'] ='application/json';
      print(dio.options.headers);
      Response response = await dio.request(url,
          data: data, options: new Options(method: method));
      result = response.data;
      print('new DateTime.now() ===${API_PREFIX}');
      if(result['code']==403){
        Code.errorHandleFunction(Code.INVALID_ERROR, result['message'], false);
      }
      /// 打印响应相关信息
      print('响应数据：' + response.toString());
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print('链接不上网络');
        return new ResultData(
            Code.errorHandleFunction(Code.NETWORK_ERROR, '网络连接错误', false),
            false,
            Code.NETWORK_ERROR);
      } else {
        print('请求出错：' + e.toString());
        Response errorResponse;
        var errRes;
        if (e.response != null) {
          errorResponse = e.response;
          errRes = errorResponse;
        } else {
//          if (e.type == DioErrorType.CONNECT_TIMEOUT ||
//              e.type == DioErrorType.RECEIVE_TIMEOUT) {
//            errRes = Code.NETWORK_TIMEOUT;
//            if (errorResponse == null) {
//              errorResponse.statusCode = 100;
//            }
//          }
        }

        return new ResultData(
            Code.errorHandleFunction(errRes, e.message, noTip),
            false,
            errorResponse.statusCode);
      }
    }

    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: API_PREFIX,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = new Dio(options);

      dio.interceptors.add(InterceptorsWrapper(
//          onResponse: (Response response){
//            if(response.statusCode == 200){
//              var data = response.data;
//              if(data["code"] == 403){
//                SpUtil.remove("token");
//                SpUtil.remove("user");
//                response.data["message"] = "登录超时,请从新登录..";
//              }
//            }
//            return response;
//          }
      ));

    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }


}
