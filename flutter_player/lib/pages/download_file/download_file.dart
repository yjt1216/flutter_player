import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SaveDataPage extends StatefulWidget {
  const SaveDataPage({Key? key}) : super(key: key);

  @override
  _SaveDataPageState createState() => _SaveDataPageState();
}

class _SaveDataPageState extends State<SaveDataPage> {
  final _textFieldController = TextEditingController();
  var _saveString = '';

  //利用文件存储数据
  saveString() async {
    final file = await getFile('file.text');
    //写入字符串
    file.writeAsString(_textFieldController.value.text.toString());
  }

  //获取存在文件中的数据
  Future getString() async {
    final file = await getFile('file.text');
    var filePath  = file.path;
    print('获取存在文件中的数据 ${filePath}');
    setState(() {
      file.readAsString().then((String value) {
        _saveString = value +'\n文件存储路径：'+filePath;
      });
    });
  }

  //初始化文件路径
  Future<File> getFile(String fileName) async {
    //获取应用文件目录类似于iOS的NSDocumentDirectory和Android上的 AppData目录
    final fileDirectory = await getApplicationDocumentsDirectory();

    //获取存储路径
    final filePath = fileDirectory.path;

    //或者file对象（操作文件记得导入import 'dart:io'）
    return File(filePath + "/"+fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据存储'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("文件存储", textAlign: TextAlign.center),
          TextField(
            controller: _textFieldController,
          ),
          MaterialButton(
            onPressed: saveString,
            child: const Text("存储"),
            color: Colors.cyan,
          ),
          MaterialButton(
            onPressed: getString,
            child: const Text("获取"),
            color: Colors.deepOrange,
          ),
          Text('存储的值为  $_saveString'),
        ],
      ),
    );
  }
}
