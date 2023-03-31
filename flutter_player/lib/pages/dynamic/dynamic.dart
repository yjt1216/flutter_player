import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';


class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DynamicPage> {
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<int>>();

  final myKey = GlobalKey<DropdownSearchState<MultiLevelString>>();
  final List<MultiLevelString> myItems = [
    MultiLevelString(level1: "1"),
    MultiLevelString(level1: "2"),
    MultiLevelString(
      level1: "3",
      subLevel: [
        MultiLevelString(level1: "sub3-1"),
        MultiLevelString(level1: "sub3-2"),
      ],
    ),
    MultiLevelString(level1: "4")
  ];

  List<String> levelOptions = [
    "全部",
    "市级",
    "省级",
    "国家级",
    "其他"
  ];

  List<String> scoreOptions = [
    "请选择",
    "一类学分",
    "二类学分"
  ];

  List<String> learnOptions = [
    "院内学习",
    "院外学习"
  ];



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("DropdownSearch Demo")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(4),
            children: <Widget>[

              const Padding(padding: EdgeInsets.all(8)),
              const Divider(),
              DropdownSearch<int>(
                key: _openDropDownProgKey,
                items: const [1, 2, 3],
                selectedItem: 1,
              ),
              const Padding(padding: EdgeInsets.all(4)),

              // 单选
              DropdownSearch<String>(
                mode: Mode.MENU,
                // popupTitle: Text('单选'),
                showSelectedItems: true,
                selectedItem: levelOptions.first,
                items: levelOptions,
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Menu mode",
                  hintText: "country in menu mode",
                ),
                //不能选中
                popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (changeValue){
                  log('message $changeValue');
                },

              ),

              // 多选
              DropdownSearch<String>.multiSelection(
                mode: Mode.MENU,
                showSelectedItems: true,
                items: learnOptions,
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Menu mode",
                  hintText: "country in menu mode",
                ),
                popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: print,
                selectedItems: const ["Brazil"],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: const [
                        Text("进修名称: ",style: TextStyle(fontSize: 15,color: Colors.black),)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: DropdownSearch<String>(
                      mode: Mode.MENU,
                      // popupTitle: Text('单选'),
                      showSelectedItems: true,
                      selectedItem: "Brazil",
                      items: const ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada','Inter'],
                      //不能选中
                      popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (changeValue){
                        log('message');
                      },

                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }


}

class _CheckBoxWidget extends StatefulWidget {
  final Widget child;
  final bool? isSelected;
  final ValueChanged<bool?>? onChanged;

  const _CheckBoxWidget({required this.child, this.isSelected, this.onChanged});

  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<_CheckBoxWidget> {
  bool? isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant _CheckBoxWidget oldWidget) {
    if (widget.isSelected != isSelected) isSelected = widget.isSelected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0x88F44336),
            Colors.blue,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Select: '),
              Checkbox(
                  value: isSelected,
                  tristate: true,
                  onChanged: (bool? v) {
                    v ??= false;
                    setState(() {
                      isSelected = v;
                      if (widget.onChanged != null) widget.onChanged!(v);
                    });
                  }),
            ],
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class MultiLevelString {
  final String level1;
  final List<MultiLevelString> subLevel;
  bool isExpanded;

  MultiLevelString({
    this.level1 = "",
    this.subLevel = const [],
    this.isExpanded = false,
  });

  MultiLevelString copy({
    String? level1,
    List<MultiLevelString>? subLevel,
    bool? isExpanded,
  }) =>
      MultiLevelString(
        level1: level1 ?? this.level1,
        subLevel: subLevel ?? this.subLevel,
        isExpanded: isExpanded ?? this.isExpanded,
      );

  @override
  String toString() => level1;
}