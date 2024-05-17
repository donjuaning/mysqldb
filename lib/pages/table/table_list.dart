/*
 * @Author: DonJuaning
 * @Date: 2024-05-07 11:01:29
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-17 17:48:29
 * @FilePath: /mysqldb/lib/pages/table/table_list.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:mysqldb/tool/sizeFit.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysqldb/tool/common.dart';
import 'package:mysqldb/pages/table/new_table.dart';

class TableList extends StatefulWidget {
  const TableList({Key? key, required this.setting}) : super(key: key);
  final String setting;

  @override
  State<TableList> createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  List<Widget> itemList = [];
  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("数据库列表"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: 280.rpx,
                    height: 280.rpx,
                    child: FloatingActionButton.extended(
                      heroTag: "btn1",
                      onPressed: () {
                        _add_table(widget.setting);
                      },
                      backgroundColor: Colors.teal,
                      icon: const Icon(Icons.add),
                      label: const Text("新建数据表"),
                    )),
                Container(
                    width: 280.rpx,
                    height: 280.rpx,
                    child: FloatingActionButton.extended(
                      heroTag: "btn2",
                      onPressed: () {},
                      backgroundColor: Colors.teal,
                      icon: const Icon(Icons.add),
                      label: const Text("新建sql"),
                    )),
              ],
            ),
            Container(
              child: KanKanFutureBuilder().fb(query(), buildListView),
            )
          ],
        ),
      ),
    );
  }

  void _add_table(setting) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTable(setting: setting)),
    ).then((value) => refresh());
  }

  Widget buildListView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: itemList,
      physics: new NeverScrollableScrollPhysics(),
    );
  }

  Widget _setListItem(BuildContext context, String tableName) {
    return Container(
        width: 80.rpx,
        height: 80.rpx,
        child: TextButton(
          child: Text(
            tableName,
          ),
          onPressed: () {},
        ));
  }

  Future<void> query() async {
    List<String> mySetting = widget.setting.split(":");
    String dbName = mySetting[4];
    var settings = ConnectionSettings(
        host: mySetting[0],
        port: int.parse(mySetting[1]),
        user: mySetting[2],
        password: mySetting[3],
        db: mySetting[4]);
    var conn = await MySqlConnection.connect(settings);
    var results = await conn.query('show tables;');
    print(results);
    List tableList = results.toList();
    itemList.clear();
    for (var i = 0; i < tableList.length; i++) {
      itemList.add(_setListItem(context, tableList[i]["Tables_in_$dbName"]));
    }
  }
}
