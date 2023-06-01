

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateInstr extends StatelessWidget {
  final List<String> data;

  const UpdateInstr({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int len = data.length /*?? 0*/;
    return Container(
      height: 120,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          for (var i = 0; i < len; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${i + 1}、${data[i]}',
                style: const TextStyle(fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }


}
