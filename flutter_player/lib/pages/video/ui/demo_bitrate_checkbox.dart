// Copyright (c) 2022 Tencent. All rights reserved.
import 'package:flutter/material.dart';

typedef TestBitrateCheckboxFinishCallback = void Function(
    int value);

class DemoBitrateCheckbox extends StatefulWidget {
  List supportedBitrates;
  int index;
  TestBitrateCheckboxFinishCallback callback;

  DemoBitrateCheckbox(this.supportedBitrates, this.index, this.callback, {Key? key}) : super(key: key);

  @override
  _DemoBitrateCheckboxState createState() => _DemoBitrateCheckboxState();
}

class _DemoBitrateCheckboxState extends State<DemoBitrateCheckbox> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () async {
          Navigator.of(context).pop();
          widget.callback(widget.index);
        },
        child: Container(
          color: const Color.fromARGB(180, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.supportedBitrates.map((e) {
              String s = e["index"].toString();
              return Row(
                children: [
                  Text("码率$s", style: const TextStyle(color: Colors.white),),
                  Theme(data: ThemeData(
                    unselectedWidgetColor: Colors.white,),
                    child: Radio<int> (
                      value: e["index"],
                      groupValue: widget.index,
                      onChanged: (value) {
                        setState(() {
                          widget.index = value!;
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),));
  }
}
