import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_player/bean/app_version_entity.dart';
import 'package:flutter_player/components/app_update/android_version.dart';
import 'package:flutter_player/components/app_update/apple_version.dart';
import 'package:flutter_player/components/app_update/update_app.dart';
import 'package:flutter_player/http/dio_utils.dart';
import 'package:flutter_player/http/http_api.dart';
import 'package:flutter_player/pages/download_file/download_file.dart';
import 'package:flutter_player/pages/video/demo_superplayer.dart';
import 'package:flutter_player/pages/xupdate/view.dart';
import 'package:flutter_player/res/constant.dart';
import 'package:flutter_player/utils/log.dart';
import 'package:flutter_player/utils/toast_util.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';


// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('取消'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('确定'),
          onPressed: _submit,
        ),
      ],
    );
  }
}

// Implement a multi select on the Home screen
class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<String> _selectedItems = [];
  String _title = "坚果";
  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<String> _items = [
      'Flutter',
      'Node.js',
      'React Native',
      'Java',
      'Docker',
      'MySQL'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: _items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  ///检测版本更新
  void checkAppUpdateVersion(){

    LogUtil.d('50 app版本检测更新Api http://36.152.50.211:8089/api/admin/apk');

    if(Platform.isAndroid){
      getAndroidNewAppVer(
        forceUpdate: true,
        context: context,
        downloadUrl: 'http://36.152.50.211:8089/api/admin/apk',
        fromPage: true, // 不可以弹框提示用户 最新版本
      );
    }else{
      getAppleNewAppVer(
        forceUpdate: true,
        context: context,
        downloadUrl: '',
        fromPage: true, // 弹框提示用户 最新版本
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // use this button to open the multi-select dialog
            ElevatedButton(
              child: const Text('视频播放'),
              onPressed: (){
                Get.to(()=> DemoSuperPlayer());
              },
            ),
            const Divider(
              height: 30,
            ),
            ElevatedButton(
              child: const Text('XUpdatePage'),
              onPressed: (){
                Get.to(()=> const XUpdatePage());
              },
            ),
            const Divider(
              height: 30,
            ),
            // SaveDataPage
            ElevatedButton(
              child: const Text('files'),
              onPressed: (){
                Get.to(()=> const SaveDataPage());
              },
            ),
            const Divider(
              height: 30,
            ),
            ElevatedButton(
              child: const Text('版本更新'),
              onPressed: (){
                // checkAppUpdateVersion();
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
                    return const Dialog(
                      backgroundColor: Colors.transparent, // 背景颜色
                      child: UpdateAppVersion(
                        // TODO: 传入新版本APP相关参数、版本号、更新内容、下载地址等
                        version:  '2.6.1', // 版本号
                        info: ['111','222'] , // 更新内容介绍
                        // ios是苹果应用商店地址
                        // https://apps.apple.com/cn/app/%E5%BE%B7%E5%93%81%E5%BE%AE%E6%8A%A4%E6%8A%A4%E5%A3%AB%E7%AB%AF/id1490788981?uo=4
                        // itms-apps://apps.apple.com/cn/app/%E5%BE%B7%E5%93%81%E5%BE%AE%E6%8A%A4%E6%8A%A4%E5%A3%AB%E7%AB%AF/id1490788981?uo=4
                        iosUrl: 'http://36.152.50.211:8089/api/admin/apk',
                        androidUrl: 'http://36.152.50.211:8089/api/admin/apk',
                        filename: 'nurseTraining.apk',
                      ),
                    );
                  },
                ).then((v) {

                });



              },
            ),
            const Divider(
              height: 30,
            ),
            // display selected items
            Wrap(
              children: _selectedItems
                  .map((e) => Chip(
                label: Text(e),
              ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
