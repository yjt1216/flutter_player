// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_player/bean/update_info_entity.dart';
import 'package:flutter_player/utils/toast_util.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:package_info_plus/package_info_plus.dart';

class XUpdatePage extends StatefulWidget {
  const XUpdatePage({Key? key}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<XUpdatePage> {
  final _updateUrl = "http://192.168.1.13:8101/api/admin/update";
  // final _updateUrl = "http://36.152.50.211:8089/api/admin/apk";

  late String version = "";
  late String buildNumber = "";
  String _customJson = '';
  String _message = '';

  @override
  void initState() {
    super.initState();

    loadJsonFromAsset();

    Future.delayed(
      Duration.zero,
      () => setState(
        () {
          initVersionInfo();
        },
      ),
    );
    initXUpdate();
  }

  Future<void> loadJsonFromAsset() async {
    _customJson = await rootBundle.loadString('assets/json/update_custom.json');
  }
  ///将自定义的json内容解析为UpdateEntity实体类
  UpdateEntity customParseJson(String jsonData) {
    Map<String ,dynamic> updateInfo =  json.decode(jsonData);
    UpdateInfoEntity appInfo = UpdateInfoEntity.fromJson(updateInfo);
    print(appInfo);
    return UpdateEntity(
        hasUpdate: appInfo.hasUpdate,
        isIgnorable: appInfo.isIgnorable,
        versionCode: appInfo.versionCode,
        versionName: appInfo.versionName,
        updateContent: appInfo.updateLog,
        downloadUrl: appInfo.apkUrl,
        apkSize: appInfo.apkSize);
  }
  ///直接传入UpdateEntity进行更新提示
  void checkUpdateByUpdateEntity() {
    FlutterXUpdate.updateByInfo(updateEntity: customParseJson(_customJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XUpdate演示'),
      ),
      body: Center(
        child: Column(
          children: [
            Text("version: $version"),
            Text("buildNumber: $buildNumber"),
            ElevatedButton(
              onPressed: () {
                FlutterXUpdate.checkUpdate(url: _updateUrl);
              },
              child: const Text('默认更新'),
            ),
            ElevatedButton(
              onPressed: checkUpdateByUpdateEntity,
              child: const Text('支持后台更新'),
            ),
          ],
        ),
      ),
    );
  }

  void initVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  //初始化XUpdate
  void initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(
              //是否输出日志
              debug: true,
              //是否使用post请求
              isPost: false,
              //post请求是否是上传json
              isPostJson: false,
              //请求响应超时时间
              timeout: 25000,
              //是否开启自动模式
              isWifiOnly: false,
              //是否开启自动模式
              isAutoMode: false,
              //需要设置的公共参数
              supportSilentInstall: false,
              //在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
              enableRetry: false)
          .then((value) {
        print("初始化成功: $value");
      }).catchError((error) {
        print(error);
      });

      // FlutterXUpdate.setErrorHandler(
      //     onUpdateError: (Map<String, dynamic>? message) async {
      //   print(message);
      // });
      FlutterXUpdate.setUpdateHandler(
        onUpdateError: (message) async{
          print('更新失败$message');
          //下载失败
          if (message!["code"] == 4000) {
            FlutterXUpdate.showRetryUpdateTipDialog(
                retryContent: 'Github被墙无法继续下载，是否考虑切换蒲公英下载？',
                retryUrl: 'https://www.pgyer.com/flutter_learn');
          }else if(message["code"] == 5000){
            ToastUtil.show('安装APK失败');
          }
          setState(() {
            _message = '$message';
          });
        }
      );




    } else {
      debugPrint("ios暂不支持XUpdate更新");
    }
  }
}
