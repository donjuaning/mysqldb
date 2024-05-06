/*
 * @Author: DonJuaning
 * @Date: 2024-04-29 10:35:02
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-06 20:16:54
 * @FilePath: /mysqldb/lib/pages/add_connection.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:mysqldb/tool/sizeFit.dart';
import 'package:mysqldb/perfence.dart';

class addConnection extends StatefulWidget {
  addConnection({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<addConnection> createState() => _addConnectionState();
}

class _addConnectionState extends State<addConnection> {
  // ignore: prefer_final_fields
  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _dbController = TextEditingController();
  void _save() {
    var myCount = int.parse(LocalStorage.get("my_connect")) + 1;
    LocalStorage.save("my_connect", myCount.toString());
    var connection_setting = _ipController.text +
        ":" +
        _portController.text +
        ":" +
        _userController.text +
        ":" +
        _passwordController.text +
        ":" +
        _dbController.text;
    LocalStorage.save("connect_$myCount", connection_setting);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: ClipRRect(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      controller: _ipController, //设置controller
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'ip地址',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    color: Colors.white,
                    height: 56.rpx,
                    alignment: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(12.rpx),
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      controller: _portController, //设置controller
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: '3306',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    color: Colors.white,
                    height: 56.rpx,
                    alignment: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(12.rpx),
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      controller: _userController, //设置controller
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: '用户名',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    color: Colors.white,
                    height: 56.rpx,
                    alignment: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(12.rpx),
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      controller: _passwordController, //设置controller
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: '密码',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    color: Colors.white,
                    height: 56.rpx,
                    alignment: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(12.rpx),
                ),
              ),
            ]),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      controller: _dbController, //设置controller
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: '数据库名',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    color: Colors.white,
                    height: 56.rpx,
                    alignment: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(12.rpx),
                ),
              ),
            ]),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        tooltip: 'Increment',
        child: const Icon(Icons.save),
      ),
    );
  }
}
