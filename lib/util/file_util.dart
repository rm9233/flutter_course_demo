import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil{

  /*获取存储路径*/
  static Future<String> getLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if(Platform.isIOS){
      return directory.path+"/superkids";
    }else{
      int index = directory.path.indexOf("/Android");
      if(index!=-1){
        return directory.path.substring(0,index) + "/superkids";
      }
      return directory.path+"/superkids";
    }
  }

}