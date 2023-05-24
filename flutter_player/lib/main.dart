import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_player/pages/tab_bar/tab_bar.dart';
import 'package:flutter_player/pages/video/demo_superplayer.dart';
import 'package:flutter_player/pages/video/res/app_localization_delegate.dart';
import 'package:get/get.dart';
import 'package:super_player/super_player.dart';

import 'package:superplayer_widget/demo_superplayer_lib.dart';


void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String? _liteAVSdkVersion = 'Unknown';
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPlayerLicense();
    _getflutterSdkVersion();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    LogUtils.logOpen = true;
  }

  /// set player license
  Future<void> initPlayerLicense() async{
    String licenceURL = "https://license.vod2.myqcloud.com/license/v2/1257623900_1/v_cube.license"; // 获取到的 licence url
    String licenceKey = "acdf6d4c3d9a8244f823657706cb8cf6"; // 获取到的 licence key
    await SuperPlayerPlugin.setGlobalLicense(licenceURL, licenceKey);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SuperPlayerPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion!;
    });
    TXPipController.instance.setNavigatorHandle((params) {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => DemoSuperPlayer(initParams: params)));
    });

    SuperPlayerPlugin.setGlobalMaxCacheSize(200);
    SuperPlayerPlugin.setGlobalCacheFolderPath("postfixPath");
  }

  Future<void> _getflutterSdkVersion() async {
    String? liteavSdkVersion = await SuperPlayerPlugin.getLiteAVSDKVersion();
    setState(() {
      _liteAVSdkVersion = liteavSdkVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationDelegate.delegate
      ],
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'en'),
        Locale.fromSubtags(languageCode: 'zh'),
      ],
      navigatorKey: navigatorKey,
      home: PersistentBottomPage(menuScreenContext: context,),
      builder: EasyLoading.init(),
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

