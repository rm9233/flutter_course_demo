import 'package:app/data/result_data.dart';
import 'package:dio/dio.dart';

import 'code.dart';


class ResponseInterceptors extends InterceptorsWrapper {

  final Dio _dio;

  ResponseInterceptors(this._dio);

//  @override
//  Future onResponse(Response response) {
//
//    //return response;
//  }

//  @override
//  onResponse(Response response) {
//    RequestOptions option = response.request;
//    if(response.statusCode == 200){
//
//      //
//    }
//
//    return new ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
//
////    try {
////      if (option.contentType != null && option.contentType.primaryType == "text") {
////        return new ResultData(response.data, true, Code.SUCCESS);
////      }
////      if (response.statusCode == 200 || response.statusCode == 201) {
////        return new ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
////      }
////    } catch (e) {
////      print(e.toString() + option.path);
////      return new ResultData(response.data, false, response.statusCode, headers: response.headers);
////    }
//  }
}