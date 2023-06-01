
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionRequestUtil{
  static VoidCallback? callback ;


  static void checkPermission(List<Permission> permissions, {String? errorMsg,VoidCallback? onSuccess,VoidCallback? onFail,VoidCallback? onOpenSetting}) async{
    // bool flag = true;
    // for(var value in permissions){
    //   var status = await value.status;
    //   if(!status.isGranted){
    //     flag = false;
    //     break;
    //   }
    // }

    // if(!flag){
    //
    // }else{
    //   onSuccess !
    // }
    PermissionStatus permissionStatus = await requestPermission(permissions);

    if(permissionStatus.isGranted){///全部通过
      onSuccess != null ?onSuccess():callback;
    }else if(permissionStatus.isDenied){///部分通过
      onFail != null ? onFail():callback;
    }else if(permissionStatus.isPermanentlyDenied){///IOS单独处理
      onOpenSetting != null ? onOpenSetting():callback;
    }else if(permissionStatus.isLimited){///IOS单独处理
      onOpenSetting != null ? onOpenSetting():callback;
    }
  }


  static Future<PermissionStatus> requestPermission(List<Permission> permissions) async{
    Map<Permission,PermissionStatus> status = await permissions.request();
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    status.forEach((key, value) {
      if(!value.isGranted){
        currentPermissionStatus = value;
        return;
      }
    });
    return currentPermissionStatus;
  }

  /// 相册权限申请
  static Future<bool> cameraPerm() async {
    PermissionStatus status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      final statuses = await [Permission.camera].request(); // 请求权限
      return statuses[Permission.camera] == PermissionStatus.granted;
    }
    return true;
  }

  /// 基础权限申请
  static Future initPermissions() async {
    if (await Permission.contacts.request().isGranted) return;

    await [
      Permission.storage,
      Permission.camera,
    ].request();
  }

  /// 存储权限申请
  static Future<bool> storagePerm() async {
    PermissionStatus status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final statuses = await [Permission.storage].request();
      return statuses[Permission.storage] == PermissionStatus.granted;
    }
    return true;
  }


}