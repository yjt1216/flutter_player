
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_player/components/app_update/update_head.dart';
import 'package:flutter_player/components/app_update/update_instr.dart';

import 'package:flutter_player/utils/log.dart';
import 'package:flutter_player/utils/permission_util.dart';
import 'package:flutter_player/utils/toast_util.dart';
import 'package:ota_update/ota_update.dart';
import 'package:url_launcher/url_launcher.dart';



/// 更新APP组件
///
class UpdateAppVersion extends StatefulWidget {
  const UpdateAppVersion({
    required this.version,
    this.info,
    required this.iosUrl,
    required this.androidUrl,
    this.filename,
  });

  /// APP版本号
  final String version;

  /// 更新内容介绍
  final List<String>? info;

  /// app下载后存储文件的名称
  final String? filename;

  /// IOS应用更新地址
  final String iosUrl;

  /// 安卓apk下载地址
  final String androidUrl;

  @override
  _UpdateAppVersionState createState() => _UpdateAppVersionState();
}

class _UpdateAppVersionState extends State<UpdateAppVersion> {
  final double widthWrap = 300;
  bool downloadFlag = false; // 是否正在下载
  double downAppProgress = 0;
  String? appVersion; // 最新版本号

  @override
  void initState() {
    super.initState();
    appVersion = widget.version;
  }

  /// APP版本更新
  void _updateVersion() async {
    if (Platform.isIOS) {
      String url = widget.iosUrl; // ios应用商店地址
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (Platform.isAndroid) {
      LogUtil.d('66 安卓apk下载地址 ${widget.androidUrl}');

      // 安卓apk下载地址
      String url = widget.androidUrl;
      try {
        OtaUpdate()
            .execute(url, destinationFilename: widget.filename ?? 'nurseTraining.apk')
            .listen(
              (OtaEvent event) {
            switch (event.status) {
              case OtaStatus.DOWNLOADING: // 下载中
                setState(() {
                  //LogUtil.d('78 OtaStatus.DOWNLOADING');
                  downAppProgress = double.parse(event.value.toString());
                });
                break;
              case OtaStatus.INSTALLING: //安装中
                setState(() {
                  LogUtil.d('84 OtaStatus.INSTALLING $event');
                  downAppProgress = 100;
                });
                Navigator.pop(context);
                break;
              case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
                LogUtil.d('90 OtaStatus.PERMISSION_NOT_GRANTED_ERROR');
                ToastUtil.show('更新失败，请稍后再试');
                PermissionRequestUtil.storagePerm(); // 权限申请
                break;
              default:
            }
          },
        );
      } catch (e) {
        LogUtil.d('99 更新失败，请稍后再试');
      }
    }
  }

  void _updateVersionTest() async {
    if (Platform.isIOS) {
      String url = widget.iosUrl; // ios应用商店地址
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (Platform.isAndroid) {
      LogUtil.d('66 安卓apk下载地址 ${widget.androidUrl}');

      // 安卓apk下载地址
      String url = widget.androidUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.transparent,
      child: Column(

        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
            children: <Widget>[
              const Text(
                '发现新版本',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 3, top: 6),
                child: const Text(
                  '1.0.0', // 最新版本号
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          UpdateInstr(data: widget.info!), // 更新内容
          bottomW(),
        ],
      ),
    );
  }

  /// 底部组件
  Widget bottomW() {
    Widget _child = upAppBtn();

    if (downloadFlag) {
      // 下载中，进度条
      _child = downProgressWidget();
    }

    return Container(
      width: double.infinity,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_child],
      ),
    );
  }

  /// 进度条
  Widget downProgressWidget() {
    const double progWidth = 20;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: 180,
      child: PhysicalModel(
        color: Colors.transparent,
        // elevation: 2,
        borderRadius: BorderRadius.circular(8), // 裁剪圆度
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: progWidth,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: progWidth,
                child: LinearProgressIndicator(
                  value: downAppProgress / 100, // 加载进度
                  valueColor: const AlwaysStoppedAnimation(Color(0xff009FF9)),
                  backgroundColor: Colors.black12,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  downAppProgress > 0 ? '下载进度:$downAppProgress%' : '准备下载中...',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 底部升级按钮
  Widget upAppBtn() {
    return SizedBox(
      width: 150,
      height: 45,
      child: RaisedButton(
        child: const Text(
          '立即升级',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        color: const Color(0xff009FF9),
        onPressed: () {
           _updateVersion(); // 版本检查及升级
          // _updateVersionTest();
          setState(() {
            downloadFlag = true;
          });
        },
      ),
    );
  }
}





