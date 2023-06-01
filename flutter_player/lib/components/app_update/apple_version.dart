
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_player/components/app_update/update_app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_player/utils/log.dart';
import 'package:flutter_player/utils/permission_util.dart';
import 'package:flutter_player/utils/toast_util.dart';






bool _showFlag = false;

//60 * 60 * 12
//fromPage 调用app更新方法的页面  home 默认false  关于界面-版本更新ture
//
Future getAppleNewAppVer(
    { bool forceUpdate = false,required BuildContext context,required String downloadUrl, bool fromPage = false}) async {
  int seconds = 60 * 60 * 12;

  if (!(await PermissionRequestUtil.storagePerm())) return; // 权限申请
  try {
    if (_showFlag) return;
    const String spKey = 'checkAppVerTime'; // 缓存key
    DateTime newTime =  DateTime.now(); // 当前时间

    String oldTimeStr = SpUtil.getString(
        spKey,
        defValue: DateTime.now().add(const Duration(days: -10)).toString())
        ??DateTime.now().add(const Duration(days: -10)).toString();


    DateTime oldTime = DateTime.parse(oldTimeStr);
    Duration diffTime = newTime.difference(oldTime);
    // 指定时间内不在触发检查更新APP
    if (!forceUpdate) {
      if (diffTime.inSeconds < seconds) {
        _showFlag = false;
        return;
      }
    }

    // TODO:获取最新APP版本, 自定义getNewVersion接口获取
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map resData = await getAppStoreVersionInfo();

    LogUtil.d('62 Apple当前版本verList---- ${resData['version']}');

    // APP版本号对比检查
    if (!CheckVersion.isNewVersion(packageInfo.version,resData['version'])) {
      if(fromPage){
        ToastUtil.show('已经是最新版本！');
      }
      return;
    };


    _showFlag = true;
    // 弹层更新
    showGeneralDialog(
      //context: commonConfig.getGlobalContext,
      context: context,
      barrierDismissible: true, // 是否点击其他区域消失
      barrierLabel: "",
      barrierColor: Colors.black54, // 遮罩层背景色
      transitionDuration: const Duration(milliseconds: 150), // 弹出的过渡时长
      transitionBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        // 显示的动画组件
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent, // 背景颜色
          child: UpdateAppVersion(
            // TODO: 传入新版本APP相关参数、版本号、更新内容、下载地址等
            version: resData['version'] ?? '', // 版本号
            info: (resData['info'] as List).cast<String>() , // 更新内容介绍
            // ios是苹果应用商店地址
            // https://apps.apple.com/cn/app/%E5%BE%B7%E5%93%81%E5%BE%AE%E6%8A%A4%E6%8A%A4%E5%A3%AB%E7%AB%AF/id1490788981?uo=4
            // itms-apps://apps.apple.com/cn/app/%E5%BE%B7%E5%93%81%E5%BE%AE%E6%8A%A4%E6%8A%A4%E5%A3%AB%E7%AB%AF/id1490788981?uo=4
            iosUrl: resData['trackViewUrl'],
            androidUrl: downloadUrl,
          ),
        );
      },
    ).then((v) {
      _showFlag = false;
    });


    await SpUtil.putString(spKey, newTime.toString());
  } catch (e) {
    _showFlag = false;
  }
}

///校验版本 需要更新true  不需要更新false
class CheckVersion {
  static bool isNew = false;//默认不许更新
  static isNewVersion(currentVersion, newVersion) {
    List currentList = currentVersion.split('.'); //当前版本
    List newVerList = newVersion.split('.'); //最新版本
    LogUtil.d('104 当前版本verList---- $currentList');
    LogUtil.d('105 最新版本newVerList---- $newVerList');


    if (int.parse(newVerList[0]) > int.parse(currentList[0])) {
      isNew = true;
    } else if (int.parse(newVerList[0]) == int.parse(currentList[0])) {
      if (int.parse(newVerList[1]) > int.parse(currentList[1])) {
        isNew = true;
      } else if (int.parse(newVerList[1]) == int.parse(currentList[1])) {
        if (int.parse(newVerList[2]) > int.parse(currentList[2])) {
          isNew = true;
        }else{
          isNew = false;
        }
      }
    }else{
      isNew = false;
    }
    LogUtil.d('136 apple 是否需要更新版本 ---- $isNew');
    return isNew;
  }
}



/// 获取iOS 中 app 版本信息
/// https://itunes.apple.com/cn/lookup?bundleId=com.depin.www.cultivate
/// https://itunes.apple.com/cn/lookup?id=1543360651
Future<Map> getAppStoreVersionInfo() async {

  String getAppVersionApi = 'https://itunes.apple.com/cn/lookup?bundleId=com.depin.www.cultivate';

  try {
    var response = await Dio().get(getAppVersionApi);

    Map jsonData = jsonDecode(response.data);

    List appInfoData = jsonData['results'];

    Map appInfo = appInfoData[0];
    LogUtil.d('145 ios appInfo ---- $appInfo');

    Map resData = {
      "code": "0",
      "message": "success",
      "data": {
        "version": appInfo['version'].toString(),
        "info": [appInfo['releaseNotes']],
        'trackViewUrl':appInfo['trackViewUrl'],
      }
    };
    // print('ios resData ---- $resData');

    return resData['data'] ?? {};
  } catch (e) {
    print(e);
    return {};
  }

}

//app 在app store 地址link
//"trackViewUrl"
// :"https://apps.apple.com/cn/app/%E6%8A%A4%E7%90%86%E5%9F%B9%E8%AE%AD%E6%95%99%E8%82%B2%E7%B3%BB%E7%BB%9F/id1543360651?uo=4",


