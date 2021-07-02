import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil{


 Future<String> getLocalPath(BuildContext context) async {
   // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
   // 如果是android，使用getExternalStorageDirectory
   // 如果是iOS，使用getApplicationSupportDirectory
   final directory = Theme.of(context).platform == TargetPlatform.android
       ? await getExternalStorageDirectory()
       : await getApplicationSupportDirectory();
   return directory.path;
 }

 Future<bool> checkWriteFilePermission(BuildContext context) async {
   // 先对所在平台进行判断
   if (Theme.of(context).platform == TargetPlatform.android) {
     PermissionStatus permission = await PermissionHandler()
         .checkPermissionStatus(PermissionGroup.storage);
     if (permission != PermissionStatus.granted) {
       Map<PermissionGroup, PermissionStatus> permissions =
           await PermissionHandler()
           .requestPermissions([PermissionGroup.storage]);
       if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
         return true;
       }
     } else {
       return true;
     }
   } else {
     return true;
   }
   return false;
 }

 Future<bool> checkCameraPermission(BuildContext context) async {
   // 先对所在平台进行判断
   if (Theme.of(context).platform == TargetPlatform.android) {
     PermissionStatus permission = await PermissionHandler()
         .checkPermissionStatus(PermissionGroup.camera);
     if (permission != PermissionStatus.granted) {
       Map<PermissionGroup, PermissionStatus> permissions =
       await PermissionHandler()
           .requestPermissions([PermissionGroup.camera]);
       if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
         return true;
       }
     } else {
       return true;
     }
   } else {
     return true;
   }
   return false;
 }

}