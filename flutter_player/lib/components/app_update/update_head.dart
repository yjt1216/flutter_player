import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateHeader extends StatelessWidget {
  //UpdateHeader({required this.version});

  /// 最新版本号
  final String version;
  final String headerImg = 'assets/images/up_header.png';
  final Color strColor = Colors.white; // 文字颜色
  final double boxHeight = 100;// 盒子高度

  const UpdateHeader({Key? key, required this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 100,
      child: Stack(
        children: <Widget>[
          // 背景图
          Image(
            width: double.infinity,
            height: 150,
            image: AssetImage(headerImg),
            fit: BoxFit.fill,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
              children: <Widget>[
                Text(
                  '发现新版本',
                  style: TextStyle(
                    color: strColor,
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
          ),
        ],
      ),
    );
  }
}