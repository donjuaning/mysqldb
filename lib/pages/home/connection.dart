/*
 * @Author: DonJuaning
 * @Date: 2024-05-06 19:06:33
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-07 17:07:04
 * @FilePath: /mysqldb/lib/pages/home/connection.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:mysqldb/perfence.dart';
import 'package:mysqldb/tool/sizeFit.dart';
import 'package:mysqldb/pages/add_connection.dart';
import 'package:mysqldb/pages/table/table_list.dart';
import 'package:mysqldb/tool/common.dart';

class connection extends StatefulWidget {
  const connection({Key? key}) : super(key: key);

  @override
  State<connection> createState() => _connectionState();
}

class _connectionState extends State<connection> {
  List<Widget> itemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: KanKanFutureBuilder().fb(_getConnection(), buildListView),
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: itemList,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _add_push() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => addConnection(title: '新建连接')),
    ).then((value) => refresh());
  }

  void _connection_push(String connectiondata) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TableList(setting: connectiondata)),
    ).then((value) => refresh());
  }

  Widget _setListItem(BuildContext context, int index) {
    var connectiondata = LocalStorage.get("connect_$index");
    print(connectiondata);
    return Container(
        width: 80.rpx,
        height: 80.rpx,
        child: TextButton(
          child: Text(
            connectiondata,
          ),
          onPressed: () {
            _connection_push(connectiondata);
          },
        ));
  }

  Widget _setAddItem(BuildContext context) {
    return Container(
        width: 80.rpx,
        height: 80.rpx,
        child: FloatingActionButton.extended(
          heroTag: "btn1",
          onPressed: _add_push,
          backgroundColor: Colors.teal,
          icon: const Icon(Icons.add),
          label: const Text("新建"),
        ));
  }

  Future<void> _getConnection() async {
    await LocalStorage.initSP();
    itemList.clear();
    var myCount = int.parse(LocalStorage.get("my_connect"));
    for (int i = 1; i <= myCount; i++) {
      itemList.add(_setListItem(context, i));
    }
    itemList.add(_setAddItem(context));
  }
}
